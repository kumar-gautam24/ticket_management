import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/firebase_options.dart';
import 'package:ticket_management/screens/login_screen.dart';
import 'package:ticket_management/services/firestore_repo.dart';
import 'blocs/ticket_bloc/ticket_bloc_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TicketBlocBloc(TicketRepository())),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
