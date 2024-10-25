import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import '../expense_cubit/expense_cubit.dart';
import '../income_cubit/income_cubit.dart';

part 'get_weekly_budget_state.dart';

class GetWeeklyBudgetCubit extends Cubit<GetWeeklyBudgetState> {
  GetWeeklyBudgetCubit() : super(const GetWeeklyBudgetDifferenceInitialState(weeklyDifference: 0, isLoading: false, income: 0));

  void getWeeklyDifference() async {
    double weeklyIncomes = await IncomeCubit().fetchWeeklyIncomes();
    double weeklyExpenses = await ExpenseCubit().fetchWeeklyExpenses();

    emit(const GetWeeklyBudgetDifferenceLoadingState(isLoading: true, weeklyDifference: 0.0, income: 0));

    try {
      double budgetDifference = weeklyIncomes - weeklyExpenses;
      if (budgetDifference < 0) {
        emit(GetWeeklyBudgetDifferenceSuccessState(
          isLoading: false,
          weeklyDifference: budgetDifference,
          income: -1,
        ));
      } else if (budgetDifference == 0) {
        emit(GetWeeklyBudgetDifferenceSuccessState(
          isLoading: false,
          weeklyDifference: budgetDifference,
          income: 0,
        ));
      } else if (budgetDifference > 0) {
        emit(GetWeeklyBudgetDifferenceSuccessState(
          isLoading: false,
          weeklyDifference: budgetDifference,
          income: 1,
        ));
      }
    } catch (e) {
      emit(const GetWeeklyBudgetDifferenceFailureState(
        weeklyDifference: 0,
        isLoading: false,
        income: 0,
      ));
    }
  }
}
