import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc_bloc.dart';
import '../blocs/ticket_bloc/ticket_bloc_bloc.dart';
import '../models/user_model.dart';
import 'add_ticket.dart';

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
    print("called delete ticket");
    BlocProvider.of<TicketBlocBloc>(context)
        .add(DeleteTicketEvent(ticketId: ticketId, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User ${widget.user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                // await FirebaseAuthService().logout();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (_) => const LoginScreen()),
                // );
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
              if (kDebugMode) {
                print("loded state in user ui");
              }
              var tickets = state.tickets;
              return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  if (kDebugMode) {
                    print("here in ticket builder");
                  }
                  return Dismissible(
                    key: Key(ticket.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      final removedTicket = tickets[index];
                      setState(() {
                        tickets.removeAt(index);
                        print("ticket removed");
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${ticket.title} deleted'),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              setState(() {
                                tickets.insert(index, removedTicket);
                                print("ticket restored");
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
                        else{
                          print("ticket not deleted");
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
