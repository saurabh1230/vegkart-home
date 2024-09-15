import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/images.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:ebasket_customer/utils/styles.dart';
import 'package:ebasket_customer/widgets/custom_button_widget.dart';
import 'package:ebasket_customer/widgets/mobile_number_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/otp_verification_controller.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:pinput/pinput.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
class OTPVerificationScreen extends StatelessWidget {
   OTPVerificationScreen({super.key});
  // final _otpController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OtpVerificationController(),
        builder: (controller) {
          return Form(
            // key: _formKey,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppThemeData.white,
              body: Stack(
                children: [
                  // Background image positioned at the bottom
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        Images.authBg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Your form content
                  Container(
                    height: Get.height,
                    width: Get.width,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(16.0),
                    // Add padding if needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sizedBox75(),
                        Center(
                          child: Image.asset(
                            Images.logo,
                            height: 200,
                          ),
                        ),
                        Text(
                          'OTP Verification',
                          textAlign: TextAlign.start,
                          style: montserratSemiBold.copyWith(
                              fontSize: Dimensions.fontSize24,
                              color: Theme.of(context).primaryColor),
                        ),
                        sizedBox30(),
                        Text(
                          'We have send verification code to you number',
                          style: montserratMedium.copyWith(
                              fontSize: Dimensions.fontSize13),
                        ),

                        // Your form widgets go here
                      ],
                    ),
                  ),
            Center(
                          child: Pinput(
                            keyboardType: TextInputType.number,
                            length: 6,
                            controller: controller.pinController.value,
                            androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                            defaultPinTheme: PinTheme(
                              width: 46,
                              height: 46,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                color: AppThemeData.assetColorGrey600,
                              ),
                              decoration:
                                  BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.30))),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 46,
                              height: 46,
                              decoration:
                                  BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.30))),
                            ),
                            separatorBuilder: (index) => const SizedBox(width: 8),
                          ),
                        ),
                  Positioned(
                    bottom: Dimensions.paddingSizeDefault,
                    left: Dimensions.paddingSizeDefault,
                    right: Dimensions.paddingSizeDefault,
                    child: CustomButtonWidget(
                      buttonText: 'Continue',
                      color: Theme.of(context).primaryColor,
                      isBold: true,
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   controller.submitCode();
                        // }
                        if (controller.pinController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter otp".tr);
                        } else {
                          if (controller.pinController.value.text.length == 6) {
                            controller.submitCode();
                            // Get.to(const ProfileReadySuccessfullyScreen());
                          } else {
                            ShowToastDialog.showToast("Enter valid otp".tr);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              // appBar: AppBar(
              //   title: Text("Login".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              //   backgroundColor: AppThemeData.white,
              //   automaticallyImplyLeading: false,
              //   elevation: 0,
              //   titleSpacing: 0,
              //   centerTitle: true,
              //   surfaceTintColor: AppThemeData.white,
              // ),
              // body: Form(
              //   key: controller.formKey.value,
              //   child: Container(
              //     height: Get.size.height,
              //     alignment: Alignment.bottomCenter,
              //     decoration:BoxDecoration(
              //       image: DecorationImage(image: AssetImage(Images.authBg),
              //         fit: BoxFit.cover,)
              //     ),
              //   ),
              //
              //
              //
              //   // Stack(
              //   //   children: [
              //   //     Column(
              //   //       // mainAxisAlignment: MainAxisAlignment.center,
              //   //       crossAxisAlignment: CrossAxisAlignment.start,
              //   //       children: [
              //   //         sizedBox75(),
              //   //         Center(
              //   //             child: Image.asset(
              //   //           Images.logo,
              //   //           height: 200,
              //   //         )),
              //   //         // SvgPicture.asset("assets/images/login_image.svg"),
              //   //         // const SizedBox(
              //   //         //   height: 10,
              //   //         // ),
              //   //         // Text("Welcome Back to eBasket".tr, style: TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w600)),
              //   //         // const SizedBox(
              //   //         //   height: 5,
              //   //         // ),
              //   //         // Text("Log in to access exclusive deals and a personalized shopping experience.".tr,
              //   //         //     textAlign: TextAlign.center,
              //   //         //     style: TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: AppThemeData.assetColorGrey600, fontWeight: FontWeight.w600)),
              //   //         // CustomTextField(
              //   //         //   hintText: 'Enter Mobile No',
              //   //         // ),
              //   //         // UnderlineCustomTextField(
              //   //         //   isPhone: true,
              //   //         //   hintText: 'Enter your Phone number',
              //   //         //   isNumber: true,
              //   //         //
              //   //         //   inputType: TextInputType.number,
              //   //         //   controller:  controller.mobileNumberController.value,
              //   //         //   validation: (value) {
              //   //         //     String pattern = r'(^\+?[0-9]*$)';
              //   //         //     RegExp regExp = RegExp(pattern);
              //   //         //     if (value!.isEmpty) {
              //   //         //       return 'Mobile Number is required'.tr;
              //   //         //     } else if (!regExp.hasMatch(value)) {
              //   //         //       return 'Mobile Number must be digits'.tr;
              //   //         //     }
              //   //         //     return null;
              //   //         //   },
              //   //         // ),
              //   //         Padding(
              //   //           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              //   //           child: Column(
              //   //             crossAxisAlignment: CrossAxisAlignment.start,
              //   //             children: [
              //   //               Text(
              //   //                 'LOGIN',
              //   //                 textAlign: TextAlign.start,
              //   //                 style: montserratSemiBold.copyWith(
              //   //                     fontSize: Dimensions.fontSize24,
              //   //                     color: Theme.of(context).primaryColor),
              //   //               ),
              //   //               sizedBox30(),
              //   //               Text('Enter Your Phone Number to Login',
              //   //               style: montserratMedium.copyWith(fontSize: Dimensions.fontSize13),),
              //   //               Padding(
              //   //                 padding: const EdgeInsets.symmetric(vertical: 0.0),
              //   //                 child: MobileNumberTextField(
              //   //                   title: "Enter Mobile Number *".tr,
              //   //                   read: false,
              //   //                   controller: controller.mobileNumberController.value,
              //   //                   countryCodeController: controller.countryCode.value,
              //   //                   inputFormatters: [
              //   //                     LengthLimitingTextInputFormatter(10),
              //   //                   ],
              //   //                   validation: (value) {
              //   //                     String pattern = r'(^\+?[0-9]*$)';
              //   //                     RegExp regExp = RegExp(pattern);
              //   //                     if (value!.isEmpty) {
              //   //                       return 'Mobile Number is required'.tr;
              //   //                     } else if (!regExp.hasMatch(value)) {
              //   //                       return 'Mobile Number must be digits'.tr;
              //   //                     }
              //   //                     return null;
              //   //                   },
              //   //                   onPress: () {},
              //   //                 ),
              //   //               ),
              //   //             ],
              //   //           ),
              //   //         ),
              //   //         // Padding(
              //   //         //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   //         //   child: RoundedButtonGradiant(
              //   //         //     title: "Continue".tr,
              //   //         //     icon: true,
              //   //         //     onPress: () {
              //   //         //       if (controller.formKey.value.currentState!.validate()) {
              //   //         //         controller.sendCode();
              //   //         //       }
              //   //         //     },
              //   //         //   ),
              //   //         // ),
              //   //         // const SizedBox(
              //   //         //   height: 10,
              //   //         // ),
              //   //
              //   //         // Center(
              //   //         //   child: Text.rich(
              //   //         //     textAlign: TextAlign.center,
              //   //         //     TextSpan(
              //   //         //       text: "${'Not a member ?'.tr} ",
              //   //         //       style: const TextStyle(
              //   //         //         fontWeight: FontWeight.w500,
              //   //         //         fontSize: 12,
              //   //         //         fontFamily: AppThemeData.medium,
              //   //         //         color: AppThemeData.black,
              //   //         //       ),
              //   //         //       children: <TextSpan>[
              //   //         //         TextSpan(
              //   //         //           recognizer: TapGestureRecognizer()
              //   //         //             ..onTap = () {
              //   //         //               Get.to(const SignupScreen());
              //   //         //             },
              //   //         //           text: 'Signup'.tr,
              //   //         //           style: TextStyle(
              //   //         //             color: appColor,
              //   //         //             fontWeight: FontWeight.w500,
              //   //         //             fontSize: 12,
              //   //         //             fontFamily: AppThemeData.medium,
              //   //         //             decoration: TextDecoration.underline,
              //   //         //           ),
              //   //         //         ),
              //   //         //       ],
              //   //         //     ),
              //   //         //   ),
              //   //         // ),
              //   //         // const SizedBox(
              //   //         //   height: 10,
              //   //         // ),
              //   //         // SizedBox(height: 10),
              //   //         // Padding(
              //   //         //   padding: const EdgeInsets.symmetric(vertical: 8),
              //   //         //   child: RoundedButtonGradiant(
              //   //         //     width: Responsive.width(5, context),
              //   //         //     title: "Skip".tr,
              //   //         //     onPress: () async {
              //   //         //       LocationPermission permission = await Geolocator.checkPermission();
              //   //         //       if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
              //   //         //         if (Constant.currentUser.shippingAddress == null) {
              //   //         //           Get.to(LocationPermissionScreen(), transition: Transition.rightToLeftWithFade);
              //   //         //         } else {
              //   //         //           Get.offAll(const DashBoardScreen());
              //   //         //         }
              //   //         //       } else {
              //   //         //         Get.to(LocationPermissionScreen(), transition: Transition.rightToLeftWithFade);
              //   //         //       }
              //   //         //     },
              //   //         //   ),
              //   //         // ),
              //   //       ],
              //   //     ),
              //   //     Positioned(
              //   //       bottom: 0,
              //   //       left: 0,
              //   //       right: 0,
              //   //       child: Container(
              //   //         height: 250,
              //   //         decoration: BoxDecoration(
              //   //           image: DecorationImage(image: AssetImage(Images.authBg,),fit: BoxFit.cover)
              //   //         ),
              //   //         child: CustomButtonWidget(
              //   //           buttonText: 'Continue',
              //   //           color: Theme.of(context).primaryColor,
              //   //           isBold: true,
              //   //           onPressed: () {
              //   //             if (controller.formKey.value.currentState!
              //   //                 .validate()) {
              //   //               controller.sendCode();
              //   //             }
              //   //           },
              //   //         ),
              //   //       ),
              //   //     )
              //   //   ],
              //   // ),
              // ),
            ),
          );

          //   Scaffold(
          //   backgroundColor: AppThemeData.white,
          //   appBar: CommonUI.customAppBar(context,
          //       title:  Text(
          //         "OTP Verification".tr,
          //         style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20),
          //       ),
          //       isBack: true),
          //   body: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: SingleChildScrollView(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           SvgPicture.asset("assets/images/login_image.svg"),
          //           const SizedBox(
          //             height: 12,
          //           ),
          //           Center(
          //             child: Text(
          //               "Enter Verification Code".tr,
          //               style: const TextStyle(color: AppThemeData.black, fontSize: 20, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 8,
          //           ),
          //           Center(
          //             child: Column(
          //               children: [
          //                 Text(
          //                   "We have sent sms to:".tr,
          //                   style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w400),
          //                 ),
          //                 Text(
          //                   "${controller.countryCode.toString()}××××××××××",
          //                   style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w400),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 60,
          //           ),
          //           Center(
          //             child: Pinput(
          //               keyboardType: TextInputType.number,
          //               length: 6,
          //               controller: controller.pinController.value,
          //               androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
          //               defaultPinTheme: PinTheme(
          //                 width: 46,
          //                 height: 46,
          //                 textStyle: const TextStyle(
          //                   fontSize: 22,
          //                   color: AppThemeData.assetColorGrey600,
          //                 ),
          //                 decoration:
          //                     BoxDecoration(color: AppThemeData.colorLightWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: appColor)),
          //               ),
          //               focusedPinTheme: PinTheme(
          //                 width: 46,
          //                 height: 46,
          //                 decoration:
          //                     BoxDecoration(color: AppThemeData.colorLightWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: appColor)),
          //               ),
          //               separatorBuilder: (index) => const SizedBox(width: 8),
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 60,
          //           ),
          //           InkWell(
          //             onTap: () {
          //               controller.pinController.value.clear();
          //               controller.sendOTP();
          //             },
          //             child: Center(
          //               child: Text(
          //                 "Resend OTP".tr,
          //                 style: const TextStyle(
          //                   height: 1.2,
          //                   color: Colors.black,
          //                   fontSize: 14,
          //                   fontFamily: AppThemeData.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //
          //           Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //             child: RoundedButtonGradiant(
          //               title: "Continue".tr,
          //               icon: true,
          //               onPress: () {
          //                 if (controller.pinController.value.text.isEmpty) {
          //                   ShowToastDialog.showToast("Please enter otp".tr);
          //                 } else {
          //                   if (controller.pinController.value.text.length == 6) {
          //                     controller.submitCode();
          //                     // Get.to(const ProfileReadySuccessfullyScreen());
          //                   } else {
          //                     ShowToastDialog.showToast("Enter valid otp".tr);
          //                   }
          //                 }
          //               },
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        });
  }
}
