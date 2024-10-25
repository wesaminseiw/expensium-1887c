import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../presentation/screens/verify_email_screen.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  RegisterUserBloc() : super(RegisterUserInitialState(isLoading: false)) {
    on<RegisteredUserEvent>((event, emit) async {
      log('========= LOADING =========');

      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(RegisterUserLoadingState(isLoading: true));
        try {
          // Create the user with email and password
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

          // Extract display name from email (everything before '@')
          String displayName = event.email.split('@')[0];

          // Update the display name
          await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

          // Send email verification
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();

          // Navigate to VerifyEmailScreen
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
              builder: (context) => const VerifyEmailScreen(),
            ),
          );

          log('========= SUCCESS =========');
          emit(RegisterUserSuccessState(isLoading: false));
        } on FirebaseAuthException catch (e) {
          // Handle FirebaseAuth exceptions
          if (e.code == 'invalid-email') {
            emit(RegisterUserFailureInvalidEmailState(
              e: 'Invalid email format!',
              isLoading: false,
            ));
            log('========= INVALID EMAIL =========');
          } else if (e.code == 'weak-password') {
            emit(RegisterUserFailureInvalidPasswordState(
              e: 'Password is invalid or weak!',
              isLoading: false,
            ));
            log('========= INVALID PASSWORD =========');
          } else if (e.code == 'email-already-in-use') {
            emit(RegisterUserFailureEmailExistsState(
              e: 'Email already in use by another user!',
              isLoading: false,
            ));
            log('========= EMAIL ALREADY IN USE =========');
          } else {
            emit(RegisterUserFailureState(
              e: e.message.toString(),
              isLoading: false,
            ));
            log('========= FAILURE =========');
          }
        }
      } else {
        emit(RegisterUserFailureEmptyFields(
          e: 'Email or password cannot be empty!',
          isLoading: false,
        ));
        log('========= EMPTY FIELDS =========');
      }
    });
  }
}
