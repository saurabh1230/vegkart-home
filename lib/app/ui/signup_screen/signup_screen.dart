import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/utils/images.dart';
import 'package:ebasket_customer/utils/theme/light_theme.dart';
import 'package:ebasket_customer/widgets/custom_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/widgets/mobile_number_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/signup_controller.dart';
import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../constant/constant.dart';
import '../../../services/helper.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SignupController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: AppBar(
              title: Text("Registration".tr,
                  style: const TextStyle(
                    color: AppThemeData.black,
                    fontFamily: AppThemeData.semiBold,
                    fontSize: 20,
                  )),
              backgroundColor: AppThemeData.white,
              elevation: 0,
              titleSpacing: 0,
              centerTitle: true,
              surfaceTintColor: AppThemeData.white,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          Images.logo,
                          height: 180,
                        ),
                      ),
                      TextFieldWidget(
                        controller: controller.fullNameController.value,
                        hintText: "Full Name".tr,
                        title: "Enter Full Name *".tr,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z ]"))
                        ],
                        validation: (value) {
                          String pattern = r'(^[a-zA-Z ]*$)';
                          RegExp regExp = RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Full Name must be valid'.tr;
                          }
                          return null;
                        },
                        textInputType: TextInputType.text,
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/icons/ic_user.svg", height: 22, width: 22),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          AddressModel addressModel = AddressModel();
                          checkPermission(
                                () async {
                              try {
                                await Geolocator.requestPermission();

                                await Geolocator.getCurrentPosition();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                      apiKey: 'AIzaSyBNB2kmkXSOtldNxPdJ6vPs_yaiXBG6SSU',
                                      onPlacePicked: (result) {
                                        controller.businessAddressController.value.text = result.formattedAddress.toString();
                                        // controller.locationLatLng.value = LocationLatLng(latitude: result.geometry!.location.lat, longitude: result.geometry!.location.lng);
                                        addressModel.id = Uuid().v4();
                                        addressModel.locality = result.formattedAddress!.toString();
                                        addressModel.location = UserLocation(latitude: result.geometry!.location.lat, longitude: result.geometry!.location.lng);
                                        for (int i = 0; i < result.addressComponents!.length; i++) {
                                          if (result.addressComponents![i].types.contains('postal_code')) {
                                            addressModel.pinCode = result.addressComponents![i].longName;
                                          }
                                        }
                                        addressModel.isDefault = true;
                                        Constant.selectedPosition = addressModel;
                                        controller.shippingAddressList!.add(addressModel);

                                        Get.back();
                                      },
                                      initialPosition: const LatLng(-33.8567844, 151.213108),
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      usePinPointingSearch: true,
                                      usePlaceDetailSearch: true,
                                      zoomGesturesEnabled: true,
                                      zoomControlsEnabled: true,
                                      initialMapType: MapType.terrain,
                                      resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                                    ),
                                  ),
                                );
                              } catch (e) {
                                await placemarkFromCoordinates(19.228825, 72.854118).then((valuePlaceMaker) {
                                  Placemark placeMark = valuePlaceMaker[0];
                                  String currentLocation =
                                      "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                                  controller.businessAddressController.value.text = currentLocation;
                                  // controller.locationLatLng.value = LocationLatLng(latitude: 19.228825, longitude: 72.854118);
                                  addressModel.id = Uuid().v4();
                                  addressModel.location = UserLocation(latitude: 19.228825, longitude: 72.854118);
                                  addressModel.locality = currentLocation;
                                  addressModel.pinCode = placeMark.postalCode.toString();
                                  addressModel.isDefault = true;
                                  Constant.selectedPosition = addressModel;
                                  controller.shippingAddressList!.add(addressModel);
                                });
                              }
                            },
                          );
                        },
                        child: TextFieldWidget(
                          controller: controller.businessAddressController.value,
                          hintText: "Address".tr,
                          title: "Enter Address *".tr,
                          enable: false,
                          textInputType: TextInputType.text,
                          prefix: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset("assets/icons/ic_profile_add.svg", height: 22, width: 22),
                          ),
                        ),
                      ),
                      // TextFieldWidget(
                      //   controller: controller.mobileNumberController.value,
                      //   hintText: "Enter Mobile Number *".tr,
                      //   title: "Enter Mobile Number *".tr,
                      //   textInputType: TextInputType.number,
                      //   inputFormatters: [
                      //     LengthLimitingTextInputFormatter(10),
                      //   ],
                      //   validation: (value) {
                      //     String pattern = r'(^\+?[0-9]*$)';
                      //     RegExp regExp = RegExp(pattern);
                      //     if (value!.isEmpty) {
                      //       return 'Mobile Number is required'.tr;
                      //     } else if (!regExp.hasMatch(value)) {
                      //       return 'Mobile Number must be digits'.tr;
                      //     }
                      //     return null;
                      //   },
                      //   prefix: Padding(
                      //     padding: const EdgeInsets.all(4.0),
                      //     child: SvgPicture.asset("assets/icons/ic_email.svg", height: 22, width: 22),
                      //   ),
                      // ),
                      // MobileNumberTextField(
                      //   title: "Enter Mobile Number *".tr,
                      //   read: controller.fromOTP.value,
                      //   controller: controller.mobileNumberController.value,
                      //   countryCodeController: controller.countryCode.value,
                      //   inputFormatters: [
                      //     LengthLimitingTextInputFormatter(10),
                      //   ],
                      //   validation: (value) {
                      //     String pattern = r'(^\+?[0-9]*$)';
                      //     RegExp regExp = RegExp(pattern);
                      //     if (value!.isEmpty) {
                      //       return 'Mobile Number is required'.tr;
                      //     } else if (!regExp.hasMatch(value)) {
                      //       return 'Mobile Number must be digits'.tr;
                      //     }
                      //     return null;
                      //   },
                      //   onPress: () {},
                      // ),
                      TextFieldWidget(
                        controller: controller.mobileNumberController.value,
                        hintText: "Enter Mobile Number".tr,
                        title: "Enter Mobile Number".tr,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                        textInputType: TextInputType.number,
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
                        prefix: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.call,color: Theme.of(context).disabledColor,),
                        ),
                      ),
                      TextFieldWidget(
                        controller: controller.emailAddressController.value,
                        hintText: "Email Address".tr,
                        title: "Enter Email Address".tr,
                        textInputType: TextInputType.emailAddress,
                        validation: (value) {
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = RegExp(pattern);
                          if (value!.isNotEmpty) {
                            if (!regex.hasMatch(value)) {
                              return 'Enter valid e-mail'.tr;
                            } else {
                              return null;
                            }
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SvgPicture.asset("assets/icons/ic_email.svg", height: 22, width: 22),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomButtonWidget(buttonText: 'Next',
                        onPressed: () {
                              if (controller.formKey.value.currentState!.validate()) {
                                controller.sendCode();
                              }
                        },)

                        // RoundedButtonGradiant(
                        //   title: "Next".tr,
                        //   icon: true,
                        //   onPress: () async {
                        //     if (controller.formKey.value.currentState!.validate()) {
                        //       controller.sendCode();
                        //     }
                        //   },
                        // ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Get.offAll(const LoginScreen());
                        },
                        child: Center(
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: "${'Already a member ?'.tr} ",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: AppThemeData.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Login',
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
                      ),
                      // Center(
                      //   child: Text.rich(
                      //     textAlign: TextAlign.center,
                      //     TextSpan(
                      //       text: "${'Already a member ?'.tr} ",
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 12,
                      //         fontFamily: AppThemeData.medium,
                      //         color: AppThemeData.black,
                      //       ),
                      //       children: <TextSpan>[
                      //         TextSpan(
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () {
                      //               Get.offAll(const LoginScreen());
                      //             },
                      //           text: 'Login'.tr,
                      //           style: TextStyle(
                      //             color: AppThemeData.groceryAppDarkBlue,
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 12,
                      //             fontFamily: AppThemeData.medium,
                      //             decoration: TextDecoration.underline,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
