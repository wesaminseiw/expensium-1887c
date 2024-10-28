import 'package:expensium/presentation/styles/colors.dart';
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
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
          Navigator.pushReplacementNamed(context, '/add_budget');
        } else if (state is UserActionsDeleteUserSuccessState) {
          shortTimeSnackBar(
            context,
            content: 'Deleted account successfully!',
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          backgroundColor: tertiaryColor,
          title: Text(
            'Verify',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: firstTextColor,
              fontSize: 28,
            ),
          ),
        ),
        body: Column(
          children: [
            const Spacer(),
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
            submitButton(
              context,
              label: 'Check Verification',
              buttonColor: secondaryColor,
              textColor: tertiaryColor,
              onTap: () {
                context.read<UserActionsCubit>().checkEmailVerification(context);
              },
            ),
            const SizedBox(height: 16),
            submitButton(
              context,
              label: 'Delete Account',
              buttonColor: secondaryColor,
              textColor: tertiaryColor,
              onTap: () async {
                await context.read<UserActionsCubit>().deleteUser(context);
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
