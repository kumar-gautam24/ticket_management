import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/models/user_model.dart';

import '../blocs/ticket_bloc/ticket_bloc_bloc.dart';
import '../services/auth_services.dart';
import 'login_screen.dart';

class EmployeeScreen extends StatefulWidget {
  final UserModel user;
  final String employeeId;

  const EmployeeScreen(
      {super.key, required this.employeeId, required this.user});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicketBlocBloc>(context).add(FetchTicketsEvent(userId: widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee ${widget.user.name}'),
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
      body: BlocBuilder<TicketBlocBloc, TicketBlocState>(
        builder: (context, state) {
          if (state is TicketsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TicketsLoadedState) {
            final assignedTickets = state.tickets
                .where((ticket) => ticket.assignedTo == widget.employeeId)
                .toList();
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                BlocProvider.of<TicketBlocBloc>(context)
                    .add(FetchTicketsEvent(userId: widget.user.id));
              },
              child: ListView.builder(
                itemCount: assignedTickets.length,
                itemBuilder: (context, index) {
                  final ticket = assignedTickets[index];
                  return ListTile(
                    title: Text(ticket.title),
                    subtitle: Text('Status: ${ticket.status}'),
                    trailing: ticket.status == "Resolved"
                        ? ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<TicketBlocBloc>(context).add(
                                UpdateTicketEvent(
                                   ticketId: ticket.id,
                                  newStatus: 'Resolved',
                                  employeeId: widget.employeeId,
                                ),
                              );
                              BlocProvider.of<TicketBlocBloc>(context)
                                  .add(FetchTicketsEvent(userId: widget.user.id));
                            },
                            child: const Text(
                              'Resolve',
                            ))
                        : const Text(
                            "Resolved",
                            style: TextStyle(color: Colors.green),
                          ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No tickets assigned.'));
          }
        },
      ),
    );
  }
}
