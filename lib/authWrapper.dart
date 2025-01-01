import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth_bloc/auth_bloc_bloc.dart';
import 'screens/admin_screen.dart';
import 'screens/employee_scree.dart';
import 'screens/login_screen.dart';
import 'screens/user_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          print('AuthLoading');
          return const Center(child: CircularProgressIndicator());
        } else if (state is Authenticated) {
          // Navigate based on role
          if (state.role == 'admin') {
            return AdminScreen(user: state.user);
          } else if (state.role == 'employee') {
            return EmployeeScreen(employeeId: state.user.id, user: state.user);
          } else {
            return UserScreen(userId: state.user.id, user: state.user);
          }
        } else if (state is Unauthenticated) {
          return const LoginScreen();
        } else if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        }
        return const SizedBox.shrink(); // Default fallback
      },
    );
  }
}
