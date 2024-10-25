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
        appBar: AppBar(
          backgroundColor: tertiaryColor,
          title: Text(
            'Register',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: firstTextColor,
              fontSize: 28,
            ),
          ),
        ),
        body: BlocListener<RegisterUserBloc, RegisterUserState>(
          listener: (context, state) {
            if (state is RegisterUserLoadingState) {
              setState(() {
                isLoading = true;
              });
            } else if (state is RegisterUserSuccessState) {
              snackBar(context, content: 'Registered successfully!');
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureState) {
              snackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureEmailExistsState) {
              snackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureInvalidEmailState) {
              snackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureInvalidPasswordState) {
              snackBar(
                context,
                content: state.e,
              );
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailureEmptyFields) {
              snackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            } else if (state is RegisterUserFailurePasswordRequirementsState) {
              snackBar(context, content: state.e);
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 36),
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
    );
  }
}
