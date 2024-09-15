import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:ebasket_customer/app/model/my_card.dart';
import 'package:ebasket_customer/app/model/notification_payload_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/constant/send_notification.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/notification_service.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';

class AddNewCardController extends GetxController {
  Rx<GlobalKey<FormState>> globalKey = GlobalKey<FormState>().obs;
  RxString cardNumber = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cvv = ''.obs;
  RxString cardType = ''.obs;
  Rx<CardData> cardModel = CardData().obs;

  void onCreditCardModel(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber.toString();
    expiryDate.value = creditCardModel.expiryDate.toString();
    cardHolderName.value = creditCardModel.cardHolderName.toString();
    cvv.value = creditCardModel.cvvCode.toString();
  }

  setCard() async {
    CardData card = CardData(
        id: Constant.getUuid(),
        cardHolderName: cardHolderName.value,
        cardNumber: cardNumber.value,
        cvvCode: cvv.value,
        expiryDate: expiryDate.value,
        // userId: expiryDate.getCurrentUid()
    );
    NotificationPayload notificationPayload = NotificationPayload(
        id: Constant.getUuid(),
        userId: FireStoreUtils.getCurrentUid(),
        title: "Debit Card added Successfully",
        body: "Debit Card added Successfully",
        createdAt: Timestamp.now(),
        role: Constant.USER_ROLE_CUSTOMER,
        notificationType: "debitCardAdd");

    Map<String, dynamic> playLoad = <String, dynamic>{
      "type": "debitCardAdd",
    };

    await SendNotification.sendOneNotification(
        token: await NotificationService.getToken(),
        title: "Debit Card added Successfully",
        body: "Debit Card added Successfully",
        payload: playLoad);

    await FireStoreUtils.setCard(card).then((value) async {
      if (value == true) {
        ShowToastDialog.closeLoader();
        await FireStoreUtils.setNotification(notificationPayload)
            .then((value) {});
        Get.back();
      } else {
        ShowToastDialog.closeLoader();
      }
    });
  }
}
