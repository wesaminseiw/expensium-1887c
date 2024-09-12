part of 'login_bloc.dart';

abstract class LoginUserEvent {}

class LoggedInUserEvent extends LoginUserEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoggedInUserEvent({
    required this.email,
    required this.password,
    required this.context,
  });
}
