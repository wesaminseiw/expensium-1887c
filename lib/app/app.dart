import 'package:expensium/logic/cubits/combined_cubit/combined_cubit.dart';
import 'package:expensium/logic/cubits/expense_cubit/expense_cubit.dart';
import 'package:expensium/logic/cubits/get_weekly_budget_cubit/get_weekly_budget_cubit.dart';
import 'package:expensium/logic/cubits/income_cubit/income_cubit.dart';
import 'package:expensium/logic/cubits/budget_cubit/budget_cubit.dart';
import 'package:expensium/logic/cubits/get_display_name_cubit/get_display_name_cubit.dart';
import 'package:expensium/presentation/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/blocs/login_bloc/login_bloc.dart';
import '../logic/blocs/register_bloc/register_bloc.dart';
import '../logic/cubits/user_actions_cubit/user_actions_cubit.dart';
import 'router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  late final IncomeCubit _incomeCubit;
  late final ExpenseCubit _expenseCubit;

  @override
  void initState() {
    super.initState();
    _incomeCubit = IncomeCubit();
    _expenseCubit = ExpenseCubit();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterUserBloc()),
        BlocProvider(create: (context) => LoginUserBloc()),
        BlocProvider(create: (context) => UserActionsCubit()),
        BlocProvider(create: (context) => GetDisplayNameCubit()),
        BlocProvider(create: (context) => _incomeCubit),
        BlocProvider(create: (context) => _expenseCubit),
        BlocProvider(create: (context) => BudgetCubit()),
        BlocProvider(create: (context) => GetWeeklyBudgetCubit()),
        BlocProvider(
          create: (context) => CombinedCubit(
            expenseCubit: _expenseCubit,
            incomeCubit: _incomeCubit,
          ),
        ),
      ],
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          FirebaseAuth.instance.currentUser?.reload();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expensium',
            theme: ThemeData(
              fontFamily: 'WorkSans',
            ),
            home: const SplashScreen(),
            onGenerateRoute: _appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _incomeCubit.close();
    _expenseCubit.close();
    super.dispose();
  }
}
