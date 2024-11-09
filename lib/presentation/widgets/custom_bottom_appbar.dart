import 'dart:developer';
import 'package:expensium/app/router.dart';
import 'package:expensium/app/utils/constants.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomAppBar extends StatefulWidget {
  int currentIndex;
  CustomBottomAppBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: quaternaryColor,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      icon: Icon(
                        Icons.home_rounded,
                        color: widget.currentIndex == 0 ? primaryColor : secondaryColor,
                        size: widget.currentIndex == 0 ? 38 : 32,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.currentIndex = 0;
                        });
                        AppRouter.offAllNavigateWithoutAnimation(homeRoute);
                        log('=== HOME ===');
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      icon: Icon(
                        Icons.calculate_rounded,
                        color: widget.currentIndex == 1 ? primaryColor : secondaryColor,
                        size: widget.currentIndex == 1 ? 38 : 32,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.currentIndex = 1;
                        });
                        AppRouter.offAllNavigateWithoutAnimation(calculatorRoute);
                        log('=== CALCULATOR ===');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
