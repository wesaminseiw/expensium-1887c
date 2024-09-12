part of 'user_actions_cubit.dart';

@immutable
abstract class UserActionsState {}

class UserActionsInitialState extends UserActionsState {}

// Sign out states
class UserActionsSignOutInitialState extends UserActionsState {}

class UserActionsSignOutSuccessState extends UserActionsState {}

class UserActionsSignOutFailureState extends UserActionsState {
  final String error;
  UserActionsSignOutFailureState(this.error);
}

// Delete user states
class UserActionsDeleteUserInitialState extends UserActionsState {}

class UserActionsDeleteUserSuccessState extends UserActionsState {}

class UserActionsDeleteUserFailureState extends UserActionsState {
  final String error;
  UserActionsDeleteUserFailureState(this.error);
}

// Delete user data states
class UserActionsDeleteUserDataInitialState extends UserActionsState {}

class UserActionsDeleteUserDataSuccessState extends UserActionsState {}

class UserActionsDeleteUserDataFailureState extends UserActionsState {
  final String error;
  UserActionsDeleteUserDataFailureState(this.error);
}
