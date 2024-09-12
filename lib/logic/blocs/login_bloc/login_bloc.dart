import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginUserBloc extends Bloc<LoginUserEvent, LoginUserState> {
  LoginUserBloc() : super(LoginUserInitialState(isLoading: false)) {
    on<LoggedInUserEvent>((event, emit) async {
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(LoginUserLoadingState(isLoading: true));
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            log('========= NAVIGATING TO HOME =========');
            emit(LoginUserSuccessStateVerified(isLoading: false));
            Navigator.pushReplacementNamed(
              event.context,
              '/',
            );
          } else {
            log('========= NAVIGATING TO VERIFY =========');
            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
            emit(LoginUserSuccessStateUnverified(isLoading: false));
            Navigator.pushReplacementNamed(
              event.context,
              '/verify',
            );
          }
          log('========= SUCCESS =========');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-email') {
            emit(
              LoginUserFailureInvalidEmailState(
                e: 'Invalid email format!',
                isLoading: false,
              ),
            );
            log('========= INVALID EMAIL =========');
          } else if (e.code == 'wrong-credentials' ||
              e.code == 'user-not-found' ||
              e.code == 'wrong-password') {
            emit(
              LoginUserFailureWrongCredentialsState(
                e: 'Wrong credentials!',
                isLoading: false,
              ),
            );
            log('========= WRONG CREDENTIALS =========');
          }
        }
      } else {
        emit(
          LoginUserFailureEmptyFields(
            e: 'Email or password cannot be empty!',
            isLoading: false,
          ),
        );
        log('========= EMPTY FIELDS =========');
      }
    });
  }
}
