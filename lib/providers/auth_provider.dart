import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:yellow_nav/models/user.dart';
import 'package:yellow_nav/services/firebase_services.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  AuthenticationProvider(this._firebaseService);

  // Getters
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Initialize auth state
  Future<void> initialize() async {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          name: firebaseUser.displayName,
        );
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Email/Password Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _firebaseService.signIn(email, password);
      _user = user;
      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Login failed";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Email/Password Signup
  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    try {
      final user = await _firebaseService.signUp(name, email, password);
      _user = user;
      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Signup failed";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //Google Sign-In
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final user = await _firebaseService.signInWithGoogle();
      _user = user;
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Google sign-in failed";
    } finally {
      _setLoading(false);
    }
  }



  // Sign Out
  Future<void> signOut() async {
    await _firebaseService.signOut();
    _user = null;
    notifyListeners();
  }

  // Helper method
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
