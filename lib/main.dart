
import 'dart:convert';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/notification_service.dart';
import 'package:ebasket_customer/utils/theme/light_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ebasket_customer/app/controller/global_setting_controller.dart';
import 'package:ebasket_customer/app/splash_screen.dart';
import 'package:ebasket_customer/firebase_options.dart';
import 'package:ebasket_customer/services/localization_service.dart';
import 'package:ebasket_customer/services/preferences.dart';
import 'package:ebasket_customer/services/localDatabase.dart'; // Import your database file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandle);

  await Firebase.initializeApp(

    name: 'vegkart',
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await FirebaseAppCheck.instance.activate(
    // androidProvider: AndroidProvider.debug,
    androidProvider: AndroidProvider.playIntegrity, // For Android
  );



  final CartDatabase database = CartDatabase();

  // Initialize Firebase
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     name: 'vegkart',
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  // Initialize preferences
  await Preferences.initPref();

  // Run the app
  runApp(MultiProvider(
    providers: [
      Provider<CartDatabase>.value(value: database), // Provide the singleton instance
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'eBasket'.tr,
      debugShowCheckedModeBanner: false,
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.locale,
      translations: LocalizationService(),
      builder: EasyLoading.init(),
      theme: light,
      navigatorKey: navigatorKey,
      home: GetBuilder<GlobalSettingController>(
        init: GlobalSettingController(),
        builder: (context) {
          return const SplashScreen();
        },
      ),
    );
  }
}


