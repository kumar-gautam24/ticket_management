part of 'ticket_bloc_bloc.dart';

@immutable
sealed class TicketBlocState {}

final class TicketBlocInitial extends TicketBlocState {}

final class TicketBlocAction extends TicketBlocState {
  final String message;
  TicketBlocAction({required this.message});
}

final class TicketsLoadingState extends TicketBlocState {}

final class TicketsLoadedState extends TicketBlocState {
  final List<TicketModel> tickets;
  TicketsLoadedState(this.tickets);
}

final class TicketErrorState extends TicketBlocState {
  final String message;

  TicketErrorState(this.message);
}
