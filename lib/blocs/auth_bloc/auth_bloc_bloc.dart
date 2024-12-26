import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticket_management/models/usermodel.dart';
import 'package:ticket_management/services/auth_services.dart';
import 'package:ticket_management/services/user_services.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  final UserServices userServices;

  AuthBloc({required this.authService, required this.userServices})
      : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoggedOut>(_onLoggedOut);
  }

  /// Handle app start and authentication state check
  Future<void> _onAuthStarted(
      AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userId = userServices.getUserId();
      if (userId != null) {
        final user = await userServices.getUserById(userId);
        final role = await userServices.getUserRole(userId);
        emit(Authenticated(user: user!, role: role));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(
          message: 'Error checking authentication state: ${e.toString()}'));
    }
  }

  /// Handle login
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(event.email, event.password);
      final role = await userServices.getUserRole(user!.id);
      emit(Authenticated(user: user, role: role!));
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  /// Handle registration
  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.register(
        event.email,
        event.password,
        event.role,
        event.name,
      );
      emit(Authenticated(user: user!, role: event.role));
    } catch (e) {
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  /// Handle logout
  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await authService.logout();
    emit(Unauthenticated());
  }
}
