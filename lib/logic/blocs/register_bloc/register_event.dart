part of 'register_bloc.dart';

abstract class RegisterUserEvent {}

class RegisteredUserEvent extends RegisterUserEvent {
  final String email;
  final String password;
  final BuildContext context;

  RegisteredUserEvent({
    required this.email,
    required this.password,
    required this.context,
  });
}
