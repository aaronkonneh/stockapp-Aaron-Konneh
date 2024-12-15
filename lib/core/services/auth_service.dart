import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _createUserProfile(
        uid: userCredential.user!.uid,
        email: email,
        fullName: fullName,
      );

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> _createUserProfile({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'fullName': fullName,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'Email is already in use.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password is too weak.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return 'An error occurred. Please try again.';
  }
}
