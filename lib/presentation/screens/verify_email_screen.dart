import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/user_actions_cubit/user_actions_cubit.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerifyEmailScreen'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                context.read<UserActionsCubit>().deleteUser(context);
              },
              child: const Text('Delete account'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<UserActionsCubit>()
                    .checkEmailVerification(context);
              },
              child: const Text('Check verification'),
            ),
          ],
        ),
      ),
    );
  }
}
