import 'package:flutter/material.dart';

Widget textField({
  required TextEditingController controller,
  required String hintText,
  TextInputType? keyboardType,
  void Function()? onTap,
  bool? readOnly,
  bool? isObscure,
  bool? filled,
  Color? fillColor,
  BorderSide? borderSide,
  TextAlign? textAlign,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        obscureText: isObscure ?? false,
        onTap: onTap,
        readOnly: readOnly ?? false,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          filled: filled ?? false,
          fillColor: fillColor ?? Colors.white,
          border: OutlineInputBorder(
            borderSide: borderSide ?? const BorderSide(),
          ),
        ),
      ),
    );
