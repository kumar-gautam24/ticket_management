import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ticketModel.dart';
import '../services/firestore_service.dart';

class TicketRepository {
  final FirestoreService _firestoreService = FirestoreService();

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
  Future<List<String>> getEmployeeIdsByRole(String role) async {
    try {
      final snapshot = await _firestore
          .collection('users') // Assuming users collection contains user roles
          .where('role', isEqualTo: role) // Filter by role
          .get();
     return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }
}
