import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  RegisterUserBloc() : super(RegisterUserInitialState(isLoading: false)) {
    on<RegisteredUserEvent>((event, emit) async {
      log('========= LOADING =========');

      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(RegisterUserLoadingState(isLoading: true));
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          String displayName = event.email.split('@')[0];
          await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();

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
