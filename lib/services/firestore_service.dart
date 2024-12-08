import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticketModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTicket(TicketModel ticket) async {
    await _firestore.collection('tickets').add(ticket.toFirestore());
  }

  Stream<List<TicketModel>> getTickets(String? userId,) {
    // print("user id in fetch service $userId");
    if (userId != null) {
      return _firestore
          .collection('tickets')
          .where('createdBy', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return TicketModel.fromFirestore(doc.data(), doc.id);
        }).toList();
      });
    } else {
      return _firestore.collection('tickets').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return TicketModel.fromFirestore(doc.data(), doc.id);
        }).toList();
      });
    }
  }

  Future<void> updateTicketStatus(
      String ticketId, String newStatus, String? employee) async {
    if (employee != null) {
      await _firestore.collection('tickets').doc(ticketId).update({
        'status': newStatus,
        'assignedTo': employee,
      });
    }
  }
}
