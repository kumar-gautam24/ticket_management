import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../models/ticket_model.dart';
import '../../repos/ticket_repo.dart';

part 'ticket_bloc_event.dart';
part 'ticket_bloc_state.dart';

class TicketBlocBloc extends Bloc<TicketBlocEvent, TicketBlocState> {
  final TicketRepository ticketRepository;
  TicketBlocBloc(this.ticketRepository) : super(TicketBlocInitial()) {
    on<TicketBlocEvent>((event, emit) {});

    // Create ticket
    on<AddTicketEvent>((event, emit) async {
      try {
        await ticketRepository.addTicket(event.ticket);
        emit(TicketBlocAction(message: "Ticket Added Success"));
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });

    // Fetch tickets
    on<FetchTicketsEvent>((event, emit) async {
      emit(TicketsLoadingState());
      try {
        print("Fetching tickets for user: ${event.userId}");
        var ticketStream = ticketRepository.getTickets(event.userId);

        await emit.forEach<List<TicketModel>>(
          ticketStream,
          onData: (tickets) {
            if (kDebugMode) {
              print("Tickets received: $tickets");
            }
            return TicketsLoadedState(
                tickets); // Emit the loaded state with tickets
          },
          onError: (error, stackTrace) {
            if (kDebugMode) {
              print("Error occurred while fetching tickets: $error");
            }
            return TicketErrorState(
                error.toString()); // Handle the error properly
          },
        );
      } catch (e) {
        if (kDebugMode) {
          print("Error in fetching tickets: $e");
        }
        emit(TicketErrorState(e.toString()));
      }
    });

    // Update ticket
    on<UpdateTicketEvent>((event, emit) async {
      try {
        await ticketRepository.updateTickets(
            event.ticketId, event.newStatus, event.employeeId);
        emit(TicketsLoadingState());
        emit(TicketBlocAction(message: "Updated Successfully"));
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });

    // Delete ticket
    on<DeleteTicketEvent>((event, emit) async {
      try {
        // Get the ticket data before deleting, to allow restoration
        var ticket = await ticketRepository.getTicketById(event.ticketId);

        if (ticket != null) {
          // Delete the ticket
          await ticketRepository.deleteTicket(event.ticketId);
          emit(TicketBlocAction(message: "Ticket Deleted"));

          // Trigger a state to handle restoration (if needed)
          emit(TicketDeletedState(
              ticket)); // Store the deleted ticket for restoration

          add(FetchTicketsEvent(userId: event.userId));
        } else {
          emit(TicketErrorState("Ticket not found"));
        }
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });

  }
}
