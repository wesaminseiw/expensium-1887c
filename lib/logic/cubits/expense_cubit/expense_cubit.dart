import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensium/data/models/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(AddExpenseInitialState(isLoading: false));

  void addExpense({
    required String title,
    required TextEditingController amountController,
    required TextEditingController dateController,
  }) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

    emit(AddExpenseLoadingState(isLoading: true));

    if (title.isNotEmpty && amountController.text.isNotEmpty) {
      try {
        // Convert text controller to double
        final double amountInt = double.tryParse(amountController.text) ?? 0;
        final double amount = amountInt.toDouble();

        // Convert text controller to date
        final _dateToDateTime = dateController.text;
        final DateTime date = _dateFormat.parse(_dateToDateTime);

        // Create a new expense document with unique ID
        String _id = const Uuid().v1();
        var _expenses = _firestore
            .collection('transactions')
            .doc(_auth.currentUser!.uid)
            .collection('expenses')
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

        // Check if there's enough budget for the expense
        if (currentBudget >= amount) {
          // Subtract the expense from the budget
          double updatedBudget = currentBudget - amount;

          // Add the expense to Firestore
          await _expenses.set(
            Expense(
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
          emit(AddExpenseSuccessState(isLoading: false));
        } else {
          // Handle the case where the budget is less than the expense amount
          emit(AddExpenseFailureNoSufficientFundsState(isLoading: false));
        }
      } catch (e) {
        emit(AddExpenseFailureState(isLoading: false));
        print(e.toString());
      }
    } else {
      emit(AddExpenseFailureEmptyFieldsState(isLoading: false));
    }
  }

  Future<List<Expense>> fetchExpenses() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    try {
      var expensesSnapshot = await _firestore
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('expenses')
          .get();

      return expensesSnapshot.docs.map((doc) {
        Map<String, dynamic> expenseData = doc.data();
        return Expense(
          id: expenseData['id'],
          title: expenseData['title'],
          amount: expenseData['amount'],
          date: (expenseData['date'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  void deleteExpense({
    required String expenseId,
    required double amount,
  }) async {
    emit(DeleteExpenseLoadingState(isLoading: true));

    try {
      final _firestore = FirebaseFirestore.instance;
      final _auth = FirebaseAuth.instance;

      // Ensure the user is authenticated
      if (_auth.currentUser == null) {
        emit(DeleteExpenseFailureState(isLoading: false));
        return;
      }

      // Reference to the expense document
      var expense = _firestore
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('expenses')
          .doc(expenseId);

      // Check if the expense document exists
      var expenseSnapshot = await expense.get();
      if (!expenseSnapshot.exists) {
        emit(DeleteExpenseFailureState(isLoading: false));
        return;
      }

      // Reference to the budget document
      var _budget = _firestore
          .collection('transactions')
          .doc(_auth.currentUser!.uid)
          .collection('budget')
          .doc('budget');

      // Fetch the current budget value
      var budgetSnapshot = await _budget.get();

      // Check if the budget document exists
      if (!budgetSnapshot.exists) {
        emit(DeleteExpenseFailureState(isLoading: false));
        return;
      }

      double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;
      double updatedBudget = currentBudget + amount;

      // Update the budget value
      await _budget.update({
        'budget': updatedBudget,
      });

      // Delete the expense document
      await expense.delete();

      emit(DeleteExpenseSuccessState(isLoading: false));
    } catch (e) {
      print('Error deleting expense: $e');
      emit(DeleteExpenseFailureState(isLoading: false));
    }
  }
}
