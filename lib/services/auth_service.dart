import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
