part of 'get_display_name_cubit.dart';

@immutable
abstract class GetDisplayNameState {
  final bool isLoading;

  GetDisplayNameState({required this.isLoading});
}

class GetDisplayNameInitialState extends GetDisplayNameState {
  GetDisplayNameInitialState({required super.isLoading});
}

class GetDisplayNameLoadingState extends GetDisplayNameState {
  GetDisplayNameLoadingState({required super.isLoading});
}

class GetDisplayNameSuccessState extends GetDisplayNameState {
  final String username;

  GetDisplayNameSuccessState({
    required this.username,
    required super.isLoading,
  });
}

class GetDisplayNameFailureState extends GetDisplayNameState {
  GetDisplayNameFailureState({required super.isLoading});
}
