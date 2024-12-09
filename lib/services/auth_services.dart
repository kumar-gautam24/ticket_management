import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_management/models/usermodel.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// login user here 
  Future<UserModel?> login(String email, String password) async {
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
  }
// register account here 
  Future<UserModel?> register(
      String email, String password, String role,String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userId = userCredential.user!.uid;
    print("register success in firebase");

    await _firestore.collection('users').doc(userId).set({
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("data add sucess in firebase");

    final userDoc = await _firestore.collection('users').doc(userId).get();
    return UserModel.fromFirestore(userDoc.data()!, userId);
  }

 

  Future<void> logout() async => await _auth.signOut();
}
