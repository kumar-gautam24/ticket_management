part of 'auth_bloc_bloc.dart';



abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final String name;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, role, name];
}

class LoggedOut extends AuthEvent {}
