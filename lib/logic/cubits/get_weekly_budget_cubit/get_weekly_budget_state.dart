part of 'get_weekly_budget_cubit.dart';

@immutable
abstract class GetWeeklyBudgetState {
  final bool isLoading;
  final int income;
  final double weeklyDifference;

  const GetWeeklyBudgetState({
    required this.income,
    required this.isLoading,
    required this.weeklyDifference,
  });
}

class GetWeeklyBudgetDifferenceInitialState extends GetWeeklyBudgetState {
  const GetWeeklyBudgetDifferenceInitialState({
    required super.weeklyDifference,
    required super.isLoading,
    required super.income,
  });
}

class GetWeeklyBudgetDifferenceLoadingState extends GetWeeklyBudgetState {
  const GetWeeklyBudgetDifferenceLoadingState({
    required super.weeklyDifference,
    required super.isLoading,
    required super.income,
  });
}

class GetWeeklyBudgetDifferenceSuccessState extends GetWeeklyBudgetState {
  const GetWeeklyBudgetDifferenceSuccessState({
    required super.weeklyDifference,
    required super.isLoading,
    required super.income,
  });
}

class GetWeeklyBudgetDifferenceFailureState extends GetWeeklyBudgetState {
  const GetWeeklyBudgetDifferenceFailureState({
    required super.weeklyDifference,
    required super.isLoading,
    required super.income,
  });
}
