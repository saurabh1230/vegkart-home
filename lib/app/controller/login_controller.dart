import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/ui/otp_verification_screen/otp_verification_screen.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../ui/login_screen/login_screen.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCode = TextEditingController(text: "+91").obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var verificationId = ''.obs;

  void sendCode(String phoneNumber) async {
    ShowToastDialog.showLoader("Please Wait".tr);
    print("Attempting to send code to phone number: $phoneNumber");

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("Verification completed with credential: $credential");
          await _auth.signInWithCredential(credential);
          ShowToastDialog.closeLoader();
          print("User signed in automatically.");
          Get.off(DashBoardScreen()); // Navigate to dashboard
        },
        verificationFailed: (FirebaseAuthException e) {
          ShowToastDialog.closeLoader();
          debugPrint("Verification failed: ${e.message}");
          ShowToastDialog.showToast(e.code);
          print("Verification failed with code: ${e.code}");
        },
        codeSent: (String verificationId, int? resendToken) {
          ShowToastDialog.closeLoader();
          print("Code sent. Verification ID: $verificationId");
          Get.to(OTPVerificationScreen(), arguments: {
            "countryCode": countryCode.value.text,
            "phoneNumber": mobileNumberController.value.text,
            "verificationId": verificationId,
            "fromSignup": true,
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout for verification ID: $verificationId");
        },
      );
    } catch (e) {
      debugPrint("Error during phone verification: $e");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("An error occurred. Please try again.");
    }
  }

  void login(String phoneNumber) {
    ShowToastDialog.showLoader("Logging in...");
    print("Logging in with phone number: $phoneNumber");
    signInWithPhone(phoneNumber);
  }

  void signUp(String phoneNumber) {
    ShowToastDialog.showLoader("Signing up...");
    print("Signing up with phone number: $phoneNumber");
    sendOTP(phoneNumber);
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    print("Attempting to sign in with phone number: $phoneNumber");
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (auth.PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("User signed in successfully.");
        Get.off(DashBoardScreen());
      },
      verificationFailed: (auth.FirebaseAuthException e) {
        ShowToastDialog.closeLoader();
        debugPrint("FirebaseAuthException: ${e.message}");
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("Invalid Phone Number");
        } else {
          ShowToastDialog.showToast(e.code);
        }
        print("Verification failed with error: ${e.code}");
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        print("Code sent. Verification ID: $verificationId");
        Get.to(OTPVerificationScreen(), arguments: {
          "countryCode": countryCode.value.text,
          "phoneNumber": mobileNumberController.value.text,
          "verificationId": verificationId,
          "fromSignup": false, // Indicate that this is a login process
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ShowToastDialog.closeLoader();
        print("Auto retrieval timeout for verification ID: $verificationId");
      },
    ).catchError((error) {
      debugPrint("Error during verification: $error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple Time Request".tr);
    });
  }

  void sendOTP(String phoneNumber) {
    print("Attempting to send OTP to phone number: $phoneNumber");
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (auth.PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("User signed in successfully.");
        Get.off(DashBoardScreen());
      },
      verificationFailed: (auth.FirebaseAuthException e) {
        ShowToastDialog.closeLoader();
        debugPrint("FirebaseAuthException: ${e.message}");
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("Invalid Phone Number");
        } else {
          ShowToastDialog.showToast(e.code);
        }
        print("Verification failed with error: ${e.code}");
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        print("Code sent. Verification ID: $verificationId");
        Get.to(OTPVerificationScreen(), arguments: {
          "countryCode": countryCode.value.text,
          "phoneNumber": mobileNumberController.value.text,
          "verificationId": verificationId,
          "fromSignup": true,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ShowToastDialog.closeLoader();
        print("Auto retrieval timeout for verification ID: $verificationId");
      },
    ).catchError((error) {
      debugPrint("Error during sending OTP: $error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Multiple Time Request".tr);
    });
  }

  Future<void> verifyOTP(String otp) async {
    print("Verifying OTP: $otp");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId.value,
      smsCode: otp,
    );

    await _auth.signInWithCredential(credential).then((result) {
      print("User signed in successfully after OTP verification.");
      Get.off(DashBoardScreen());
    }).catchError((error) {
      print("Error during OTP verification: $error");
    });
  }

  Future<User?> getCurrentUser() async {
    User? user = _auth.currentUser;
    print("Current user: ${user?.phoneNumber}");
    return user;
  }

  Future<void> signOut() async {
    print("Signing out user.");
    await _auth.signOut();
  }

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print("User is signed in: ${user.phoneNumber}");
        Get.off(DashBoardScreen());
      } else {
        print("User is signed out.");
        Get.off(LoginScreen());
      }
    });
  }
}
