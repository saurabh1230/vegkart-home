// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ebasket_customer/app/model/user_model.dart';
// import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
// import 'package:ebasket_customer/app/ui/otp_verification_screen/otp_verification_screen.dart';
// import 'package:ebasket_customer/constant/constant.dart';
// import 'package:ebasket_customer/constant/send_notification.dart';
// import 'package:ebasket_customer/services/firebase_helper.dart';
// import 'package:ebasket_customer/services/notification_service.dart';
// import 'package:ebasket_customer/services/show_toast_dialog.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
//
// class LoginController extends GetxController {
//   // Controllers for mobile number and country code
//   Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
//   Rx<TextEditingController> countryCode = TextEditingController(text: "+91").obs;
//   Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
//
//   // Firebase user credential
//   auth.UserCredential? userCredential;
//
//   // Used to store the verification ID for OTP
//   RxString verificationID = "".obs;
//
//   // OTP related flag
//   RxBool fromOTP = false.obs;
//
//   @override
//   void onInit() {
//     getArgument();
//     super.onInit();
//   }
//
//   // Get arguments if coming from OTP screen
//   getArgument() async {
//     dynamic argumentData = Get.arguments;
//
//     if (argumentData != null) {
//       // Debug prints to check values
//       print("Argument Data: $argumentData");
//
//       // Check for null values and assign
//       if (argumentData['countryCode'] != null) {
//         countryCode.value.text = argumentData['countryCode'];
//       } else {
//         print("Country Code is null");
//       }
//
//       if (argumentData['phoneNumber'] != null) {
//         mobileNumberController.value.text = argumentData['phoneNumber'];
//       } else {
//         print("Phone Number is null");
//       }
//
//       if (argumentData["fromOTP"] != null) {
//         fromOTP.value = argumentData["fromOTP"];
//       } else {
//         print("fromOTP is null");
//       }
//
//       if (argumentData["userCredentials"] != null) {
//         userCredential = argumentData["userCredentials"];
//       } else {
//         print("User Credentials is null");
//       }
//     }
//     update();
//   }
//
//   // Function to send OTP to the provided mobile number
//   sendCode() async {
//     ShowToastDialog.showLoader("Please Wait".tr);
//     await auth.FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: countryCode.value.text + mobileNumberController.value.text,
//       verificationCompleted: (auth.PhoneAuthCredential credential) {},
//       verificationFailed: (auth.FirebaseAuthException e) {
//         ShowToastDialog.closeLoader();
//         if (e.code == 'invalid-phone-number') {
//           ShowToastDialog.showToast("Invalid Phone Number");
//         } else {
//           ShowToastDialog.showToast(e.code);
//         }
//       },
//       codeSent: (String verificationId, int? resendToken, ) {
//         ShowToastDialog.closeLoader();
//
//         // Navigate to OTP screen with required arguments
//         Get.to(OTPVerificationScreen(), arguments: {
//           "countryCode": countryCode.value.text,
//           "phoneNumber": mobileNumberController.value.text,
//           "verificationId": verificationId,
//           "fromSignup": true,
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     ).catchError((error) {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast("Error: ${error.toString()}".tr);
//     });
//   }
//
//   // Function to verify OTP and sign in/register user
//
//   verifyOTP(String otp) async {
//     ShowToastDialog.showLoader("Verifying OTP...".tr);
//
//     try {
//       // Create phone auth credential using the verification ID and the OTP
//       auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
//         verificationId: verificationID.value,
//         smsCode: otp,
//       );
//
//
//       userCredential = await auth.FirebaseAuth.instance.signInWithCredential(credential);
//
//
//       if (userCredential != null) {
//         registerUser(); // This will register the user with mobile number
//       }
//
//       ShowToastDialog.closeLoader();
//     } catch (e) {
//       ShowToastDialog.closeLoader();
//       ShowToastDialog.showToast("Invalid OTP".tr);
//     }
//   }
//
//   // Function to register user by saving only the mobile number to Firestore
//   registerUser() async {
//     ShowToastDialog.showLoader("Registering User...".tr);
//     UserModel user = UserModel(
//       countryCode: countryCode.value.text,
//       phoneNumber: mobileNumberController.value.text,
//       id: userCredential!.user?.uid ?? '',
//       createdAt: Timestamp.now(),
//       fcmToken: await NotificationService.getToken(),
//       role: Constant.USER_ROLE_CUSTOMER,
//       active: true,
//     );
//
//     String? errorMessage = await FireStoreUtils.firebaseCreateNewUser(user);
//     if (errorMessage == null) {
//       Constant.currentUser = user;
//       print('check');
//       Get.offAll(const DashBoardScreen());
//     } else {
//       ShowToastDialog.showToast(errorMessage);
//     }
//
//     ShowToastDialog.closeLoader();
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/ui/otp_verification_screen/otp_verification_screen.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LoginController extends GetxController {
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCode =
      TextEditingController(text: "+91").obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  sendCode() async {
    ShowToastDialog.showLoader("Please Wait".tr);

    await auth.FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCode.value.text + mobileNumberController.value.text,
      verificationCompleted: (auth.PhoneAuthCredential credential) {},
      verificationFailed: (auth.FirebaseAuthException e) {
        debugPrint("FirebaseAuthException--->${e.message}");
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("Invalid Phone Number");
        } else {
          ShowToastDialog.showToast(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();

        Get.to( OTPVerificationScreen(), arguments: {
          "countryCode": countryCode.value.text,
          "phoneNumber": mobileNumberController.value.text,
          "verificationId": verificationId,
          "fromSignup": false,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple Time Request".tr);
    });
  }
}
