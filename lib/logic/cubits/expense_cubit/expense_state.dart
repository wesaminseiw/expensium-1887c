part of 'expense_cubit.dart';

@immutable
abstract class ExpenseState {
  final bool isLoading;

  const ExpenseState({required this.isLoading});
}

class AddExpenseInitialState extends ExpenseState {
  const AddExpenseInitialState({required super.isLoading});
}

class AddExpenseLoadingState extends ExpenseState {
  const AddExpenseLoadingState({required super.isLoading});
}

class AddExpenseSuccessState extends ExpenseState {
  const AddExpenseSuccessState({required super.isLoading});
}

class AddExpenseFailureEmptyFieldsState extends ExpenseState {
  const AddExpenseFailureEmptyFieldsState({required super.isLoading});
}

class AddExpenseFailureState extends ExpenseState {
  const AddExpenseFailureState({required super.isLoading});
}

class AddExpenseFailureNoSufficientFundsState extends ExpenseState {
  const AddExpenseFailureNoSufficientFundsState({required super.isLoading});
}

class GetExpenseInitialState extends ExpenseState {
  const GetExpenseInitialState({required super.isLoading});
}

class GetExpenseLoadingState extends ExpenseState {
  const GetExpenseLoadingState({required super.isLoading});
}

class GetExpenseSuccessState extends ExpenseState {
  final List<Expense> expenses;
  const GetExpenseSuccessState({
    required this.expenses,
    required super.isLoading,
  });
}

class GetExpenseFailureState extends ExpenseState {
  const GetExpenseFailureState({required super.isLoading});
}

class DeleteExpenseLoadingState extends ExpenseState {
  const DeleteExpenseLoadingState({required super.isLoading});
}

class DeleteExpenseSuccessState extends ExpenseState {
  const DeleteExpenseSuccessState({required super.isLoading});
}

class DeleteExpenseFailureState extends ExpenseState {
  const DeleteExpenseFailureState({required super.isLoading});
}

class FetchWeeklyExpenseLoadingState extends ExpenseState {
  const FetchWeeklyExpenseLoadingState({required super.isLoading});
}

class FetchWeeklyExpenseSuccessState extends ExpenseState {
  final double totalExpenses;
  const FetchWeeklyExpenseSuccessState({
    required this.totalExpenses,
    required super.isLoading,
  });
}

class FetchWeeklyExpenseFailureState extends ExpenseState {
  final String errorMessage;
  const FetchWeeklyExpenseFailureState({
    required this.errorMessage,
    required super.isLoading,
  });
}
