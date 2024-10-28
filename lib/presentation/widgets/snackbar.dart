import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> longTimeSnackBar(
  BuildContext context, {
  required String content,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 3000),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjusts position above the keyboard
        left: 16.0, // Optional left margin
        right: 16.0, // Optional right margin
      ),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> shortTimeSnackBar(
  BuildContext context, {
  required String content,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 750),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjusts position above the keyboard
        left: 16.0, // Optional left margin
        right: 16.0, // Optional right margin
      ),
    ),
  );
}
