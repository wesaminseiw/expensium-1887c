import 'package:expensium/presentation/screens/add_budget_screen.dart';
import 'package:expensium/presentation/screens/add_expense_screen.dart';
import 'package:expensium/presentation/screens/add_income_screen.dart';
import 'package:expensium/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/verify_email_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );
      case '/verify':
        return MaterialPageRoute(
          builder: (context) => const VerifyEmailScreen(),
        );
      case '/add_income':
        return MaterialPageRoute(
          builder: (context) => const AddIncomeScreen(),
        );
      case '/add_expense':
        return MaterialPageRoute(
          builder: (context) => const AddExpenseScreen(),
        );
      case '/add_budget':
        return MaterialPageRoute(
          builder: (context) => const AddBudgetScreen(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
    }
  }
}
