// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../utils/dimensions.dart';
// import '../../utils/styles.dart';
//
//
// class CustomTextField extends StatefulWidget {
//   final String hintText;
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final FocusNode? nextFocus;
//   final TextInputType inputType;
//   final TextInputAction inputAction;
//   final bool isPassword;
//   final Function? onChanged;
//   final Function? onSubmit;
//   final bool isEnabled;
//   final int maxLines;
//   final TextCapitalization capitalization;
//   final String? prefixImage;
//   final IconData? prefixIcon;
//   final bool divider;
//   final bool showTitle;
//   final bool isAmount;
//   final bool isNumber;
//   final bool isPhone;
//   final String? countryDialCode;
//   // final Function(CountryCode countryCode)? onCountryChanged;
//   final bool showBorder;
//   final double iconSize;
//   final bool isRequired;
//   final bool readOnly;
//   // final Widget? prefix;
//   // final double? maxLetters;
//
//   const CustomTextField(
//       {Key? key, this.hintText = 'Write something...',
//         this.controller,
//         this.focusNode,
//         this.nextFocus,
//         this.isEnabled = true,
//         this.inputType = TextInputType.text,
//         this.inputAction = TextInputAction.next,
//         this.maxLines = 1,
//         this.onSubmit,
//         this.onChanged,
//         this.prefixImage,
//         this.prefixIcon,
//         this.capitalization = TextCapitalization.none,
//         this.isPassword = false,
//         this.divider = false,
//         this.showTitle = false,
//         this.isAmount = false,
//         this.isNumber = false,
//         this.isPhone = false,
//         this.countryDialCode,
//         // this.onCountryChanged,
//         this.showBorder = true,
//         this.iconSize = 18,
//         this.isRequired = false,this.readOnly = false,  /*this.prefix,*/
//         // this.maxLetters,
//       }) : super(key: key);
//
//   @override
//   CustomTextFieldState createState() => CustomTextFieldState();
// }
//
// class CustomTextFieldState extends State<CustomTextField> {
//   bool _obscureText = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         widget.showTitle ? Text(widget.hintText, style: senRegular.copyWith(fontSize: Dimensions.fontSize12)) : const SizedBox(),
//         SizedBox(height: widget.showTitle ? Dimensions.paddingSize5 : 0),
//
//         TextField(readOnly: widget.readOnly,
//           maxLines: widget.maxLines,
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           style: senRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
//           textInputAction: widget.inputAction,
//           keyboardType: widget.isAmount ? TextInputType.number : widget.inputType,
//           cursorColor: Theme.of(context).primaryColor,
//           textCapitalization: widget.capitalization,
//           enabled: widget.isEnabled,
//           autofocus: false,
//           autofillHints: widget.inputType == TextInputType.name ? [AutofillHints.name]
//               : widget.inputType == TextInputType.emailAddress ? [AutofillHints.email]
//               : widget.inputType == TextInputType.phone ? [AutofillHints.telephoneNumber]
//               : widget.inputType == TextInputType.streetAddress ? [AutofillHints.fullStreetAddress]
//               : widget.inputType == TextInputType.url ? [AutofillHints.url]
//               : widget.inputType == TextInputType.visiblePassword ? [AutofillHints.password] : null,
//           obscureText: widget.isPassword ? _obscureText : false,
//           inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]')),]
//               : widget.isAmount ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))] : widget.isNumber ? [FilteringTextInputFormatter.allow(RegExp(r'\d')),LengthLimitingTextInputFormatter(10),] : null,
//           decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(Dimensions.radius5),
//               borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, width: 0.3, color: Theme.of(context).primaryColorDark.withOpacity(0.80)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(Dimensions.radius5),
//               borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, width: 1, color: Theme.of(context).primaryColor),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(Dimensions.radius5),
//               borderSide: BorderSide(style: widget.showBorder ? BorderStyle.solid : BorderStyle.none, width: 0.3, color:Theme.of(context).primaryColorDark.withOpacity(0.80)),
//             ),
//             isDense: true,
//             hintText: widget.hintText,
//             fillColor: Theme.of(context).cardColor,
//             hintStyle: senRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor.withOpacity(0.40)),
//             filled: true,
//             // prefix: widget.prefix,
//             prefixIcon: widget.isPhone ? SizedBox(width: 55, child: Row(children: [
//               const SizedBox(width: Dimensions.paddingSize5,),
//
//               Text("+ 91",style: senRegular.copyWith(color: Theme.of(context).disabledColor.withOpacity(0.40),)),
//               // Container(
//               //     width: 85,height: 50,
//               //     decoration:  BoxDecoration(
//               //       borderRadius: BorderRadius.only(
//               //         topLeft: Radius.circular(Dimensions.radius5),
//               //         bottomLeft: Radius.circular(Dimensions.radius5),
//               //       ),
//               //     ),
//               //     margin: const EdgeInsets.only(right: 0),
//               //     padding: const EdgeInsets.only(left: 5),
//               //     child: Center(
//               //       child: CodePickerWidget(
//               //         flagWidth: 25,
//               //         padding: EdgeInsets.zero,
//               //         onChanged: widget.onCountryChanged,
//               //         initialSelection: widget.countryDialCode,
//               //         favorite: [widget.countryDialCode!],
//               //         textStyle: nunitoSansBold.copyWith(
//               //           fontSize: Dimensions.fontSize14, color: Theme.of(context).textTheme.bodyMedium!.color,
//               //         ),
//               //       ),
//               //     )),
//               const SizedBox(width: Dimensions.paddingSize5,),
//
//               Container(
//                 height: 20, width: 2,
//                 color: Theme.of(context).disabledColor.withOpacity(0.40),
//               )
//             ]),
//             ) : widget.prefixImage != null && widget.prefixIcon == null ? Padding(
//               padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize10),
//               child: Image.asset(widget.prefixImage!, height: 20, width: 20),
//             ) : widget.prefixImage == null && widget.prefixIcon != null ? Icon(widget.prefixIcon, size: widget.iconSize) : null,
//             suffixIcon: widget.isPassword ? IconButton(
//               icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
//               onPressed: _toggle,
//             ) : null,
//           ),
//           onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
//               : widget.onSubmit != null ? widget.onSubmit!(text) : null,
//           onChanged: widget.onChanged as void Function(String)?,
//         ),
//
//         widget.divider ? const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize20), child: Divider()) : const SizedBox(),
//       ],
//     );
//   }
//
//   void _toggle() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
// }
//
//
//
//
//

import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final String? prefixImage;
  final IconData? prefixIcon;
  final bool divider;
  final bool showTitle;
  final bool isAmount;
  final bool isNumber;
  final bool isPhone;
  final String? countryDialCode;
  final bool showBorder;
  final double iconSize;
  final bool isRequired;
  final bool readOnly;
  final bool editText; // New property to show edit text suffix
  final FormFieldValidator<String>? validation;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    this.hintText = 'Write something...',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.prefixImage,
    this.prefixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.divider = false,
    this.showTitle = false,
    this.isAmount = false,
    this.isNumber = false,
    this.isPhone = false,
    this.countryDialCode,
    this.showBorder = true,
    this.iconSize = 18,
    this.isRequired = false,
    this.readOnly = false,
    this.editText = false,
    this.validation,
    this.onTap,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showTitle
            ? Text(
                widget.hintText,
                // Adjust style as needed
              )
            : const SizedBox(),
        SizedBox(height: widget.showTitle ? 5 : 0),
        TextFormField(
          onTap: widget.onTap,
          validator: widget.validation,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: const TextStyle(fontSize: 16),
          // Adjust text style as needed
          textInputAction: widget.inputAction,
          keyboardType:
              widget.isAmount ? TextInputType.number : widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          autofocus: false,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: widget.isAmount
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
              : widget.isNumber
                  ? [
                      FilteringTextInputFormatter.allow(RegExp(r'\d')),
                      LengthLimitingTextInputFormatter(10),
                    ]
                  : widget.isPhone
                      ? [
                          FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
                        ]
                      : null,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 0.3,
                color: Theme.of(context).primaryColorDark.withOpacity(0.80),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 0.3,
                color: Theme.of(context).primaryColorDark.withOpacity(0.80),
              ),
            ),
            isDense: true,
            hintText: widget.hintText,
            errorStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: AppThemeData.medium,
              color: AppThemeData.colorRed,
            ),
            fillColor: Theme.of(context).cardColor,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).disabledColor.withOpacity(0.40),
            ),
            filled: true,
            prefixIcon: widget.isPhone
                ? SizedBox(
                    width: 55,
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          " + 91",
                          style: TextStyle(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.40),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 20,
                          width: 2,
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.40),
                        ),
                      ],
                    ),
                  )
                : widget.prefixImage != null && widget.prefixIcon == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          widget.prefixImage!,
                          height: 20,
                          width: 20,
                        ),
                      )
                    : widget.prefixImage == null && widget.prefixIcon != null
                        ? Icon(
                            widget.prefixIcon,
                            size: widget.iconSize,
                          )
                        : null,
                  suffixIcon: widget.isPassword
                 ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: _toggle,
                  )
                 : widget.editText
                    ? Container(
                        width: 60,
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                            sizedBoxW5(),
                            Text(
                              "Edit",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: AppThemeData.medium,
                                color: AppThemeData.black,
                              ),
                            )
                          ],
                        ),
                      )
                    : null,
          ),
          // onSubmitted: (text) => widget.nextFocus != null
          //     ? FocusScope.of(context).requestFocus(widget.nextFocus)
          //     : widget.onSubmit != null
          //     ? widget.onSubmit!(text)
          //     : null,
          onChanged: widget.onChanged as void Function(String)?,
        ),
        widget.divider
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              )
            : const SizedBox(),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
