import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/app/model/notification_payload_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/ui/otp_verification_screen/otp_verification_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/constant/send_notification.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/notification_service.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SignupController extends GetxController {
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> businessAddressController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailAddressController = TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  RxString verificationID = "".obs;
  Rx<TextEditingController> countryCode = TextEditingController(text: "+91").obs;
  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  RxBool fromOTP = false.obs;
  auth.UserCredential? userCredential;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      countryCode.value.text = argumentData['countryCode'];
      mobileNumberController.value.text = argumentData['phoneNumber'];
      fromOTP.value = argumentData["fromOTP"];
      userCredential = argumentData["userCredentials"];
    }
    update();
  }

  sendCode() async {
    ShowToastDialog.showLoader("Please Wait".tr);

    await auth.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode.value.text + mobileNumberController.value.text,
      verificationCompleted: (auth.PhoneAuthCredential credential) async {
        // If verification is complete, sign in the user automatically.
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
        // Optionally, call registerUser() to create the user in Firestore
        registerUser();
      },
      verificationFailed: (auth.FirebaseAuthException e) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(e.code == 'invalid-phone-number'
            ? "Invalid Phone Number"
            : e.code);
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();

        // Create user model to pass to OTPVerificationScreen
        UserModel user = UserModel(
          fullName: fullNameController.value.text,
          countryCode: countryCode.value.text,
          phoneNumber: mobileNumberController.value.text,
          email: emailAddressController.value.text,
          role: Constant.USER_ROLE_CUSTOMER,
          shippingAddress: shippingAddressList,
        );

        Get.to(OTPVerificationScreen(), arguments: {
          'user': user,
          'countryCode': countryCode.value.text,
          'phoneNumber': mobileNumberController.value.text,
          'verificationId': verificationId,
          'fromSignup': true,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    ).catchError((error) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple Time Request".tr);
    });
  }

  RxList<AddressModel>? shippingAddressList = <AddressModel>[].obs;

  registerUser() async {
    ShowToastDialog.showLoader("Please Wait".tr);
    // Create the user object
    UserModel user = UserModel(
      fullName: fullNameController.value.text,
      countryCode: countryCode.value.text,
      phoneNumber: mobileNumberController.value.text,
      email: emailAddressController.value.text,
      fcmToken: await NotificationService.getToken(),
      role: Constant.USER_ROLE_CUSTOMER,
      shippingAddress: shippingAddressList,
      active: true,
      id: userCredential!.user?.uid ?? '',
      createdAt: Timestamp.now(),
    );

    // Save the user to Firestore
    String? errorMessage = await FireStoreUtils.firebaseCreateNewUser(user);
    if (errorMessage != null) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Couldn't create new user.");
      return;
    }

    Constant.currentUser = user;
    Get.offAll(const DashBoardScreen());
    ShowToastDialog.closeLoader();
  }
}
