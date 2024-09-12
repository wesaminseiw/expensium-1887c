part of 'income_cubit.dart';

@immutable
abstract class IncomeState {
  final bool isLoading;

  IncomeState({required this.isLoading});
}

class AddIncomeInitialState extends IncomeState {
  AddIncomeInitialState({required super.isLoading});
}

class AddIncomeLoadingState extends IncomeState {
  AddIncomeLoadingState({required super.isLoading});
}

class AddIncomeSuccessState extends IncomeState {
  AddIncomeSuccessState({required super.isLoading});
}

class AddIncomeFailureEmptyFieldsState extends IncomeState {
  AddIncomeFailureEmptyFieldsState({required super.isLoading});
}

class AddIncomeFailureState extends IncomeState {
  AddIncomeFailureState({required super.isLoading});
}

class GetIncomeLoadingState extends IncomeState {
  GetIncomeLoadingState({required super.isLoading});
}

class GetIncomeSuccessState extends IncomeState {
  final List<Income> incomes;

  GetIncomeSuccessState({
    required this.incomes,
    required super.isLoading,
  });
}

class GetIncomeFailureState extends IncomeState {
  GetIncomeFailureState({required super.isLoading});
}

class DeleteIncomeLoadingState extends IncomeState {
  DeleteIncomeLoadingState({required super.isLoading});
}

class DeleteIncomeSuccessState extends IncomeState {
  DeleteIncomeSuccessState({required super.isLoading});
}

class DeleteIncomeFailureState extends IncomeState {
  DeleteIncomeFailureState({required super.isLoading});
}
