import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'Montserrat',
  primaryColor:  Colors.green,
  highlightColor: Color(0xffFABE14),
  secondaryHeaderColor: const Color(0xFF000743),
  disabledColor: const Color(0xFF000000),
  brightness: Brightness.light,
  hintColor: const Color(0xFF000000).withOpacity(0.30),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFF419354))), colorScheme: const ColorScheme.light(primary: Color(0xFF419354), secondary: Color(0xFF419354)).copyWith(error: const Color(0xFF419354)),
);
const Color redColor = Colors.redAccent;
const Color brownColor = Color(0xff977663);
const Color greenColor = Color(0xff5BC679);
const Color greyColor = Color(0xff83A2AF);
const Color skyColor = Color(0xff46C8D0);
const Color darkBlueColor = Color(0xff517DA5);
const Color darkPinkColor = Color(0xffBC6868);
const Color appColor = Colors.green;
