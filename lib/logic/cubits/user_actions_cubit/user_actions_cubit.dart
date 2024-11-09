import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'user_actions_state.dart';

class UserActionsCubit extends Cubit<UserActionsState> {
  UserActionsCubit() : super(const UserActionsInitialState(isLoading: false));

  // Sign out the user
  Future<void> signOut(BuildContext context) async {
    emit(const UserActionsSignOutLoadingState(isLoading: true));
    try {
      await FirebaseAuth.instance.signOut();
      emit(const UserActionsSignOutSuccessState(isLoading: false));
    } catch (e) {
      emit(UserActionsSignOutFailureState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    emit(const UserActionsDeleteUserLoadingState(isLoading: true));
    try {
      // Ensure the user is logged in before attempting to delete
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw 'No user is currently logged in.';
      }

      // Delete user data first
      await deleteUserData(currentUser.uid);

      // Now delete the user account
      await currentUser.delete();

      // Attempt to reload after deleting the user
      // This will ensure the app knows the user is deleted
      await FirebaseAuth.instance.currentUser?.reload();

      emit(const UserActionsDeleteUserSuccessState(isLoading: false));
      log("User deleted successfully.");

      // To properly reflect the sign-out state, we can call signOut here
      await FirebaseAuth.instance.signOut();

      // Here, you can navigate to the login screen or any other screen as required
    } catch (e) {
      emit(UserActionsDeleteUserFailureState(error: e.toString(), isLoading: false));
      log("Error deleting user: $e");
    }
  }

  Future<void> deleteUserData(String uid) async {
    final firestore = FirebaseFirestore.instance;
    emit(const UserActionsDeleteUserDataLoadingState(isLoading: true));

    try {
      // Deleting the 'budget' document
      final budget = firestore.collection('transactions').doc(uid).collection('budget').doc('budget');
      await budget.delete();
      log("Budget document deleted");

      // Deleting all documents in the 'incomes' subcollection
      final incomesSnapshot = await firestore.collection('transactions').doc(uid).collection('incomes').get();
      for (var doc in incomesSnapshot.docs) {
        await doc.reference.delete();
        log("Income document deleted");
      }

      // Deleting all documents in the 'expenses' subcollection
      final expensesSnapshot = await firestore.collection('transactions').doc(uid).collection('expenses').get();
      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
        log("Expense document deleted");
      }

      emit(const UserActionsDeleteUserDataSuccessState(isLoading: false));
    } catch (e) {
      emit(UserActionsDeleteUserDataFailureState(error: e.toString(), isLoading: false));
      log("Error deleting user data: $e");
    }
  }

  // Check email verification status
  Future<void> checkEmailVerification(BuildContext context) async {
    emit(const UserActionsCheckVerificationLoadingState(isLoading: true));
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          emit(const UserActionsUserIsDeletedOrSignedOutState(isLoading: false));
        } else if (!user.emailVerified) {
          emit(const UserActionsNotVerifiedState(isLoading: false));
        } else {
          emit(const UserActionsVerifiedState(isLoading: false));
        }
      });
    } catch (e) {
      // Handle any error
    }
  }
}
