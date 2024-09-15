// import 'dart:convert';
//
// import 'package:ebasket_customer/app/model/address_model.dart';
// import 'package:ebasket_customer/constant/constant.dart';
// import 'package:ebasket_customer/utils/theme/light_theme.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:ebasket_customer/app/controller/global_setting_controller.dart';
// import 'package:ebasket_customer/app/splash_screen.dart';
// import 'package:ebasket_customer/firebase_options.dart';
// import 'package:ebasket_customer/services/localization_service.dart';
// import 'package:ebasket_customer/services/preferences.dart';
// import 'package:ebasket_customer/theme/styles.dart';
// import 'package:ebasket_customer/utils/dark_theme_provider.dart';
// import 'package:ebasket_customer/services/localDatabase.dart'; // Import your database file
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//
//
//   const staticAddressData = {
//     "id": "33eILoLjJld2zpw6nIYEa7mqWrc2",
//     "address": "1300-5, Relief Rd, Nagar Sheths Vando, Gheekanta, Bhadra, Ahmedabad, Gujarat 380001, India",
//     "landmark": "Near City Center",
//     "locality": "Ahmedabad",
//     "pinCode": "380001",
//     "location": {
//       "latitude": 22.991724,
//       "longitude": 72.526444
//     },
//     "isDefault": true,
//     "addressAs": "BusinessAddress"
//   };
//
//   // Create an instance of AddressModel from static data
//   final address = AddressModel.fromJson(staticAddressData);
//
//   // Set static address data to Constant
//   Constant.selectedPosition = address;
//
//   // Print the address instance
//   print('Address Model:');
//   print('ID: ${address.id}');
//   print('Address: ${address.address}');
//   print('Landmark: ${address.landmark}');
//   print('Locality: ${address.locality}');
//   print('PinCode: ${address.pinCode}');
//   print('Is Default: ${address.isDefault}');
//   print('Address As: ${address.addressAs}');
//   print('Full Address: ${address.getFullAddress()}');
//
//   // Convert the AddressModel instance back to JSON
//   final addressJson = address.toJson();
//   print('Address JSON: ${jsonEncode(addressJson)}');
//
//   // Validate if the JSON conversion works correctly
//   final addressFromJson = AddressModel.fromJson(jsonDecode(jsonEncode(addressJson)));
//   print('Address from JSON:');
//   print('ID: ${addressFromJson.id}');
//   print('Address: ${addressFromJson.address}');
//   print('Landmark: ${addressFromJson.landmark}');
//   print('Locality: ${addressFromJson.locality}');
//   print('PinCode: ${addressFromJson.pinCode}');
//   print('Is Default: ${addressFromJson.isDefault}');
//   print('Address As: ${addressFromJson.addressAs}');
//   print('Full Address: ${addressFromJson.getFullAddress()}');
//
//   // Initialize the singleton database instance
//   final CartDatabase database = CartDatabase();
//
//
//   // Initialize Firebase
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       name: 'vegkart',
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//
//   // Initialize preferences
//   await Preferences.initPref();
//
//
//   // Run the app
//   runApp(MultiProvider(
//     providers: [
//       Provider<CartDatabase>.value(value: database), // Provide the singleton instance
//     ],
//     child: const MyApp(),
//   ));
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => MyAppState();
// }
//
// class MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   DarkThemeProvider themeChangeProvider = DarkThemeProvider();
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     // getCurrentAppTheme();
//     WidgetsBinding.instance.addObserver(this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//     super.initState();
//   }
//
//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   getCurrentAppTheme();
//   // }
//   //
//   // void getCurrentAppTheme() async {
//   //   themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//
//
//       ChangeNotifierProvider(
//       create: (_) => themeChangeProvider,
//       child: Consumer<DarkThemeProvider>(
//         builder: (context, value, child) {
//           return GetMaterialApp(
//             title: 'eBasket'.tr,
//             debugShowCheckedModeBanner: false,
//             theme: light,
//             // theme: Styles.themeData(
//             //     themeChangeProvider.darkTheme == 0
//             //         ? true
//             //         : themeChangeProvider.darkTheme == 1
//             //         ? false
//             //         : themeChangeProvider.getSystemThem(),
//             //     context),
//             locale: LocalizationService.locale,
//             fallbackLocale: LocalizationService.locale,
//             translations: LocalizationService(),
//             builder: EasyLoading.init(),
//             navigatorKey: navigatorKey,
//             home: GetBuilder<GlobalSettingController>(
//               init: GlobalSettingController(),
//               builder: (context) {
//                 return const SplashScreen();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/utils/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
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

  const staticAddressData = {
    "id": "33eILoLjJld2zpw6nIYEa7mqWrc2",
    "address": "1300-5, Relief Rd, Nagar Sheths Vando, Gheekanta, Bhadra, Ahmedabad, Gujarat 380001, India",
    "landmark": "Near City Center",
    "locality": "Ahmedabad",
    "pinCode": "380001",
    "location": {
      "latitude": 22.991724,
      "longitude": 72.526444
    },
    "isDefault": true,
    "addressAs": "BusinessAddress"
  };

  // Create an instance of AddressModel from static data
  final address = AddressModel.fromJson(staticAddressData);

  // Set static address data to Constant
  Constant.selectedPosition = address;

  // Print the address instance
  print('Address Model:');
  print('ID: ${address.id}');
  print('Address: ${address.address}');
  print('Landmark: ${address.landmark}');
  print('Locality: ${address.locality}');
  print('PinCode: ${address.pinCode}');
  print('Is Default: ${address.isDefault}');
  print('Address As: ${address.addressAs}');
  print('Full Address: ${address.getFullAddress()}');

  // Convert the AddressModel instance back to JSON
  final addressJson = address.toJson();
  print('Address JSON: ${jsonEncode(addressJson)}');

  // Validate if the JSON conversion works correctly
  final addressFromJson = AddressModel.fromJson(jsonDecode(jsonEncode(addressJson)));
  print('Address from JSON:');
  print('ID: ${addressFromJson.id}');
  print('Address: ${addressFromJson.address}');
  print('Landmark: ${addressFromJson.landmark}');
  print('Locality: ${addressFromJson.locality}');
  print('PinCode: ${addressFromJson.pinCode}');
  print('Is Default: ${addressFromJson.isDefault}');
  print('Address As: ${addressFromJson.addressAs}');
  print('Full Address: ${addressFromJson.getFullAddress()}');

  // Initialize the singleton database instance
  final CartDatabase database = CartDatabase();

  // Initialize Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'vegkart',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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

