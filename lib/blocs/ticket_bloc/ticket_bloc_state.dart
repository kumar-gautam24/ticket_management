part of 'ticket_bloc_bloc.dart';

abstract class TicketBlocState {}

class TicketBlocInitial extends TicketBlocState {}

class TicketsLoadingState extends TicketBlocState {}

class TicketsLoadedState extends TicketBlocState {
  final List<TicketModel> tickets;
  TicketsLoadedState(this.tickets);
}

class TicketBlocAction extends TicketBlocState {
  final String message;
  TicketBlocAction({required this.message});
}

class TicketErrorState extends TicketBlocState {
  final String errorMessage;
  TicketErrorState(this.errorMessage);
}

class TicketDeletedState extends TicketBlocState {
  final TicketModel ticket;
  TicketDeletedState(this.ticket);
}
