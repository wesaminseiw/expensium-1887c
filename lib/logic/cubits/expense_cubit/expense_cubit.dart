import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensium/data/models/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(const AddExpenseInitialState(isLoading: false));

  void addExpense({
    required String title,
    required TextEditingController amountController,
    required TextEditingController dateController,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final DateFormat dateFormat = DateFormat('yyyy/MM/dd');

    emit(const AddExpenseLoadingState(isLoading: true));

    if (title.isNotEmpty && amountController.text.isNotEmpty) {
      try {
        // Convert text controller to double
        final double amountInt = double.tryParse(amountController.text) ?? 0;
        final double amount = amountInt.toDouble();

        // Convert text controller to date
        final dateToDateTime = dateController.text;
        final DateTime date = dateFormat.parse(dateToDateTime);

        // Create a new expense document with unique ID
        String id = const Uuid().v1();
        var expenses = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('expenses').doc(id);

        // Reference to the budget document
        var budget = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('budget').doc('budget');

        // Fetch the current budget value
        var budgetSnapshot = await budget.get();
        double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;

        // Check if there's enough budget for the expense
        if (currentBudget >= amount) {
          // Subtract the expense from the budget
          double updatedBudget = currentBudget - amount;

          // Add the expense to Firestore
          await expenses.set(
            Expense(
              id: id,
              title: title,
              amount: amount,
              date: date,
            ).toMap(),
          );

          // Update the budget in Firestore
          await budget.update({
            'budget': updatedBudget,
          });
          await fetchWeeklyExpenses();
          emit(const AddExpenseSuccessState(isLoading: false));
        } else {
          // Handle the case where the budget is less than the expense amount
          emit(const AddExpenseFailureNoSufficientFundsState(isLoading: false));
        }
      } catch (e) {
        emit(const AddExpenseFailureState(isLoading: false));
        print(e.toString());
      }
    } else {
      emit(const AddExpenseFailureEmptyFieldsState(isLoading: false));
    }
  }

  Future<List<Expense>> fetchExpenses() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    try {
      var expensesSnapshot = await firestore.collection('transactions').doc(auth.currentUser!.uid).collection('expenses').get();

      await fetchWeeklyExpenses();

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
    emit(const DeleteExpenseLoadingState(isLoading: true));

    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      // Ensure the user is authenticated
      if (auth.currentUser == null) {
        emit(const DeleteExpenseFailureState(isLoading: false));
        return;
      }

      // Reference to the expense document
      var expense = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('expenses').doc(expenseId);

      // Check if the expense document exists
      var expenseSnapshot = await expense.get();
      if (!expenseSnapshot.exists) {
        emit(const DeleteExpenseFailureState(isLoading: false));
        return;
      }

      // Reference to the budget document
      var budget = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('budget').doc('budget');

      // Fetch the current budget value
      var budgetSnapshot = await budget.get();

      // Check if the budget document exists
      if (!budgetSnapshot.exists) {
        emit(const DeleteExpenseFailureState(isLoading: false));
        return;
      }

      double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;
      double updatedBudget = currentBudget + amount;

      // Update the budget value
      await budget.update({
        'budget': updatedBudget,
      });

      // Delete the expense document
      await expense.delete();

      await fetchWeeklyExpenses();

      emit(const DeleteExpenseSuccessState(isLoading: false));
    } catch (e) {
      print('Error deleting expense: $e');
      emit(const DeleteExpenseFailureState(isLoading: false));
    }
  }

  Future<double> fetchWeeklyExpenses() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    emit(const FetchWeeklyExpenseLoadingState(isLoading: true));
    try {
      // Get the current date and the start of the week (e.g., Sunday)
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

      var expensesSnapshot = await firestore
          .collection('transactions')
          .doc(auth.currentUser!.uid)
          .collection('expenses')
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThan: endOfWeek)
          .get();

      double totalExpenses = 0;
      for (var doc in expensesSnapshot.docs) {
        totalExpenses += doc.data()['amount'] as double;
      }

      emit(FetchWeeklyExpenseSuccessState(
        isLoading: false,
        totalExpenses: totalExpenses,
      ));
      return totalExpenses;
    } catch (e) {
      emit(FetchWeeklyExpenseFailureState(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      return 0.00;
    }
  }
}
