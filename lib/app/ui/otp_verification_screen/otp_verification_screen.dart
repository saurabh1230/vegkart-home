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

            ),
          );
        });
  }
}
