part of 'user_actions_cubit.dart';

@immutable
abstract class UserActionsState {
  final bool isLoading;

  const UserActionsState({required this.isLoading});
}

class UserActionsInitialState extends UserActionsState {
  const UserActionsInitialState({required super.isLoading});
}

// Sign out states
class UserActionsSignOutLoadingState extends UserActionsState {
  const UserActionsSignOutLoadingState({required super.isLoading});
}

class UserActionsSignOutSuccessState extends UserActionsState {
  const UserActionsSignOutSuccessState({required super.isLoading});
}

class UserActionsSignOutFailureState extends UserActionsState {
  final String error;
  const UserActionsSignOutFailureState({
    required this.error,
    required super.isLoading,
  });
}

// Delete user states
class UserActionsDeleteUserLoadingState extends UserActionsState {
  const UserActionsDeleteUserLoadingState({required super.isLoading});
}

class UserActionsDeleteUserSuccessState extends UserActionsState {
  const UserActionsDeleteUserSuccessState({required super.isLoading});
}

class UserActionsDeleteUserFailureState extends UserActionsState {
  final String error;
  const UserActionsDeleteUserFailureState({
    required this.error,
    required super.isLoading,
  });
}

// Delete user data states
class UserActionsDeleteUserDataLoadingState extends UserActionsState {
  const UserActionsDeleteUserDataLoadingState({required super.isLoading});
}

class UserActionsDeleteUserDataSuccessState extends UserActionsState {
  const UserActionsDeleteUserDataSuccessState({required super.isLoading});
}

class UserActionsDeleteUserDataFailureState extends UserActionsState {
  final String error;
  const UserActionsDeleteUserDataFailureState({
    required this.error,
    required super.isLoading,
  });
}

// verify user data states
class UserActionsCheckVerificationLoadingState extends UserActionsState {
  const UserActionsCheckVerificationLoadingState({required super.isLoading});
}

class UserActionsVerifiedState extends UserActionsState {
  const UserActionsVerifiedState({required super.isLoading});
}

class UserActionsNotVerifiedState extends UserActionsState {
  const UserActionsNotVerifiedState({required super.isLoading});
}

class UserActionsUserIsDeletedOrSignedOutState extends UserActionsState {
  const UserActionsUserIsDeletedOrSignedOutState({required super.isLoading});
}
