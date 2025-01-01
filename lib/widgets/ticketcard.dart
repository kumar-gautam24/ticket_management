import 'package:flutter/material.dart';

import '../models/ticket_model.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final ValueChanged<String?>? onAssign;
  final ValueChanged<String?>? onUpdateStatus;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onAssign,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(ticket.title),
        trailing: onAssign != null
            ? DropdownButton<String>(
                onChanged: onAssign,
                items: ['employee1', 'employee2'].map((employeeId) {
                  return DropdownMenuItem(
                    value: employeeId,
                    child: Text(employeeId),
                  );
                }).toList(),
              )
            : DropdownButton<String>(
                onChanged: onUpdateStatus,
                items: ['resolved', 'in_progress', 'closed'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
