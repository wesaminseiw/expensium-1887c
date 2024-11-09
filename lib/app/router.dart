import 'package:expensium/presentation/screens/add_budget_screen.dart';
import 'package:expensium/presentation/screens/add_expense_screen.dart';
import 'package:expensium/presentation/screens/add_income_screen.dart';
import 'package:expensium/presentation/screens/calculator_screen.dart';
import 'package:expensium/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/verify_email_screen.dart';
import 'utils/constants.dart';

class AppRouter {
  //* routes defining
  static final List<GetPage> routes = [
    GetPage(
      name: homeRoute,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: loginRoute,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: registerRoute,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: verifyEmailRoute,
      page: () => const VerifyEmailScreen(),
    ),
    GetPage(
      name: addIncomeRoute,
      page: () => const AddIncomeScreen(),
    ),
    GetPage(
      name: addExpenseRoute,
      page: () => const AddExpenseScreen(),
    ),
    GetPage(
      name: addBudgetRoute,
      page: () => const AddBudgetScreen(),
    ),
    GetPage(
      name: settingsRoute,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: calculatorRoute,
      page: () => const CalculatorScreen(),
    ),
  ];

  //* pop navigator
  static void pop() {
    Get.back();
  }

  //* customized navigators
  static void offAllNavigateWithoutAnimation(route) {
    Get.offAll(
      () => route == '/home' ? const HomeScreen() : const CalculatorScreen(),
      transition: Transition.noTransition, // No transition (like Duration.zero)
      curve: Curves.linear, // Optional, used for transition timing curve
    );
  }

  //* to navigators
  static void toHome() {
    Get.toNamed(homeRoute);
  }

  static void toLogin() {
    Get.toNamed(loginRoute);
  }

  static void toRegister() {
    Get.toNamed(registerRoute);
  }

  static void toVerifyEmail() {
    Get.toNamed(verifyEmailRoute);
  }

  static void toAddIncome() {
    Get.toNamed(addIncomeRoute);
  }

  static void toAddExpense() {
    Get.toNamed(addExpenseRoute);
  }

  static void toAddBudget() {
    Get.toNamed(addBudgetRoute);
  }

  static void toSettings() {
    Get.toNamed(settingsRoute);
  }

  static void toCalculator() {
    Get.toNamed(calculatorRoute);
  }

  //* off navigators
  static void offHome() {
    Get.offNamed(homeRoute);
  }

  static void offLogin() {
    Get.offNamed(loginRoute);
  }

  static void offRegister() {
    Get.offNamed(registerRoute);
  }

  static void offVerifyEmail() {
    Get.offNamed(verifyEmailRoute);
  }

  static void offAddIncome() {
    Get.offNamed(addIncomeRoute);
  }

  static void offAddExpense() {
    Get.offNamed(addExpenseRoute);
  }

  static void offAddBudget() {
    Get.offNamed(addBudgetRoute);
  }

  static void offSettings() {
    Get.offNamed(settingsRoute);
  }

  static void offCalculator() {
    Get.offNamed(calculatorRoute);
  }
}
