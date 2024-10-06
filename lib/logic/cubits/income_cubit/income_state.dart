part of 'income_cubit.dart';

@immutable
abstract class IncomeState {
  final bool isLoading;

  const IncomeState({required this.isLoading});
}

class AddIncomeInitialState extends IncomeState {
  const AddIncomeInitialState({required super.isLoading});
}

class AddIncomeLoadingState extends IncomeState {
  const AddIncomeLoadingState({required super.isLoading});
}

class AddIncomeSuccessState extends IncomeState {
  const AddIncomeSuccessState({required super.isLoading});
}

class AddIncomeFailureEmptyFieldsState extends IncomeState {
  const AddIncomeFailureEmptyFieldsState({required super.isLoading});
}

class AddIncomeFailureState extends IncomeState {
  const AddIncomeFailureState({required super.isLoading});
}

class GetIncomeLoadingState extends IncomeState {
  const GetIncomeLoadingState({required super.isLoading});
}

class GetIncomeSuccessState extends IncomeState {
  final List<Income> incomes;

  const GetIncomeSuccessState({
    required this.incomes,
    required super.isLoading,
  });
}

class GetIncomeFailureState extends IncomeState {
  const GetIncomeFailureState({required super.isLoading});
}

class DeleteIncomeLoadingState extends IncomeState {
  const DeleteIncomeLoadingState({required super.isLoading});
}

class DeleteIncomeSuccessState extends IncomeState {
  const DeleteIncomeSuccessState({required super.isLoading});
}

class DeleteIncomeFailureState extends IncomeState {
  const DeleteIncomeFailureState({required super.isLoading});
}

class FetchWeeklyIncomeLoadingState extends IncomeState {
  const FetchWeeklyIncomeLoadingState({required super.isLoading});
}

class FetchWeeklyIncomeSuccessState extends IncomeState {
  final double totalIncomes;
  const FetchWeeklyIncomeSuccessState({
    required this.totalIncomes,
    required super.isLoading,
  });
}

class FetchWeeklyIncomeFailureState extends IncomeState {
  final String errorMessage;
  const FetchWeeklyIncomeFailureState({
    required this.errorMessage,
    required super.isLoading,
  });
}
