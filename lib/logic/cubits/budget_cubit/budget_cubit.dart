import 'dart:developer';
import 'dart:async'; // To use Timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(const BudgetInitialState(budget: 0, isLoading: false)) {
    // startDebugTimer();
  }

  void addBudget(
    BuildContext context, {
    required TextEditingController budgetController,
  }) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;
    final budgetDocumentRef = firestore.collection('transactions').doc(userId).collection('budget').doc('budget');

    emit(const AddBudgetLoadingState(budget: 0, isLoading: true));

    if (budgetController.text.isNotEmpty) {
      try {
        final double budgetInt = double.tryParse(budgetController.text) ?? 0;
        final double budget0 = budgetInt.toDouble();

        await budgetDocumentRef.set({
          'budget': budget0,
          'weekBudget': budget0, // Initialize weekBudget
        });

        final budget = await getBudgetValue();

        // await calculateBudgetChange();
        emit(AddBudgetSuccessState(budget: budget, isLoading: false));
      } catch (e) {
        emit(const AddBudgetFailureState(budget: 0, isLoading: false));
      }
    } else {
      emit(const AddBudgetFailureEmptyFieldsState(budget: 0, isLoading: false));
    }
  }

  Future<double> getBudgetValue() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;
    final budgetDocumentRef = firestore.collection('transactions').doc(userId).collection('budget').doc('budget');

    emit(const GetBudgetLoadingState(budget: 0, isLoading: true));
    try {
      final documentSnapshot = await budgetDocumentRef.get();

      if (documentSnapshot.exists) {
        double budgetValue = documentSnapshot.data()?['budget'] ?? 0.0;
        emit(GetBudgetSuccessState(budget: budgetValue, isLoading: false));

        log('Retrieved budget value: $budgetValue');
        return budgetValue;
      } else {
        emit(const GetBudgetFailureState(budget: 0, isLoading: false));
        log('Budget document does not exist.');
        return 0.0;
      }
    } catch (e) {
      emit(const GetBudgetFailureState(budget: 0, isLoading: false));
      log('Error retrieving budget: ${e.toString()}');
      return 0.0;
    }
  }

  Future<bool> checkIfBudgetCollectionExists() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final budgetDocRef = FirebaseFirestore.instance.collection('transactions').doc(userId).collection('budget').doc('budget');

    try {
      final budgetSnapshot = await budgetDocRef.get();

      return budgetSnapshot.exists;
    } catch (e) {
      print('Error checking budget collection: ${e.toString()}');
      return false;
    }
  }

  void updateBudget({
    required TextEditingController newBudgetController,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;

    emit(const UpdateBudgetLoadingState(budget: 0, isLoading: true));

    if (newBudgetController.text.isNotEmpty) {
      final double newBudget = double.tryParse(newBudgetController.text) ?? 0;

      if (newBudget > 0) {
        final budgetDocumentRef = firestore.collection('transactions').doc(userId).collection('budget').doc('budget');

        await budgetDocumentRef.set({
          'budget': newBudget,
        });

        emit(UpdateBudgetSuccessState(budget: newBudget, isLoading: false));
      } else {
        emit(const UpdateBudgetFailureInvalidValueState(budget: 0, isLoading: false));
      }
    } else {
      emit(const UpdateBudgetFailureEmptyFieldsState(budget: 0, isLoading: false));
    }
  }

  // Future<double> calculateBudgetChange() async {
  //   emit(const GetBudgetLoadingState(isLoading: true, budget: 0.0));

  //   try {
  //     final userId = FirebaseAuth.instance.currentUser!.uid;
  //     final firestore = FirebaseFirestore.instance;
  //     double currentBudget = await getBudgetValue();
  //     final budgetDocumentRef = await firestore.collection('transactions').doc(userId).collection('budget').doc('budget').get();

  //     if (budgetDocumentRef.exists) {
  //       Map<String, dynamic>? data = budgetDocumentRef.data();
  //       var weekBudget = data?['weekBudget'];

  //       double weeklyIncomes = await IncomeCubit().fetchWeeklyIncomes();
  //       double weeklyExpenses = await ExpenseCubit().fetchWeeklyExpenses();

  //       double budgetChange = ((weeklyIncomes - weeklyExpenses) / weekBudget) * 100;

  //       emit(GetBudgetSuccessState(isLoading: false, budget: currentBudget, budgetChange: budgetChange));
  //       return budgetChange;
  //     } else {
  //       emit(const GetBudgetFailureState(
  //         isLoading: false,
  //         budget: 0.0,
  //       ));
  //       log('========= WEEKBUDGET NOT FOUND ============');
  //       return 0;
  //     }
  //   } catch (e) {
  //     emit(const GetBudgetFailureState(
  //       isLoading: false,
  //       budget: 0.0,
  //     ));
  //     return 0;
  //   }
  // }

  // Future<void> updateWeekBudget(double newWeekBudget) async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final firestore = FirebaseFirestore.instance;
  //   final budgetDocumentRef = firestore.collection('transactions').doc(userId).collection('budget').doc('budget');

  //   emit(const UpdateWeekBudgetLoadingState(
  //     isLoading: true,
  //     budget: 0,
  //   ));

  //   try {
  //     await budgetDocumentRef.update({
  //       'weekBudget': newWeekBudget,
  //     });
  //     emit(UpdateWeekBudgetSuccessState(
  //       newWeekBudget: newWeekBudget,
  //       isLoading: false,
  //       budget: 0,
  //     ));
  //   } catch (e) {
  //     emit(const UpdateWeekBudgetFailureState(
  //       isLoading: false,
  //       budget: 0,
  //     ));
  //   }
  // }

  // Future<void> checkAndResetWeekBudget() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final firestore = FirebaseFirestore.instance;
  //   final budgetDocumentRef = firestore.collection('transactions').doc(userId).collection('budget').doc('budget');

  //   try {
  //     final documentSnapshot = await budgetDocumentRef.get();

  //     // Get the last updated date from Firestore, assuming it's stored as a timestamp
  //     DateTime lastUpdated = documentSnapshot.data()?['lastUpdated']?.toDate() ?? DateTime.now();

  //     var budgetReference = await budgetDocumentRef.get();
  //     double currentBudget = budgetReference.data()?['budget'] ?? 0.0;
  //     double weekBudget = budgetReference.data()?['weekBudget'] ?? 0.0;

  //     // Get the current date
  //     DateTime now = DateTime.now();

  //     // Check if it's a new week
  //     if (currentBudget != weekBudget) {
  //       // Reset weekBudget to the current budget
  //       await updateWeekBudget(currentBudget);

  //       // Update the last updated date in Firestore
  //       await budgetDocumentRef.update({
  //         'lastUpdated': FieldValue.serverTimestamp(),
  //       });

  //       log('WeekBudget reset to current budget: $currentBudget due to new week.');
  //     } else {
  //       log('WeekBudget not reset, same week.');
  //     }
  //   } catch (e) {
  //     log('Error checking and resetting week budget: ${e.toString()}');
  //   }
  // }

  // // Debug function to reset weekBudget every second for testing
  // Future<void> startDebugTimer() async {
  //   Timer.periodic(const Duration(days: 7), (timer) async {
  //     log('Checking weekly budget (every 24 hours).');
  //     await checkAndResetWeekBudget();
  //   });
  // }
}
