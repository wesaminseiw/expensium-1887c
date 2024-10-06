import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'user_actions_state.dart';

class UserActionsCubit extends Cubit<UserActionsState> {
  UserActionsCubit() : super(UserActionsInitialState());

  // Sign out the user
  Future<void> signOut(BuildContext context) async {
    emit(UserActionsSignOutInitialState());
    try {
      await FirebaseAuth.instance.signOut();
      emit(UserActionsSignOutSuccessState());
    } catch (e) {
      emit(UserActionsSignOutFailureState(e.toString()));
    }
  }

  // Delete the user account
  Future<void> deleteUser(BuildContext context) async {
    emit(UserActionsDeleteUserInitialState());
    try {
      await deleteUserData();
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.currentUser?.reload();
      emit(UserActionsDeleteUserSuccessState());
      log("User deleted successfully.");
    } catch (e) {
      emit(UserActionsDeleteUserFailureState(e.toString()));
    }
  }

  Future<void> deleteUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;
    emit(UserActionsDeleteUserDataInitialState());
    try {
      final budget = firestore.collection('transactions').doc(uid).collection('budget').doc('budget');
      await budget.delete();
      final incomesSnapshot = await firestore.collection('transactions').doc(uid).collection('incomes').get();

      // Delete each document in the 'incomes' subcollection
      for (var doc in incomesSnapshot.docs) {
        await doc.reference.delete();
      }

      final expensesSnapshot = await firestore.collection('transactions').doc(uid).collection('expenses').get();

      // Delete each document in the 'incomes' subcollection
      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
      }

      emit(UserActionsDeleteUserDataSuccessState());
    } catch (e) {
      emit(UserActionsDeleteUserDataFailureState(e.toString()));
    }
  }

  // Check email verification status
  Future<void> checkEmailVerification(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          emit(UserActionsUserIsDeletedOrSignedOutState());
        } else if (!user.emailVerified) {
          emit(UserActionsNotVerifiedState());
        } else {
          emit(UserActionsVerifiedState());
        }
      });
    } catch (e) {
      // Handle any error
    }
  }
}
