part of 'budget_cubit.dart';

@immutable
abstract class BudgetState {
  final double budget;
  final bool isLoading;

  BudgetState({required this.isLoading, required this.budget});
}

class BudgetInitialState extends BudgetState {
  BudgetInitialState({required super.isLoading, required super.budget});
}

class AddBudgetInitialState extends BudgetState {
  AddBudgetInitialState({required super.budget, required super.isLoading});
}

class AddBudgetLoadingState extends BudgetState {
  AddBudgetLoadingState({required super.budget, required super.isLoading});
}

class AddBudgetSuccessState extends BudgetState {
  AddBudgetSuccessState({required super.budget, required super.isLoading});
}

class AddBudgetFailureState extends BudgetState {
  AddBudgetFailureState({required super.budget, required super.isLoading});
}

class AddBudgetFailureEmptyFieldsState extends BudgetState {
  AddBudgetFailureEmptyFieldsState(
      {required super.budget, required super.isLoading});
}

class GetBudgetLoadingState extends BudgetState {
  GetBudgetLoadingState({required super.budget, required super.isLoading});
}

class GetBudgetSuccessState extends BudgetState {
  GetBudgetSuccessState({required super.isLoading, required super.budget});
}

class GetBudgetFailureState extends BudgetState {
  GetBudgetFailureState({required super.budget, required super.isLoading});
}

class UpdateBudgetLoadingState extends BudgetState {
  UpdateBudgetLoadingState({required super.budget, required super.isLoading});
}

class UpdateBudgetSuccessState extends BudgetState {
  UpdateBudgetSuccessState({required super.budget, required super.isLoading});
}

class UpdateBudgetFailureState extends BudgetState {
  UpdateBudgetFailureState({required super.budget, required super.isLoading});
}

class UpdateBudgetFailureEmptyFieldsState extends BudgetState {
  UpdateBudgetFailureEmptyFieldsState(
      {required super.budget, required super.isLoading});
}

class UpdateBudgetFailureInvalidValueState extends BudgetState {
  UpdateBudgetFailureInvalidValueState(
      {required super.budget, required super.isLoading});
}
