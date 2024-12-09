import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_management/models/usermodel.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 

  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot['role'] ?? 'user';
      } else {
        throw 'User not found';
      }
    } catch (e) {
      rethrow;
    }
  }

  getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }
   Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
  Future<List<UserModel>> getUserByRole(String role) async {
    try {
      final snapshot = await _firestore
          .collection('users') // Assuming users collection contains user roles
          .where('role', isEqualTo: role) // Filter by role
          .get();
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }
}
