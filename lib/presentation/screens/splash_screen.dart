import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/presentation/screens/add_budget_screen.dart';
import 'package:expensium/presentation/screens/home_screen.dart';
import 'package:expensium/presentation/screens/login_screen.dart';
import 'package:expensium/presentation/screens/verify_email_screen.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/images/frame1.png',
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: quaternaryColor,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      nextScreen: FirebaseAuth.instance.currentUser != null
          ? FirebaseAuth.instance.currentUser!.emailVerified
              ? StreamBuilder(
                  stream: context.read<BudgetCubit>().checkIfBudgetCollectionExists().asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return const HomeScreen();
                    } else if (snapshot.data == false) {
                      return const AddBudgetScreen();
                    } else {
                      return const HomeScreen();
                    }
                  },
                )
              : const VerifyEmailScreen()
          : const LoginScreen(),
    );
  }
}
