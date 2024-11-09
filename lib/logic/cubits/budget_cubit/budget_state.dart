part of 'budget_cubit.dart';

@immutable
abstract class BudgetState {
  final double budget;
  final bool isLoading;

  const BudgetState({required this.isLoading, required this.budget});
}

class BudgetInitialState extends BudgetState {
  const BudgetInitialState({required super.isLoading, required super.budget});
}

class AddBudgetInitialState extends BudgetState {
  const AddBudgetInitialState({required super.budget, required super.isLoading});
}

class AddBudgetLoadingState extends BudgetState {
  const AddBudgetLoadingState({required super.budget, required super.isLoading});
}

class AddBudgetSuccessState extends BudgetState {
  const AddBudgetSuccessState({required super.budget, required super.isLoading});
}

class AddBudgetFailureState extends BudgetState {
  const AddBudgetFailureState({required super.budget, required super.isLoading});
}

class AddBudgetFailureEmptyFieldsState extends BudgetState {
  const AddBudgetFailureEmptyFieldsState({required super.budget, required super.isLoading});
}

class GetBudgetLoadingState extends BudgetState {
  const GetBudgetLoadingState({
    required super.budget,
    required super.isLoading,
  });
}

// ignore: must_be_immutable
class GetBudgetSuccessState extends BudgetState {
  double? budgetChange;
  GetBudgetSuccessState({
    this.budgetChange,
    required super.budget,
    required super.isLoading,
  });
}

class GetBudgetFailureState extends BudgetState {
  const GetBudgetFailureState({
    required super.budget,
    required super.isLoading,
  });
}

class UpdateBudgetLoadingState extends BudgetState {
  const UpdateBudgetLoadingState({required super.budget, required super.isLoading});
}

class UpdateBudgetSuccessState extends BudgetState {
  const UpdateBudgetSuccessState({required super.budget, required super.isLoading});
}

class UpdateBudgetFailureState extends BudgetState {
  const UpdateBudgetFailureState({required super.budget, required super.isLoading});
}

class UpdateBudgetFailureEmptyFieldsState extends BudgetState {
  const UpdateBudgetFailureEmptyFieldsState({required super.budget, required super.isLoading});
}

class UpdateBudgetFailureInvalidValueState extends BudgetState {
  const UpdateBudgetFailureInvalidValueState({required super.budget, required super.isLoading});
}

class CalculateBudgetChangeLoadingState extends BudgetState {
  final double budgetChange;
  const CalculateBudgetChangeLoadingState({
    required this.budgetChange,
    required super.isLoading,
  }) : super(budget: 0.0);
}



// class UpdateWeekBudgetLoadingState extends BudgetState {
//   const UpdateWeekBudgetLoadingState({
//     required super.budget,
//     required super.isLoading,
//   });
// }

// class UpdateWeekBudgetSuccessState extends BudgetState {
//   double? newWeekBudget;
//   UpdateWeekBudgetSuccessState({
//     this.newWeekBudget,
//     required super.budget,
//     required super.isLoading,
//   });
// }

// class UpdateWeekBudgetFailureState extends BudgetState {
//   const UpdateWeekBudgetFailureState({
//     required super.budget,
//     required super.isLoading,
//   });
// }
