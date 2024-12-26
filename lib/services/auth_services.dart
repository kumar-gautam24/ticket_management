import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_management/models/usermodel.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthService() {
    //  persistence to local for web
    _auth.setPersistence(Persistence.LOCAL);
  }

  // login user
  Future<UserModel?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user!.uid;
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc.data()!, userId);
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // register account
  Future<UserModel?> register(
      String email, String password, String role, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user!.uid;
      print("register success in firebase");

      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'role': role,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("data add success in firebase");

      final userDoc = await _firestore.collection('users').doc(userId).get();
      return UserModel.fromFirestore(userDoc.data()!, userId);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // auth state
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // update user profile
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // delete user account
  Future<void> deleteUserAccount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      await _auth.currentUser!.delete();
    } catch (e) {
      throw Exception('Failed to delete user account: $e');
    }
  }
}
