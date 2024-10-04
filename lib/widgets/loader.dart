import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Center(
                child: Lottie.asset(
                  'assets/images/Animation - 1728036991950.json',
                  height: 180,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Please wait..',
                    style: TextStyle(
                      color: AppThemeData.black,
                      fontSize: 16,
                      fontFamily: AppThemeData.medium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }
}
