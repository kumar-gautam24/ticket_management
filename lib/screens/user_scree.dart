import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ticket_bloc/ticket_bloc_bloc.dart';
import '../models/usermodel.dart';
import '../services/auth_services.dart';
import 'add_ticket.dart';
import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  final UserModel user;
  final String userId;

  const UserScreen({super.key, required this.userId, required this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicketBlocBloc>(context)
        .add(FetchTicketsEvent(userId: widget.userId));
  }

  void _deleteTicket(String ticketId) {
    BlocProvider.of<TicketBlocBloc>(context)
        .add(DeleteTicketEvent(ticketId: ticketId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('User ${widget.user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuthService().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to log out: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          BlocProvider.of<TicketBlocBloc>(context)
              .add(FetchTicketsEvent(userId: widget.userId));
        },
        child: BlocBuilder<TicketBlocBloc, TicketBlocState>(
          builder: (context, state) {
            if (state is TicketsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketsLoadedState) {
              print("loded state");
              return ListView.builder(
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = state.tickets[index];
                  print("here in ticket builder");
                  return Dismissible(
                    key: Key(ticket.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteTicket(ticket.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${ticket.title} deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(ticket.title),
                      subtitle: Text('Status: ${ticket.status}'),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No tickets found.'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddTicketScreen(
                      userId: widget.userId,
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
