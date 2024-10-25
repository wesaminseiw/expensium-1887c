import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
  BuildContext context, {
  required String content,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(milliseconds: 3000),
    ),
  );
}
