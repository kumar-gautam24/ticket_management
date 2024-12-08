import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/screens/add_userscreen.dart';
import 'package:ticket_management/services/firestore_repo.dart';
import '../blocs/ticket_bloc/ticket_bloc_bloc.dart';
import '../services/auth_services.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicketBlocBloc>(context)
        .add(FetchTicketsEvent());
  }

 
  void _deleteTicket(String ticketId) {
    BlocProvider.of<TicketBlocBloc>(context)
        .add(DeleteTicketEvent(ticketId: ticketId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
            return ListView.builder(
              itemCount: state.tickets.length,
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
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
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Assign') {
                          _showAssignDialog(context, ticket.id);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'Assign', child: Text('Assign')),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No tickets available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddUserScreen()));
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAssignDialog(BuildContext context, String ticketId) async {
    // Fetch list of employees with the role 'employee'
    final employeeIds = await TicketRepository().getEmployeeIdsByRole('employee');

    // Displaying employee IDs in the dialog
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Assign Ticket'),
          content: employeeIds.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: employeeIds.map((employeeId) {
                    return ListTile(
                      title: Text(employeeId), // Using employee ID as "name"
                      onTap: () {
                        // Assign the ticket to the selected employee ID
                        BlocProvider.of<TicketBlocBloc>(context).add(
                          UpdateTicketEvent(ticketId, 'Assigned', employeeId),
                        );
                        Navigator.pop(context); // Close the dialog
                      },
                    );
                  }).toList(),
                )
              : const Center(child: Text('No employees found.')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog on cancel
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
