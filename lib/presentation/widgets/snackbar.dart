import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> longTimeSnackBar(
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> shortTimeSnackBar(
  BuildContext context, {
  required String content,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(milliseconds: 750),
    ),
  );
}
