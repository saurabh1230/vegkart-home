import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/payment/RazorPayFailedModel.dart';
import 'package:ebasket_customer/payment/createRazorPayOrderModel.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/payment_method_model.dart';
import 'package:ebasket_customer/payment/MercadoPagoScreen.dart';
import 'package:ebasket_customer/payment/PayFastScreen.dart';
import 'package:ebasket_customer/payment/getPaytmTxtToken.dart';
import 'package:ebasket_customer/payment/paystack/pay_stack_screen.dart';
import 'package:ebasket_customer/payment/paystack/pay_stack_url_model.dart';
import 'package:ebasket_customer/payment/paystack/paystack_url_genrater.dart';
import 'package:ebasket_customer/payment/stripe_failed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/controller/razorpay_controller.dart';
import 'package:ebasket_customer/app/model/notification_payload_model.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/app/ui/order_details_screen/order_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/constant/send_notification.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:uuid/uuid.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../utils/theme/light_theme.dart';

class PaymentOptionsController extends GetxController {
  RxString selectedPaymentMethod = "".obs;
  HomeController homeController = Get.find<HomeController>();
  Rx<OrderModel> orderModel = OrderModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString totalAmount = ''.obs;
  RxBool walletBalanceError = false.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    getPaymentData();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;

    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      totalAmount.value = argumentData['totalAmount'];
      walletBalanceError.value = double.parse(orderModel.value.user!.walletAmount.toString()) < double.parse(totalAmount.value.toString()) ? true : false;

    }
    update();
  }

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
        Stripe.publishableKey = paymentModel.value.strip!.clientpublishableKey.toString();
        Stripe.merchantIdentifier = 'GoRide';
        Stripe.instance.applySettings();
        setRef();

        razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
        razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
        razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      }
    });

    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);

    isLoading.value = false;
  }

  String? _ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  razorpayPayment() {
    RazorPayController().createOrderRazorPay(amount: double.parse(totalAmount.value.toString()).floor(), razorpayModel: paymentModel.value.razorpay).then((value) {
      if (value == null) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      } else {
        CreateRazorPayOrderModel result = value;
        openCheckout(amount: totalAmount.value.toString(), orderId: result.id);
      }
    });
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Successful!!");
    orderPlaced();
  }

  void handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Processing!! via");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    RazorPayFailedModel lom = RazorPayFailedModel.fromJson(jsonDecode(response.message!.toString()));
    ShowToastDialog.showToast("Payment Failed!!");
  }

  orderPlaced() async {
    orderModel.value.paymentMethod = selectedPaymentMethod.value.toString();

  //  orderModel.value.id = 'GB${const Uuid().v4().split("-").elementAt(0)}';
    orderModel.value.status = Constant.inProcess;
    await FireStoreUtils.getDriver(orderModel.value.address!.pinCode.toString()).then((value) async {
      if (value != null) {
        orderModel.value.driver = value;

        orderModel.value.driverID = value.id;
        Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": orderModel.value.id};
        if (orderModel.value.driver != null) {
          await SendNotification.sendOneNotification(
              token: orderModel.value.driver!.fcmToken.toString(), title: 'Order Placed', body: '${orderModel.value.user!.fullName.toString()} Booking placed.', payload: playLoad);
          NotificationPayload notificationPayload = NotificationPayload(
              id: Constant.getUuid(),
              userId: orderModel.value.driverID!,
              title: 'Order Placed',
              body: '${orderModel.value.user!.fullName.toString()} Booking placed.',
              createdAt: Timestamp.now(),
              role: Constant.USER_ROLE_DRIVER,
              notificationType: "order",
              orderId: orderModel.value.id);

          await FireStoreUtils.placeOrder(orderModel.value).then((value) async {
            if (value == true) {
              await FireStoreUtils.setNotification(notificationPayload).then((value) {});
              await FireStoreUtils.sendOrderEmail(orderModel:orderModel.value);
              Future.delayed(const Duration(seconds: 2), () async {
                Get.back();
                Get.back();

                showOrderSuccessDialog(
                  orderModel.value.id,
                );
              });
            }
          });
        }
      } else {

        await FireStoreUtils.placeOrder(orderModel.value).then((value) async {
          if (value == true) {
            await FireStoreUtils.sendOrderEmail(orderModel:orderModel.value);
            Future.delayed(const Duration(seconds: 2), () async {
              Get.back();
              Get.back();

              showOrderSuccessDialog(
                orderModel.value.id,
              );
            });
          }
        });
      }
    });

    for (int i = 0; i < orderModel.value.products.length; i++) {
      await FireStoreUtils.getProductByProductId(orderModel.value.products[i].id.split('~').first).then((value) async {
        ProductModel? productModel = value;
        if (orderModel.value.products[i].variant_info != null) {
          for (int j = 0; j < productModel!.itemAttributes!.variants!.length; j++) {
            if (productModel.itemAttributes!.variants![j].variantId == orderModel.value.products[i].id.split('~').last) {
              if (productModel.itemAttributes!.variants![j].variantQuantity != "-1") {
                productModel.itemAttributes!.variants![j].variantQuantity =
                    (int.parse(productModel.itemAttributes!.variants![j].variantQuantity.toString()) - orderModel.value.products[i].quantity).toString();
              }
            }
          }
        } else {
          if (productModel!.quantity != -1) {
            productModel.quantity = productModel.quantity! - orderModel.value.products[i].quantity;
          }
        }

        await FireStoreUtils.updateProduct(productModel).then((value) {
          log("-----------2>${value!.toJson()}");
        });
      });
    }
  }

  showOrderSuccessDialog(String orderId) {
    Get.dialog(Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: AppThemeData.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    homeController.cartDatabase.value.deleteAllProducts();
                  },
                  child: SvgPicture.asset(
                    "assets/icons/ic_cancel.svg",
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              "assets/icons/ic_order_success.svg",
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Order Place Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppThemeData.black, fontSize: 36, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "You have successfully made order",
              style: TextStyle(color: AppThemeData.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: RoundedButtonGradiant(
                title: "View Order Details",
                icon: false,
                onPress: () {
                  Get.back();
                  // Get.back();
                  // Get.back();
                  //  homeController.cartDatabase.value.deleteAllProducts();
                  Get.to(const OrderDetailsScreen(), arguments: {
                    "orderId": orderId,
                  })!
                      .then((value) {
                    homeController.cartDatabase.value.deleteAllProducts();
                  });
                },
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  final Razorpay razorPay = Razorpay();

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': paymentModel.value.razorpay!.razorpayKey,
      'amount': amount * 100,
      'name': 'eBasket Customer',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': orderModel.value.user!.phoneNumber,
        'email': orderModel.value.user!.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Strip
  Future<void> stripeMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                  currencyCode: "USD",
                ),
                style: ThemeMode.system,
                customFlow: true,
                appearance: PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: appColor,
                  ),
                ),
                merchantDisplayName: 'GoRide'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.showToast("Payment successfully");
        orderPlaced();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": orderModel.value.user!.fullName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(paymentModel.value.strip!.stripeSecret.toString());
      var stripeSecret = paymentModel.value.strip!.stripeSecret;
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body, headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'});

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  //mercadoo
  mercadoPagoMakePayment({required BuildContext context, required String amount}) {
    makePreference(amount).then((result) async {
      if (result.isNotEmpty) {
        var preferenceId = result['response']['id'];
        log(result.toString());
        log(preferenceId);

        Get.to(MercadoPagoScreen(initialURl: result['response']['init_point']))!.then((value) {
          log(value);

          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            orderPlaced();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
        // final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MercadoPagoScreen(initialURl: result['response']['init_point'])));
      } else {
        ShowToastDialog.showToast("Error while transaction!");
      }
    });
  }

  Future<Map<String, dynamic>> makePreference(String amount) async {
    final mp = MP.fromAccessToken(paymentModel.value.mercadoPago!.accessToken);
    var pref = {
      "items": [
        {"title": "Wallet TopUp", "quantity": 1, "unit_price": double.parse(amount)}
      ],
      "auto_return": "all",
      "back_urls": {"failure": "${Constant.globalUrl}payment/failure", "pending": "${Constant.globalUrl}payment/pending", "success": "${Constant.globalUrl}payment/success"},
    };

    var result = await mp.createPreference(pref);
    return result;
  }

  ///PayStack Payment Method
  payStackPayment(String totalAmount) async {
    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(totalAmount) * 100).toString(), currency: "NGN", secretKey: paymentModel.value.payStack!.secretKey.toString(), userModel: orderModel.value.user!)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.secretKey.toString(),
          callBackUrl: paymentModel.value.payStack!.callbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            orderPlaced();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      }
    });
  }

  //flutter wave Payment Method
  flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    final flutterWave = Flutterwave(
      amount: amount.trim(),
      currency: "NGN",
      customer: Customer(name: orderModel.value.user!.fullName, phoneNumber: orderModel.value.user!.phoneNumber, email: orderModel.value.user!.email.toString()),
      context: context,
      publicKey: paymentModel.value.flutterWave!.publicKey.toString().trim(),
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(title: "GoRide"),
      txRef: _ref!,
      isTestMode: paymentModel.value.flutterWave!.isSandbox!,
      redirectUrl: '${Constant.globalUrl}success',
      paymentPlanId: _ref!,
    );
    final ChargeResponse response = await flutterWave.charge();

    if (response.success!) {
      ShowToastDialog.showToast("Payment Successful!!");
      orderPlaced();
    } else {
      ShowToastDialog.showToast(response.status!);
    }
  }

  // payFast
  payFastPayment({required BuildContext context, required String amount}) {
    PayStackURLGen.getPayHTML(payFastSettingData: paymentModel.value.payfast!, amount: amount.toString(), userModel: orderModel.value.user!).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(htmlData: value!, payFastSettingData: paymentModel.value.payfast!));
      if (isDone) {
        ShowToastDialog.showToast("Payment successfully");
        orderPlaced();
      } else {
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }

  ///Paytm payment function
  getPaytmCheckSum(context, {required double amount}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String getChecksum = "${Constant.globalUrl}payments/getpaytmchecksum";

    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paymentModel.value.paytm!.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paymentModel.value.paytm!.merchantKey.toString(),
        });

    final data = jsonDecode(response.body);
    log(paymentModel.value.paytm!.paytmMID.toString());

    await verifyCheckSum(checkSum: data["code"], amount: amount, orderId: orderId).then((value) {
      initiatePayment(amount: amount, orderId: orderId).then((value) {
        String callback = "";
        if (paymentModel.value.paytm!.isSandbox == true) {
          callback = "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        } else {
          callback = "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        }

        GetPaymentTxtTokenModel result = value;
        startTransaction(context, txnTokenBy: result.body.txnToken, orderId: orderId, amount: amount, callBackURL: callback, isStaging: paymentModel.value.paytm!.isSandbox);
      });
    });
  }

  Future<void> startTransaction(context, {required String txnTokenBy, required orderId, required double amount, required callBackURL, required isStaging}) async {
    try {
      var response = AllInOneSdk.startTransaction(
        paymentModel.value.paytm!.paytmMID.toString(),
        orderId,
        amount.toString(),
        txnTokenBy,
        callBackURL,
        isStaging,
        true,
        true,
      );

      response.then((value) {
        if (value!["RESPMSG"] == "Txn Success") {
          log("txt done!!");
          ShowToastDialog.showToast("Payment Successful!!");
          orderPlaced();
        }
      }).catchError((onError) {
        if (onError is PlatformException) {
          Get.back();

          ShowToastDialog.showToast(onError.message.toString());
        } else {
          log("======>>2");
          Get.back();
          ShowToastDialog.showToast(onError.message.toString());
        }
      });
    } catch (err) {
      Get.back();
      ShowToastDialog.showToast(err.toString());
    }
  }

  Future verifyCheckSum({required String checkSum, required double amount, required orderId}) async {
    String getChecksum = "${Constant.globalUrl}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paymentModel.value.paytm!.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paymentModel.value.paytm!.merchantKey.toString(),
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);
    return data['status'];
  }

  Future<GetPaymentTxtTokenModel> initiatePayment({required double amount, required orderId}) async {
    String initiateURL = "${Constant.globalUrl}payments/initiatepaytmpayment";
    String callback = "";
    if (paymentModel.value.paytm!.isSandbox == true) {
      callback = "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback = "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }
    final response = await http.post(Uri.parse(initiateURL), headers: {}, body: {
      "mid": paymentModel.value.paytm!.paytmMID,
      "order_id": orderId,
      "key_secret": paymentModel.value.paytm!.merchantKey,
      "amount": amount.toString(),
      "currency": "INR",
      "callback_url": callback,
      "custId": FireStoreUtils.getCurrentUid(),
      "issandbox": paymentModel.value.paytm!.isSandbox == true ? "1" : "2",
    });
    log(response.body);
    final data = jsonDecode(response.body);
    if (data["body"]["txnToken"] == null || data["body"]["txnToken"].toString().isEmpty) {
      Get.back();
      ShowToastDialog.showToast("something went wrong, please contact admin.");
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  paypalPaymentSheet(String amount) {
    //add 1 item to cart. Max is 4!
    initPayPal();
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          // random prices
          amount: double.parse(amount),

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }

    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }

  void initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode = paymentModel.value.paypal!.isSandbox == true ? true : false;

    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.parkme://paypalpay",
      //client id from developer dashboard
      clientID: paymentModel.value.paypal!.paypalClient.toString(),
      //sandbox, staging, live etc
      payPalEnvironment: paymentModel.value.paypal!.isSandbox == true ? FPayPalEnvironment.sandbox : FPayPalEnvironment.live,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          ShowToastDialog.showToast("Payment canceled");
        },
        onSuccess: (data) {
          //successfully paid
          //remove all items from queue
          _flutterPaypalNativePlugin.removeAllPurchaseItems();
          ShowToastDialog.showToast("Payment successfully");
          orderPlaced();
        },
        onError: (data) {
          //an error occured
          ShowToastDialog.showToast("error: ${data.reason}");
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          ShowToastDialog.showToast("shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
        },
      ),
    );
  }
}
