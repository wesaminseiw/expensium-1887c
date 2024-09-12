part of 'expense_cubit.dart';

@immutable
abstract class ExpenseState {
  final bool isLoading;

  ExpenseState({required this.isLoading});
}

class AddExpenseInitialState extends ExpenseState {
  AddExpenseInitialState({required super.isLoading});
}

class AddExpenseLoadingState extends ExpenseState {
  AddExpenseLoadingState({required super.isLoading});
}

class AddExpenseSuccessState extends ExpenseState {
  AddExpenseSuccessState({required super.isLoading});
}

class AddExpenseFailureEmptyFieldsState extends ExpenseState {
  AddExpenseFailureEmptyFieldsState({required super.isLoading});
}

class AddExpenseFailureState extends ExpenseState {
  AddExpenseFailureState({required super.isLoading});
}

class AddExpenseFailureNoSufficientFundsState extends ExpenseState {
  AddExpenseFailureNoSufficientFundsState({required super.isLoading});
}

class GetExpenseInitialState extends ExpenseState {
  GetExpenseInitialState({required super.isLoading});
}

class GetExpenseLoadingState extends ExpenseState {
  GetExpenseLoadingState({required super.isLoading});
}

class GetExpenseSuccessState extends ExpenseState {
  final List<Expense> expenses;
  GetExpenseSuccessState({
    required this.expenses,
    required super.isLoading,
  });
}

class GetExpenseFailureState extends ExpenseState {
  GetExpenseFailureState({required super.isLoading});
}

class DeleteExpenseLoadingState extends ExpenseState {
  DeleteExpenseLoadingState({required super.isLoading});
}

class DeleteExpenseSuccessState extends ExpenseState {
  DeleteExpenseSuccessState({required super.isLoading});
}

class DeleteExpenseFailureState extends ExpenseState {
  DeleteExpenseFailureState({required super.isLoading});
}
