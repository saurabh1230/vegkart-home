import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/add_new_card_controller.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';

import '../../../utils/theme/light_theme.dart';

class AddNewCard extends StatelessWidget {
  const AddNewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AddNewCardController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title:  Text(
                  "Add New Card".tr,
                  style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20),
                ),
                isBack: true),
            body: SingleChildScrollView(
              child: SizedBox(
                width: Responsive.width(100, context),
                height: Responsive.height(100, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    CreditCardWidget(
                      cardNumber: controller.cardNumber.value,
                      expiryDate: controller.expiryDate.value,
                      cardHolderName: controller.cardHolderName.value,
                      cvvCode: controller.cvv.value,
                      labelValidThru: 'Expiry Date'.tr,
                      showBackView: false,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      cardBgColor: appColor.withOpacity(0.50),
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              formKey: controller.globalKey.value,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: controller.cardNumber.value,
                              cvvCode: controller.cvv.value,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: controller.cardHolderName.value,
                              expiryDate: controller.expiryDate.value,
                              onCreditCardModelChange: controller.onCreditCardModel,
                              // cvvValidationMessage: 'Please input a valid CVV',
                              // dateValidationMessage: 'Please input a valid date',
                              // numberValidationMessage: 'Please input a valid number',
                              inputConfiguration: InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0),
                                  ),
                                  labelStyle: const TextStyle(color: AppThemeData.black),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Card Number'.tr,
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0),
                                  ),
                                  labelStyle: const TextStyle(color: AppThemeData.black),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0),
                                  ),
                                  labelStyle: const TextStyle(color: AppThemeData.black),
                                  border: const OutlineInputBorder(),
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppThemeData.black.withOpacity(0.50), width: 1.0),
                                  ),
                                  labelStyle: const TextStyle(color: AppThemeData.black),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Card Holder'.tr,
                                ),
                                cardNumberTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: AppThemeData.black,
                                ),
                                cardHolderTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: AppThemeData.black,
                                ),
                                expiryDateTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: AppThemeData.black,
                                ),
                                cvvCodeTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: AppThemeData.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: RoundedButtonGradiant(
                                title: "Add New Card",
                                onPress: () {
                                  if (controller.globalKey.value.currentState!.validate()) {
                                    ShowToastDialog.showLoader("Please Wait".tr);
                                    controller.setCard();
                                    log('valid!');
                                  } else {
                                    log('invalid!');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
