import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/blocs/ticket_bloc/ticket_bloc_bloc.dart';

class TicketList extends StatelessWidget {
  const TicketList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBlocBloc, TicketBlocState>(
      builder: (context, state) {
        if (state is TicketsLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is TicketsLoadedState) {
          final tickets = state.tickets;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return ListTile(
                title: Text(ticket.title),
                subtitle: Text(ticket.status),
              );
            },
          );
        }
        return const Text('No tickets found.');
      },
    );
  }
}
