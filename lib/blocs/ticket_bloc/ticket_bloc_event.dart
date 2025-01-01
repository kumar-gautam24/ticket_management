part of 'ticket_bloc_bloc.dart';

abstract class TicketBlocEvent {}

class AddTicketEvent extends TicketBlocEvent {
  final TicketModel ticket;
  AddTicketEvent(this.ticket);
}

class FetchTicketsEvent extends TicketBlocEvent {
  final String userId;
  FetchTicketsEvent({required this.userId});
}

class UpdateTicketEvent extends TicketBlocEvent {
  final String ticketId;
  final String newStatus;
  final String employeeId;
  UpdateTicketEvent(
      {required this.ticketId,
      required this.newStatus,
      required this.employeeId});
}

class DeleteTicketEvent extends TicketBlocEvent {
  final String ticketId;
  final String userId;
  DeleteTicketEvent({required this.ticketId, required this.userId});
}

class RestoreTicketEvent extends TicketBlocEvent {
  final TicketModel ticket;
  final String userId;
  RestoreTicketEvent({required this.ticket, required this.userId});
}
