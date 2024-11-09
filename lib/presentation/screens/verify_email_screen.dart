import 'package:expensium/app/router.dart';
import 'package:expensium/presentation/styles/colors.dart';
import 'package:expensium/presentation/widgets/circular_indicator.dart';
import 'package:expensium/presentation/widgets/snackbar.dart';
import 'package:expensium/presentation/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/user_actions_cubit/user_actions_cubit.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserActionsCubit, UserActionsState>(
      listener: (context, state) {
        if (state is UserActionsUserIsDeletedOrSignedOutState) {
          longTimeSnackBar(
            context,
            content: 'User is either deleted or signed out',
          );
          AppRouter.offLogin();
        } else if (state is UserActionsNotVerifiedState) {
          shortTimeSnackBar(
            context,
            content: 'Not verified yet!',
          );
        } else if (state is UserActionsVerifiedState) {
          shortTimeSnackBar(
            context,
            content: 'Verified!',
          );
          AppRouter.offAddBudget();
        } else if (state is UserActionsDeleteUserSuccessState) {
          shortTimeSnackBar(
            context,
            content: 'Deleted account successfully!',
          );
          AppRouter.offLogin();
        }
      },
      child: Scaffold(
        backgroundColor: tertiaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logos/logo-mini-no-bg.png',
                      width: 156,
                      height: 156,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Verify',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: firstTextColor,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'We\'ve sent a link to your email for verification. Check your inbox.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: secondTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<UserActionsCubit, UserActionsState>(
                      builder: (context, state) {
                        return state is UserActionsCheckVerificationLoadingState
                            ? loading()
                            : submitButton(
                                context,
                                label: 'Check Verification',
                                buttonColor: secondaryColor,
                                textColor: tertiaryColor,
                                onTap: () {
                                  context.read<UserActionsCubit>().checkEmailVerification(context);
                                },
                              );
                      },
                    ),
                    const SizedBox(height: 16),
                    submitButton(
                      context,
                      label: 'Restart',
                      buttonColor: secondaryColor,
                      textColor: tertiaryColor,
                      onTap: () {
                        AppRouter.offLogin();
                      },
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
