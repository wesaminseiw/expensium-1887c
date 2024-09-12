part of 'register_bloc.dart';

class RegisterUserState {
  final bool isLoading;

  RegisterUserState({required this.isLoading});
}

class RegisterUserInitialState extends RegisterUserState {
  RegisterUserInitialState({required super.isLoading});
}

class RegisterUserLoadingState extends RegisterUserState {
  RegisterUserLoadingState({required super.isLoading});
}

class RegisterUserSuccessState extends RegisterUserState {
  RegisterUserSuccessState({required super.isLoading});
}

class RegisterUserFailureState extends RegisterUserState {
  final String e;

  RegisterUserFailureState({
    required this.e,
    required super.isLoading,
  });
}

class RegisterUserFailureInvalidEmailState extends RegisterUserState {
  final String e;

  RegisterUserFailureInvalidEmailState({
    required this.e,
    required super.isLoading,
  });
}

class RegisterUserFailureEmailExistsState extends RegisterUserState {
  final String e;

  RegisterUserFailureEmailExistsState({
    required this.e,
    required super.isLoading,
  });
}

class RegisterUserFailureInvalidPasswordState extends RegisterUserState {
  final String e;

  RegisterUserFailureInvalidPasswordState({
    required this.e,
    required super.isLoading,
  });
}

class RegisterUserFailureEmptyFields extends RegisterUserState {
  final String e;

  RegisterUserFailureEmptyFields({
    required this.e,
    required super.isLoading,
  });
}
