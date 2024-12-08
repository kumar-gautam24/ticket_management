part of 'ticket_bloc_bloc.dart';

@immutable
sealed class TicketBlocEvent {}

class FetchTicketsEvent extends TicketBlocEvent {
  final String? userId;
  FetchTicketsEvent({this.userId});
}
class DeleteTicketEvent extends TicketBlocEvent {
  final String ticketId;

  DeleteTicketEvent({required this.ticketId});
}
class AddTicketEvent extends TicketBlocEvent {
  final TicketModel ticket;
  AddTicketEvent(this.ticket);
}

class UpdateTicketEvent extends TicketBlocEvent {
  final String ticketId;
  final String newStatus;
  final String? employeeId;

  UpdateTicketEvent(this.ticketId, this.newStatus, this.employeeId);
}
