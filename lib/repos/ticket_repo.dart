import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';

class TicketRepository {
  final TicketService _firestoreService = TicketService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTicket(TicketModel ticket) =>
      _firestoreService.addTicket(ticket);

  Stream<List<TicketModel>> getTickets(String? userId) =>
      _firestoreService.getTickets(userId);

  Future<void> updateTickets(
          String ticketId, String newStatus, String? employeeId) =>
      _firestoreService.updateTicketStatus(ticketId, newStatus, employeeId);

  Future<void> deleteTicket(String ticketId) async {
    await _firestore.collection('tickets').doc(ticketId).delete();
  }

  // New method to get a ticket by its ID
  Future<TicketModel?> getTicketById(String ticketId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('tickets').doc(ticketId).get();

      if (doc.exists) {
        return TicketModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null; // Ticket not found
      }
    } catch (e) {
      print('Error fetching ticket by ID: $e');
      return null; // In case of any error
    }
  }
}
