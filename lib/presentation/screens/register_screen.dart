import 'package:expensium/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/register_bloc/register_bloc.dart';
import '../widgets/snackbar.dart';
import '../widgets/submit_button.dart';
import '../widgets/textfield.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        body: BlocListener<RegisterUserBloc, RegisterUserState>(
          listener: (context, state) {
            if (state is RegisterUserLoadingState) {
              setState(() {
                isLoading = true;
              });
            } else if (state is RegisterUserSuccessState) {
              shortTimeSnackBar(context, content: 'Registered successfully!');
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureState) {
              longTimeSnackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureEmailExistsState) {
              shortTimeSnackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureInvalidEmailState) {
              shortTimeSnackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureInvalidPasswordState) {
              shortTimeSnackBar(
                context,
                content: state.e,
              );
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureEmptyFields) {
              shortTimeSnackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailurePasswordRequirementsState) {
              shortTimeSnackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
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
                        'Create your account,',
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
                BlocBuilder<RegisterUserBloc, RegisterUserState>(
                  builder: (context, state) {
                    return state.isLoading == false
                        ? submitButton(
                            context,
                            label: 'Register',
                            buttonColor: secondTextColor,
                            textColor: tertiaryColor,
                            onTap: () {
                              context.read<RegisterUserBloc>().add(
                                    RegisteredUserEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context,
                                    ),
                                  );
                            },
                          )
                        : const SizedBox(
                            height: 56,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: secondTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Login.',
                        style: TextStyle(
                          color: secondTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
