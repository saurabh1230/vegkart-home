import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:ebasket_customer/app/model/my_card.dart';
import 'package:ebasket_customer/app/ui/add_new_card/add_new_card.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/my_card_controller.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';

import '../../../utils/theme/light_theme.dart';

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: CardController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title:  Text("My Card".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true, onBackTap: () {
              Get.back();
            }),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: controller.isLoading.value
                    ? Constant.loader()
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.cardList.length,
                        itemBuilder: (context, index) {
                          CardData card = controller.cardList[index];
                          return CreditCardWidget(
                            cardNumber: card.cardNumber.toString(),
                            expiryDate: card.expiryDate.toString(),
                            cardHolderName: card.cardHolderName.toString(),
                            cvvCode: card.cvvCode.toString(),
                            showBackView: false,
                            onCreditCardWidgetChange: (CreditCardBrand brand) {},
                            cardBgColor: Colors.blue,
                            glassmorphismConfig: Glassmorphism(
                                blurX: 15.0,
                                blurY: 15.0,
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[appColor.withOpacity(0.3), appColor.withOpacity(0.7)])),
                            enableFloatingCard: true,
                            labelValidThru: 'Expiry Date'.tr,
                            obscureCardNumber: false,
                            obscureInitialCardNumber: true,
                            obscureCardCvv: true,
                            labelCardHolder: 'Card Holder Name'.tr,
                            isHolderNameVisible: true,
                            height: 175,
                            textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                            width: MediaQuery.of(context).size.width,
                            isChipVisible: false,
                            isSwipeGestureEnabled: false,
                            frontCardBorder: Border.all(color: appColor),
                            backCardBorder: Border.all(color: appColor),
                            chipColor: Colors.red,
                           // padding: 16,
                          );
                        }),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: appColor,
              onPressed: () {
                Get.to(const AddNewCard(), transition: Transition.rightToLeftWithFade)!.then((value) {
                  controller.getCardData();
                });
              },
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        });
  }
}
