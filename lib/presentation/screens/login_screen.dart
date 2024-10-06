import 'package:expensium/presentation/styles/colors.dart';
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: firstTextColor,
              fontSize: 28,
            ),
          ),
        ),
        body: BlocListener<LoginUserBloc, LoginUserState>(
          listener: (context, state) {
            if (state is LoginUserLoadingState) {
            } else if (state is LoginUserSuccessStateVerified) {
              snackBar(context, content: 'Logged in successfully!');
            } else if (state is LoginUserSuccessStateUnverified) {
              snackBar(
                context,
                content: 'Logged in successfully but you need to verify your email to continue!',
              );
            } else if (state is LoginUserFailureState) {
              snackBar(context, content: state.e);
            } else if (state is LoginUserFailureInvalidEmailState) {
              snackBar(context, content: state.e);
            } else if (state is LoginUserFailureWrongCredentialsState) {
              snackBar(context, content: state.e);
            } else if (state is LoginUserFailureEmptyFields) {
              snackBar(context, content: state.e);
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/home_screen.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 36),
                  textField(
                    controller: _emailController,
                    hintText: 'Email Address..',
                    keyboardType: TextInputType.emailAddress,
                    fillColor: backgroundColor,
                    filled: true,
                    borderSide: BorderSide.none,
                  ),
                  const SizedBox(height: 24),
                  textField(
                    controller: _passwordController,
                    hintText: 'Password..',
                    keyboardType: TextInputType.visiblePassword,
                    isObscure: true,
                    fillColor: backgroundColor,
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
                              buttonColor: primaryColor,
                              textColor: firstTextColor,
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
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
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
                          Navigator.pushReplacementNamed(
                            context,
                            '/register',
                          );
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
            ],
          ),
        ),
      ),
    );
  }
}
