import 'package:ebasket_customer/app/ui/location_permission_screen/location_permission_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/images.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:ebasket_customer/utils/styles.dart';
import 'package:ebasket_customer/widgets/custom_button_widget.dart';
import 'package:ebasket_customer/widgets/custom_textfield.dart';
import 'package:ebasket_customer/widgets/underline_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_customer/app/ui/signup_screen/signup_screen.dart';
import 'package:ebasket_customer/widgets/mobile_number_textfield.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/login_controller.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/light_theme.dart';
import '../dashboard_screen/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: Form(
            key: controller.formKey.value,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppThemeData.white,
              body: Stack(
                children: [
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
                          'LOGIN',
                          textAlign: TextAlign.start,
                          style: montserratSemiBold.copyWith(
                              fontSize: Dimensions.fontSize24,
                              color: Theme.of(context).primaryColor),
                        ),
                        sizedBox30(),
                        Text(
                          'Enter Your Phone Number to Login',
                          style: montserratMedium.copyWith(
                              fontSize: Dimensions.fontSize13),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSize100),
                          child: MobileNumberTextField(
                            title: "Enter Mobile Number *".tr,
                            read: false,
                            controller: controller.mobileNumberController.value,
                            countryCodeController: controller.countryCode.value,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validation: (value) {
                              String pattern = r'(^\+?[0-9]*$)';
                              RegExp regExp = RegExp(pattern);
                              if (value!.isEmpty) {
                                return 'Mobile Number is required'.tr;
                              } else if (!regExp.hasMatch(value)) {
                                return 'Mobile Number must be digits'.tr;
                              }
                              return null;
                            },
                            onPress: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: Dimensions.paddingSizeDefault,
                    left: Dimensions.paddingSizeDefault,
                    right: Dimensions.paddingSizeDefault,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignupScreen());
                          },
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: "New to Vegkaart ? ",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: AppThemeData.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' SignUp',
                                  style: TextStyle(
                                    color: appColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.medium,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomButtonWidget(
                          buttonText: 'Continue',
                          color: Theme.of(context).primaryColor,
                          isBold: true,
                          onPressed: () {
                            if (controller.formKey.value.currentState!.validate()) {
                              controller.sendCode();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
