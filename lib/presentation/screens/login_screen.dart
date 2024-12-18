import 'package:expensium/app/router.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/login_bloc/login_bloc.dart';
import '../widgets/snackbar.dart';
import '../widgets/submit_button.dart';
import '../widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: tertiaryColor,
        resizeToAvoidBottomInset: false,
        body: BlocListener<LoginUserBloc, LoginUserState>(
          listener: (context, state) {
            if (state is LoginUserLoadingState) {
            } else if (state is LoginUserSuccessStateVerified) {
              shortTimeSnackBar(context, content: 'Logged in successfully!');
              AppRouter.offHome();
            } else if (state is LoginUserSuccessStateUnverified) {
              longTimeSnackBar(
                context,
                content: 'Logged in successfully but you need to verify your email to continue!',
              );
              AppRouter.offVerifyEmail();
            } else if (state is LoginUserFailureState) {
              longTimeSnackBar(context, content: state.e);
            } else if (state is LoginUserFailureInvalidEmailState) {
              shortTimeSnackBar(context, content: state.e);
            } else if (state is LoginUserFailureWrongCredentialsState) {
              shortTimeSnackBar(context, content: state.e);
            } else if (state is LoginUserFailureEmptyFields) {
              shortTimeSnackBar(context, content: state.e);
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 96),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/logos/logo-mini-no-bg.png',
                        width: 96,
                        height: 96,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Track your incomes and expenses and don\'t loose control!',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
                textField(
                  controller: _emailController,
                  hintText: 'Email Address..',
                  keyboardType: TextInputType.emailAddress,
                  fillColor: quaternaryColor,
                  filled: true,
                  borderSide: BorderSide.none,
                ),
                const SizedBox(height: 24),
                textField(
                  controller: _passwordController,
                  hintText: 'Password..',
                  keyboardType: TextInputType.visiblePassword,
                  isObscure: true,
                  fillColor: quaternaryColor,
                  filled: true,
                  borderSide: BorderSide.none,
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginUserBloc, LoginUserState>(
                  builder: (context, state) {
                    return state.isLoading == false
                        ? submitButton(
                            context,
                            label: 'Login',
                            buttonColor: secondaryColor,
                            textColor: tertiaryColor,
                            onTap: () {
                              context.read<LoginUserBloc>().add(
                                    LoggedInUserEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context,
                                    ),
                                  );
                            },
                          )
                        : loading();
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: secondTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRouter.offRegister();
                      },
                      child: Text(
                        'Register now.',
                        style: TextStyle(
                          color: secondTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
