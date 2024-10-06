import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensium/data/models/income_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit() : super(const AddIncomeInitialState(isLoading: false));

  void addIncome({
    required String title,
    required TextEditingController amountController,
    required TextEditingController dateController,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final DateFormat dateFormat = DateFormat('yyyy/MM/dd');

    emit(const AddIncomeLoadingState(isLoading: true));

    if (title.isNotEmpty && amountController.text.isNotEmpty) {
      try {
        // convert text controller to int
        final double amountInt = double.tryParse(amountController.text) ?? 0;
        final double amount = amountInt.toDouble();

        // convert text controller to date
        final dateToDateTime = dateController.text;
        final DateTime date = dateFormat.parse(dateToDateTime);
        try {
          String id = const Uuid().v1();
          var incomes = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('incomes').doc(id);

          // Reference to the budget document
          var budget = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('budget').doc('budget');

          // Fetch the current budget value
          var budgetSnapshot = await budget.get();
          double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;

          // Subtract the expense from the budget
          double updatedBudget = currentBudget + amount;

          // Add the expense to Firestore
          await incomes.set(
            Income(
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
          await fetchWeeklyIncomes();
          emit(const AddIncomeSuccessState(isLoading: false));
        } catch (e) {
          emit(const AddIncomeFailureState(isLoading: false));
          print(e.toString());
        }
      } on FormatException {
        emit(const AddIncomeFailureEmptyFieldsState(isLoading: false));
      }
    } else {
      emit(const AddIncomeFailureEmptyFieldsState(isLoading: false));
    }
  }

  Future<List<Income>> fetchIncomes() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    try {
      var incomesSnapshot = await firestore.collection('transactions').doc(auth.currentUser!.uid).collection('incomes').get();

      await fetchWeeklyIncomes();

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
    emit(const DeleteIncomeLoadingState(isLoading: true));

    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      if (auth.currentUser == null) {
        emit(const DeleteIncomeFailureState(isLoading: false));
        return;
      }

      var income = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('incomes').doc(incomeId);

      var incomeSnapshot = await income.get();
      if (!incomeSnapshot.exists) {
        emit(const DeleteIncomeFailureState(isLoading: false));
        return;
      }

      // Reference to the budget document
      var budget = firestore.collection('transactions').doc(auth.currentUser!.uid).collection('budget').doc('budget');

      var budgetSnapshot = await budget.get();

      if (!budgetSnapshot.exists) {
        emit(const DeleteIncomeFailureState(isLoading: false));
        return;
      }

      double currentBudget = budgetSnapshot.data()?['budget'] ?? 0;
      double updatedBudget = currentBudget - amount;

      // Update the budget value
      await budget.update({
        'budget': updatedBudget,
      });

      // Delete the income document
      await income.delete();

      await fetchWeeklyIncomes();

      emit(const DeleteIncomeSuccessState(isLoading: false));
    } catch (e) {
      print('Error deleting income: $e');
      emit(const DeleteIncomeFailureState(isLoading: false));
    }
  }

  Future<double> fetchWeeklyIncomes() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    emit(const FetchWeeklyIncomeLoadingState(isLoading: true));
    try {
      // Get the current date and the start of the week (e.g., Sunday)
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

      var incomesSnapshot = await firestore
          .collection('transactions')
          .doc(auth.currentUser!.uid)
          .collection('incomes')
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThan: endOfWeek)
          .get();

      double totalIncomes = 0;
      for (var doc in incomesSnapshot.docs) {
        totalIncomes += doc.data()['amount'] as double;
      }

      emit(FetchWeeklyIncomeSuccessState(
        isLoading: false,
        totalIncomes: totalIncomes,
      ));
      return totalIncomes;
    } catch (e) {
      emit(FetchWeeklyIncomeFailureState(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      return 0.00;
    }
  }
}
