import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/ticketModel.dart';
import '../../repos/ticket_repo.dart';

part 'ticket_bloc_event.dart';
part 'ticket_bloc_state.dart';

class TicketBlocBloc extends Bloc<TicketBlocEvent, TicketBlocState> {
  final TicketRepository ticketRepository;
  TicketBlocBloc(this.ticketRepository) : super(TicketBlocInitial()) {
    on<TicketBlocEvent>((event, emit) {});
    // create ticket
    on<AddTicketEvent>((event, emit) async {
      try {
        await ticketRepository.addTicket(event.ticket);
        emit(TicketBlocAction(message: "Ticket Added Success"));
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });

    // fetch ticket
    on<FetchTicketsEvent>((event, emit) async {
      emit(TicketsLoadingState());
      try {
        print("Fetching tickets for user: ${event.userId}");
        var ticketStream = ticketRepository.getTickets(event.userId);

        await emit.forEach<List<TicketModel>>(
          ticketStream,
          onData: (tickets) {
            print("Tickets received: $tickets");
            return TicketsLoadedState(
                tickets); // Emit the loaded state with tickets
          },
          onError: (error, stackTrace) {
            print("Error occurred while fetching tickets: $error");
            return TicketErrorState(
                error.toString()); // Handle the error properly
          },
        );
      } catch (e) {
        print("Error in fetching tickets: $e");
        emit(TicketErrorState(e.toString()));
      }
    });

    // update ticket
    on<UpdateTicketEvent>((event, emit) {
      try {
        ticketRepository.updateTickets(
            event.ticketId, event.newStatus, event.employeeId);
        emit(TicketsLoadingState());
        emit(TicketBlocAction(message: "Updated Successfully"));
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });
    // delete
    on<DeleteTicketEvent>((event, emit) async {
      try {
        await ticketRepository.deleteTicket(event.ticketId);
        emit(TicketBlocAction(message: "Ticket Deleted"));
        add(FetchTicketsEvent());
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });
  }
}
