import 'package:ebasket_customer/app/controller/profile_controller.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:ebasket_customer/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../app/model/address_model.dart';
import '../app/model/user_model.dart';
import '../app/ui/choose_language/choose_language_screen.dart';
import '../app/ui/login_screen/login_screen.dart';
import '../app/ui/notification_screen/notification_screen.dart';
import '../app/ui/order_screen/order_screen.dart';
import '../app/ui/profile_screen/profile_screen.dart';
import '../app/ui/termsAndCondition/terms_and_codition.dart';
import '../app/ui/wallet/wallet_screen.dart';
import '../constant/constant.dart';
import '../services/localDatabase.dart';
import '../services/show_toast_dialog.dart';
import '../utils/theme/light_theme.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    return GetBuilder(
        init: ProfileController(),
        builder: (controller) {
          return
            SafeArea(
              child: Scaffold(
                body: SafeArea(
                  child:
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          // width: Get.size.width,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSize20,horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/appbar_bg.png'),fit: BoxFit.cover),
                            color: Colors.green,
                          ),
                          child:
                          Row(
                            children: [
                              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new,
                                color: Theme.of(context).cardColor,
                              )),
                              Text('Menu',style: montserratSemiBold.copyWith(fontSize: Dimensions.fontSize20,
                                  color: Theme.of(context).cardColor),),


                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      Get.to(const ProfileScreen(), transition: Transition.rightToLeftWithFade);
                                    },
                                    child: settingView(
                                      title: "My Profile".tr,
                                      image: "assets/icons/ic_my_profile.svg",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (Constant.currentUser.id != null) {
                                        Get.to(const WalletScreen(), transition: Transition.rightToLeftWithFade);
                                      } else {
                                        Get.to( LoginScreen(), transition: Transition.rightToLeftWithFade);
                                      }
                                    },
                                    child: settingView(
                                      title: "My Wallet".tr,
                                      image: "assets/icons/icon_wallet.svg",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (controller.userModel.value.id != null) {
                                        Get.to(const MyOrderListScreen(), transition: Transition.rightToLeftWithFade);
                                      } else {
                                        Get.to( LoginScreen(), transition: Transition.rightToLeftWithFade);
                                      }
                                    },
                                    child: settingView(
                                      title: "My Orders".tr,
                                      image: "assets/icons/icon_myorder.svg",
                                    )),

                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      Get.to(const TermsAndCondition(
                                        type: "support",
                                      ));
                                    },
                                    child: settingView(
                                      title: "Help".tr,
                                      image: "assets/icons/ic_support.svg",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      Get.to(const NotificationScreen(), transition: Transition.rightToLeftWithFade);
                                    },
                                    child: settingView(title: "Notification".tr, image: "assets/icons/ic_notification.svg")),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () async {
                                      ShowToastDialog.showLoader("Please wait".tr);
                                      share();
                                    },
                                    child: settingView(title: "Share the App".tr, image: "assets/icons/ic_share.svg")),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      Get.to(const TermsAndCondition(
                                        type: "aboutUs",
                                      ));
                                    },
                                    child: settingView(title: "About Us".tr, image: "assets/icons/ic_about_us.svg")),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (Constant.currentUser.id == null) {
                                        Get.to( LoginScreen(), transition: Transition.rightToLeftWithFade);
                                      } else {
                                        logoutBottomSheet(context);
                                      }
                                    },
                                    child: settingView(title: Constant.currentUser.id == null ? "Login" : "Logout".tr, image: "assets/icons/ic_logout.svg")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        });


  }

  Widget settingView({required String title, image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image,
                  width: 32,
                  height: 32,
                  color: Colors.black,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppThemeData.black,
                      fontSize: 14,
                      fontFamily: AppThemeData.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset("assets/icons/ic_right.svg"),
        ],
      ),
    );
  }

  Future<void> share() async {
    ShowToastDialog.closeLoader();

    await FlutterShare.share(
      title: appName,
      text: 'https://app.eBasket.com',
    );
  }

  logoutBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: Get.height * 0.30,
            decoration: const BoxDecoration(
              color: AppThemeData.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'Logout'.tr,
                      style: TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 24, color: AppThemeData.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Are you sure you want to Logout?".tr,
                          maxLines: 2, style: TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppThemeData.white,
                              padding: const EdgeInsets.all(8),
                              side: BorderSide(color: appColor, width: 2),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'No'.tr,
                                style: TextStyle(color: appColor, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: appColor,
                              padding: const EdgeInsets.all(8),
                              side: BorderSide(color: appColor, width: 0.4),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Provider.of<CartDatabase>(context, listen: false).deleteAllProducts();
                              await FirebaseAuth.instance.signOut();
                              Constant.currentUser = UserModel();
                              Constant.selectedPosition = AddressModel();
                              Get.to( LoginScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'Yes'.tr,
                                style: const TextStyle(color: AppThemeData.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  InkWell buildContainer(
      BuildContext context,
      String title, {
        Color? color,
        required Function() tap,
      }) {
    return InkWell(
      onTap: tap,
      child: Container(
        width: Get.size.width,
        margin: const EdgeInsets.only(top: Dimensions.paddingSize10),
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeDefault,
          horizontal: Dimensions.paddingSize10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius5),
          color: color ?? Theme.of(context).primaryColor.withOpacity(0.04),
        ),
        child: Text(
          title,
        ),
      ),
    );
  }

}
