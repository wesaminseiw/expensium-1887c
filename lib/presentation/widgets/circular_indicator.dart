import 'package:expensium/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

Widget loading() {
  return SizedBox(
    height: 56,
    child: Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: primaryColor,
          strokeWidth: 3,
        ),
      ),
    ),
  );
}
