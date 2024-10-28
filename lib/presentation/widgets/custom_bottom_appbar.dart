import 'dart:developer';
import 'package:expensium/presentation/screens/calculator_screen.dart';
import 'package:expensium/presentation/screens/home_screen.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

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
  void _navigateWithoutAnimation(BuildContext context, String route) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route == '/home' ? const HomeScreen() : const CalculatorScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

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
                        _navigateWithoutAnimation(context, '/home');
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
                        _navigateWithoutAnimation(context, '/calculator');
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
