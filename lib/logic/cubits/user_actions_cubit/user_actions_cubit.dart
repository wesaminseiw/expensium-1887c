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
      emit(UserActionsDeleteUserSuccessState());
    } catch (e) {
      emit(UserActionsDeleteUserFailureState(e.toString()));
    }
  }

  Future<void> deleteUserData() async {
    emit(UserActionsDeleteUserDataInitialState());
    try {
      final _uid = FirebaseAuth.instance.currentUser!.uid;
      final _firestore = FirebaseFirestore.instance;

      final budget = _firestore
          .collection('transactions')
          .doc(_uid)
          .collection('budget')
          .doc('budget');
      await budget.delete();
      final incomesSnapshot = await _firestore
          .collection('transactions')
          .doc(_uid)
          .collection('incomes')
          .get();

      // Delete each document in the 'incomes' subcollection
      for (var doc in incomesSnapshot.docs) {
        await doc.reference.delete();
      }

      final expensesSnapshot = await _firestore
          .collection('transactions')
          .doc(_uid)
          .collection('expenses')
          .get();

      // Delete each document in the 'incomes' subcollection
      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
      }

      emit(UserActionsDeleteUserDataSuccessState());
    } catch (e) {
      emit(UserActionsDeleteUserDataFailureState(e.toString()));
    }
  }

  // // Deletes user data from Firestore and the user account from Firebase Auth
  // Future<void> _deleteUserData() async {
  //   try {
  //     final _uid = FirebaseAuth.instance.currentUser!.uid;
  //     final _firestore = FirebaseFirestore.instance;

  //     // Delete user's data from Firestore
  //     await _firestore.collection('transactions').doc(_uid).delete();
  //     log('========= DELETED USER DATA =========');

  //     // Delete Firebase Auth user
  //     await FirebaseAuth.instance.currentUser!.delete();
  //     log('========= DELETED USER (NAVIGATING TO LOGIN) =========');
  //   } catch (e) {
  //     log('Error deleting user data: $e');
  //     throw e; // Rethrow error to be handled in deleteUser method
  //   }
  // }

  // Check email verification status
  Future<void> checkEmailVerification(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else if (!user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Not verified yet!')),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/add_budget');
        }
      });
    } catch (e) {
      // Handle any error
    }
  }
}
