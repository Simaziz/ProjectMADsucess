// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  bool isLoading = true;

  // Initialize auth state listener
  Future<void> init() async {
    _auth.authStateChanges().listen((User? firebaseUser) {
      print('Auth state changed: $firebaseUser');
      user = firebaseUser;
      isLoading = false;
      notifyListeners();
    });
  }

  // Register
  Future<bool> register(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = cred.user;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = cred.user;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}
