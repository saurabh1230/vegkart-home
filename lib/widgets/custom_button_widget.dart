import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isBold;
  final Color? borderSideColor;
  const CustomButtonWidget({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 10,
    this.icon,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isBold = true,
    this.borderSideColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
          ? Colors.transparent
          : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width ?? Dimensions.webMaxWidth, height ?? 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: borderSideColor ?? Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );

    return Center(
      child: SizedBox(
        width: width ?? Dimensions.webMaxWidth,
        child: Padding(
          padding: margin ?? const EdgeInsets.all(0),
          child: TextButton(
            onPressed: isLoading ? null : onPressed as void Function()?,
            style: flatButtonStyle,
            child: isLoading
                ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSize10),
                  Text(
                    'Loading',
                    style: TextStyle(
                      fontFamily: AppThemeData.medium,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Icon(
                    icon,
                    color: transparent
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                    size: Dimensions.fontSizeDefault,
                  ),
                )
                    : const SizedBox(),
                sizedBoxW5(),
                Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppThemeData.medium,
                    color: textColor ?? (transparent
                        ? Theme.of(context).primaryColor
                        : Colors.white),
                    fontSize: fontSize ?? 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
