import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensium/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(BudgetInitialState(budget: 0, isLoading: false));

  void addBudget(
    BuildContext context, {
    required TextEditingController budgetController,
  }) async {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    final _userId = _auth.currentUser!.uid;
    final _budgetDocumentRef = _firestore
        .collection('transactions')
        .doc(_userId)
        .collection('budget')
        .doc('budget');

    emit(AddBudgetLoadingState(budget: 0, isLoading: true));

    if (budgetController.text.isNotEmpty) {
      try {
        // convert text controller to int
        final double _budgetInt = double.tryParse(budgetController.text) ?? 0;
        final double _budget = _budgetInt.toDouble();

        await _budgetDocumentRef.set({
          'budget': _budget,
        });

        final budget = await getBudgetValue();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );

        emit(AddBudgetSuccessState(budget: budget, isLoading: false));
      } catch (e) {
        emit(AddBudgetFailureState(budget: 0, isLoading: false));
      }
    } else {
      emit(AddBudgetFailureEmptyFieldsState(budget: 0, isLoading: false));
    }
  }

  Future<double> getBudgetValue() async {
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _firestore = FirebaseFirestore.instance;

    // Reference to the budget document
    final _budgetDocumentRef = _firestore
        .collection('transactions')
        .doc(_userId)
        .collection('budget')
        .doc('budget');
    emit(GetBudgetLoadingState(budget: 0, isLoading: true));
    try {
      // Fetch the document
      final _documentSnapshot = await _budgetDocumentRef.get();

      // Check if the document exists and retrieve the integer field value

      double budgetValue = _documentSnapshot.data()?['budget'];
      emit(GetBudgetSuccessState(budget: budgetValue, isLoading: false));
      log('========= SUCCEED TO GET BUDGET =========');
      return budgetValue;
    } catch (e) {
      emit(GetBudgetFailureState(budget: 0, isLoading: false));
      log('========= FAILED TO GET BUDGET =========');
      return 0;
    }
  }

  Future<bool> checkIfBudgetCollectionExists() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final budgetDocRef = FirebaseFirestore.instance
        .collection('transactions')
        .doc(userId)
        .collection('budget')
        .doc('budget'); // Referencing a single document

    try {
      // Fetch the budget document
      final budgetSnapshot = await budgetDocRef.get();

      // Check if the document exists
      if (budgetSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking budget collection: ${e.toString()}');
      return false;
    }
  }

  void updateBudget({
    required TextEditingController newBudgetController,
  }) async {
    final _userId = FirebaseAuth.instance.currentUser!.uid;
    final _firestore = FirebaseFirestore.instance;

    emit(UpdateBudgetLoadingState(budget: 0, isLoading: true));

    if (newBudgetController.text.isNotEmpty) {
      // Convert text from the controller to a double
      final double _newBudget = double.tryParse(newBudgetController.text) ?? 0;

      if (_newBudget > 0) {
        // Reference to the budget document in Firestore
        final _budgetDocumentRef = _firestore
            .collection('transactions')
            .doc(_userId)
            .collection('budget')
            .doc('budget');

        // Set the new budget value in Firestore
        await _budgetDocumentRef.set({
          'budget': _newBudget,
        });

        // Emit the updated budget value in the success state
        emit(UpdateBudgetSuccessState(budget: _newBudget, isLoading: false));
      } else {
        emit(UpdateBudgetFailureInvalidValueState(budget: 0, isLoading: false));
      }
    } else {
      emit(UpdateBudgetFailureEmptyFieldsState(budget: 0, isLoading: false));
    }
  }
}
