import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/models/user_model.dart';
import 'package:ticket_management/repos/user_repo.dart';
import 'package:ticket_management/screens/add_userscreen.dart';
import '../blocs/ticket_bloc/ticket_bloc_bloc.dart';
import '../services/auth_services.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  final UserModel user;
  const AdminScreen({super.key, required this.user});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicketBlocBloc>(context).add(FetchTicketsEvent());
  }

  void _deleteTicket(String ticketId) {
    BlocProvider.of<TicketBlocBloc>(context)
        .add(DeleteTicketEvent(ticketId: ticketId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin ${widget.user.name}'),
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
          BlocProvider.of<TicketBlocBloc>(context).add(FetchTicketsEvent());
        },
        child: BlocBuilder<TicketBlocBloc, TicketBlocState>(
          builder: (context, state) {
            if (state is TicketsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketsLoadedState) {
              var tickets = state.tickets;
              return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return Dismissible(
                    key: Key(ticket.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      final removedTicket = tickets[index];
                      setState(() {
                        tickets.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${ticket.title} deleted'),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              setState(() {
                                tickets.insert(index, removedTicket);
                              });
                            },
                          ),
                          duration: Duration(seconds: 5),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 5), () {
                        if (!tickets.contains(removedTicket)) {
                          _deleteTicket(
                              ticket.id); // Delete only if not restored
                        }
                      });
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
    final List<UserModel> employees =
        await UserRepo().getUserByRole("employee");
    // Displaying employee IDs in the dialog
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Assign Ticket'),
          content: employees.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: employees.map((employee) {
                    return ListTile(
                      title: Text(employee.name),
                      onTap: () {
                        BlocProvider.of<TicketBlocBloc>(context).add(
                          UpdateTicketEvent(ticketId, 'Assigned', employee.id),
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
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
