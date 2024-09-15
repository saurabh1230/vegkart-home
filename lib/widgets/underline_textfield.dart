import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnderlineCustomTextField extends StatefulWidget {
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

  const UnderlineCustomTextField({
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
  UnderlineCustomTextFieldState createState() => UnderlineCustomTextFieldState();
}

class UnderlineCustomTextFieldState extends State<UnderlineCustomTextField> {
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
          inputFormatters: widget.isPhone
              ? [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ]
              : widget.isAmount
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
              : widget.isNumber
              ? [
            FilteringTextInputFormatter.allow(RegExp(r'\d')),
            LengthLimitingTextInputFormatter(10),
          ]
              : null,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            border: const UnderlineInputBorder(),
            isDense: true,
            hintText: widget.hintText,
            errorStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.red,
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
                    "+91",
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
                    color: Theme.of(context)
                        .disabledColor
                        .withOpacity(0.40),
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
                _obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
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
                  const SizedBox(width: 5),
                  const Text(
                    "Edit",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            )
                : null,
          ),
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
