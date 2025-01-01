import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_management/models/user_model.dart';
import 'package:ticket_management/services/auth_services.dart';
import 'package:ticket_management/services/user_services.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserServices userServices;

  AuthBloc({required this.authService, required this.userServices})
      : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoggedOut>(onLoggedOut);
  }

  /// Handle app start and authentication state check
  Future<void> _onAuthStarted(
      AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('AuthStarted bloc event fired');
    try {
      // Listen to authentication state changes
      await _firebaseAuth.authStateChanges().listen((user) async {
        if (user == null) {
          emit(Unauthenticated());
        } else {
          final userId = user.uid;
          final role = await userServices.getUserRole(userId);
          final userModel = await userServices.getUserById(userId);
          if (!emit.isDone) {
            emit(Authenticated(user: userModel!, role: role));
          }
        }
      }).asFuture();
    } catch (e) {
      if (!emit.isDone) {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  /// Handle login
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(event.email, event.password);
      final role = await userServices.getUserRole(user!.id);
      emit(Authenticated(user: user, role: role));
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
  Future<void> onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await authService.logout();
    emit(Unauthenticated());
  }
}
