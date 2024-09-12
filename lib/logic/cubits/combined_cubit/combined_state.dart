part of 'combined_cubit.dart';

abstract class CombinedState {
  final bool isLoading;
  const CombinedState({required this.isLoading});
}

class CombinedInitialState extends CombinedState {
  CombinedInitialState({required super.isLoading});
}

class CombinedLoadingState extends CombinedState {
  CombinedLoadingState({required super.isLoading});
}

class CombinedSuccessState extends CombinedState {
  final List<dynamic> combinedList;

  CombinedSuccessState({
    required this.combinedList,
    required super.isLoading,
  });
}

class CombinedFailureState extends CombinedState {
  CombinedFailureState({required super.isLoading});
}
