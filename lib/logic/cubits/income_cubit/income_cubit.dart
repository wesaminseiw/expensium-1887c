import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit() : super(AddIncomeInitialState(isLoading: false));

  void addIncome({
    required String title,
    required TextEditingController amountController,
    required TextEditingController dateController,
  }) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

    emit(AddIncomeLoadingState(isLoading: true));

    if (title.isNotEmpty && amountController.text.isNotEmpty) {
      try {
        // convert text controller to int
        final double amountInt = double.tryParse(amountController.text) ?? 0;
        final double amount = amountInt.toDouble();

        // convert text controller to date
        final _dateToDateTime = dateController.text;
        final DateTime date = _dateFormat.parse(_dateToDateTime);
        try {
          String _id = const Uuid().v1();
          var _incomes = _firestore
              .collection('transactions')
              .doc(_auth.currentUser!.uid)
              .collection('incomes')
              .doc(_id);

          // Reference to the budget document
          var _budget = _firestore
              .collection('transactions')
              .doc(_auth.currentUser!.uid)
              .collection('budget')
              .doc('budget');

          // Fetch the current budget value
          var budgetSnapshot = await _budget.get();
          double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;

          // Subtract the expense from the budget
          double updatedBudget = currentBudget + amount;

          // Add the expense to Firestore
          await _incomes.set(
            Income(
              id: _id,
              title: title,
              amount: amount,
              date: date,
            ).toMap(),
          );

          // Update the budget in Firestore
          await _budget.update({
            'budget': updatedBudget,
          });
          emit(AddIncomeSuccessState(isLoading: false));
        } catch (e) {
          emit(AddIncomeFailureState(isLoading: false));
          print(e.toString());
        }
      } on FormatException {
        emit(AddIncomeFailureEmptyFieldsState(isLoading: false));
      }
    } else {
      emit(AddIncomeFailureEmptyFieldsState(isLoading: false));
    }
  }

  Future<List<Income>> fetchIncomes() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    try {
      var incomesSnapshot = await _firestore
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('incomes')
          .get();

      return incomesSnapshot.docs.map((doc) {
        Map<String, dynamic> incomeData = doc.data();
        return Income(
          id: incomeData['id'],
          title: incomeData['title'],
          amount: incomeData['amount'],
          date: (incomeData['date'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  void deleteIncome({
    required String incomeId,
    required double amount,
  }) async {
    emit(DeleteIncomeLoadingState(isLoading: true));

    try {
      final _firestore = FirebaseFirestore.instance;
      final _auth = FirebaseAuth.instance;

      if (_auth.currentUser == null) {
        emit(DeleteIncomeFailureState(isLoading: false));
        return;
      }

      var income = _firestore
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('incomes')
          .doc(incomeId);

      var incomeSnapshot = await income.get();
      if (!incomeSnapshot.exists) {
        emit(DeleteIncomeFailureState(isLoading: false));
        return;
      }

      // Reference to the budget document
      var _budget = _firestore
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('budget')
          .doc('budget');

      var budgetSnapshot = await _budget.get();

      if (!budgetSnapshot.exists) {
        emit(DeleteIncomeFailureState(isLoading: false));
        return;
      }

      double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;
      double updatedBudget = currentBudget - amount;

      // Update the budget value
      await _budget.update({
        'budget': updatedBudget,
      });

      // Delete the income document
      await income.delete();

      emit(DeleteIncomeSuccessState(isLoading: false));
    } catch (e) {
      print('Error deleting income: $e');
      emit(DeleteIncomeFailureState(isLoading: false));
    }
  }
}
