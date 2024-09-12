import 'package:flutter/material.dart';

Widget textField({
  required TextEditingController controller,
  required String hintText,
  TextInputType? keyboardType,
  void Function()? onTap,
  bool? readOnly,
  bool? isObscure,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        obscureText: isObscure ?? false,
        onTap: onTap,
        readOnly: readOnly ?? false,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
