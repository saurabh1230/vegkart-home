import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../theme/app_theme_data.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final Function()? onPress;
  final String? Function(String?)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? obscureText;
  final int? maxLine;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validation;
  final Function()? onTap; // Add onTap parameter
  final bool readonly; // Add readonly parameter
  final Function(String)? onFieldSubmitted; // Add this line
  final int? maxLength; // New parameter for max length

  const TextFieldWidget({
    super.key,
    this.textInputType,
    this.enable,
    this.prefix,
    this.suffix,
    this.title,
    required this.hintText,
    required this.controller,
    this.onPress,
    this.maxLine,
    this.inputFormatters,
    this.obscureText,
    this.onChanged,
    this.validation,
    this.onTap, // Include it here
    this.readonly = false, // Default value for readonly
    this.onFieldSubmitted,
    this.maxLength, // Include maxLength parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                      fontFamily: AppThemeData.regular,
                      fontSize: 14,
                      color: AppThemeData.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          GestureDetector( // Wrap TextFormField with GestureDetector
            onTap: readonly ? onTap : null, // Call onTap if readonly
            child: AbsorbPointer( // Prevent user interaction if readonly
              absorbing: readonly,
              child: TextFormField(
                onFieldSubmitted: onFieldSubmitted,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: textInputType ?? TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: controller,
                textAlign: TextAlign.start,
                maxLines: maxLine ?? 1,
                textInputAction: TextInputAction.done,
                inputFormatters: inputFormatters,
                obscureText: obscureText ?? false,
                validator: validation,
                onChanged: onChanged,
                maxLength: !readonly ? maxLength : null, // Set maxLength conditionally
                style: TextStyle(
                  fontSize: 14,
                  color: AppThemeData.black.withOpacity(0.90),
                  fontWeight: FontWeight.w300,
                  fontFamily: AppThemeData.regular,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.red),
                  isDense: true,
                  filled: false, // Set filled to false for underline
                  enabled: enable ?? true,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 14, horizontal: prefix != null ? 0 : 10),
                  prefixIcon: prefix,
                  suffixIcon: suffix,
                  // Use the below properties to achieve underline decoration
                  focusedBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue),
                  ),
                  enabledBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue),
                  ),
                  errorBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue),
                  ),
                  hintText: hintText.tr,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppThemeData.black.withOpacity(0.50),
                    fontWeight: FontWeight.w300,
                    fontFamily: AppThemeData.regular,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
