part of 'login_bloc.dart';

abstract class LoginUserState {
  final bool isLoading;

  LoginUserState({required this.isLoading});
}

class LoginUserInitialState extends LoginUserState {
  LoginUserInitialState({required super.isLoading});
}

class LoginUserLoadingState extends LoginUserState {
  LoginUserLoadingState({required super.isLoading});
}

class LoginUserSuccessStateUnverified extends LoginUserState {
  LoginUserSuccessStateUnverified({required super.isLoading});
}

class LoginUserSuccessStateVerified extends LoginUserState {
  LoginUserSuccessStateVerified({required super.isLoading});
}

class LoginUserFailureState extends LoginUserState {
  final String e;

  LoginUserFailureState({
    required this.e,
    required super.isLoading,
  });
}

class LoginUserFailureWrongCredentialsState extends LoginUserState {
  final String e;

  LoginUserFailureWrongCredentialsState({
    required this.e,
    required super.isLoading,
  });
}

class LoginUserFailureInvalidEmailState extends LoginUserState {
  final String e;

  LoginUserFailureInvalidEmailState({
    required this.e,
    required super.isLoading,
  });
}

class LoginUserFailureEmptyFields extends LoginUserState {
  final String e;

  LoginUserFailureEmptyFields({
    required this.e,
    required super.isLoading,
  });
}
