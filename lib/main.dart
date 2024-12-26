import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/authWrapper.dart';
import 'package:ticket_management/firebase_options.dart';
import 'package:ticket_management/repos/ticket_repo.dart';
import 'blocs/auth_bloc/auth_bloc_bloc.dart';
import 'blocs/ticket_bloc/ticket_bloc_bloc.dart';
import 'services/auth_services.dart';
import 'services/user_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authService: FirebaseAuthService(),
            userServices: UserServices(),
          )..add(
              // fires a bloc event at the time of init
              AuthStarted(),
            ), //
        ),
        BlocProvider(create: (_) => TicketBlocBloc(TicketRepository())),
      ],
      child: const MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}
