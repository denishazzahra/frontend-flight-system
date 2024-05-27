import 'package:flutter/services.dart';

import '../utils/colors.dart';
import 'package:flutter/material.dart';

TextFormField textField({
  required TextEditingController controller,
  required String placeholder,
  bool? isObscure,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return TextFormField(
    obscureText: isObscure ?? false,
    controller: controller,
    keyboardType: placeholder == 'Email Address'
        ? TextInputType.emailAddress
        : placeholder == 'Phone Number'
            ? TextInputType.number
            : TextInputType.text,
    inputFormatters: placeholder == 'Phone Number'
        ? [FilteringTextInputFormatter.allow(RegExp(r'\d{1,15}'))]
        : null,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: placeholder,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: lightGreyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: lightGreyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: lightGreyColor, width: 1.5),
      ),
    ),
  );
}

TextField textFieldWithLabel({
  required TextEditingController controller,
  required String placeholder,
  bool? isObscure,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return TextField(
    obscureText: isObscure ?? false,
    controller: controller,
    keyboardType: placeholder == 'Email Address'
        ? TextInputType.emailAddress
        : placeholder == 'Phone Number'
            ? TextInputType.number
            : TextInputType.text,
    inputFormatters: placeholder == 'Phone Number'
        ? [FilteringTextInputFormatter.allow(RegExp(r'\d{1,15}'))]
        : null,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      label: Text(placeholder),
      filled: true,
      fillColor: whiteColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: lightGreyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: lightGreyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: lightGreyColor, width: 1.5),
      ),
    ),
  );
}
