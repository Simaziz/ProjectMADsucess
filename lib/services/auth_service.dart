import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new user with email & password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Forward Firebase errors to the caller
      throw e;
    }
  }

  // Login with email & password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Listen to auth state changes
  Stream<User?> get userChanges => _auth.userChanges();

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
