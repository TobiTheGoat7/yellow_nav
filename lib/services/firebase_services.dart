import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yellow_nav/models/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Auth
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        // Convert Firebase User to UserModel
        return UserModel.fromFirebaseUser(result.user!);
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Update display name
        await result.user!.updateDisplayName(name);

        // Create user document in Firestore
        final userModel = UserModel.fromFirebaseUser(result.user!);
        await _firestore
            .collection('users')
            .doc(userModel.id)
            .set(userModel.toFirestore());

        return userModel;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      // 1. Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // 2. Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // 5. Create/update user in Firestore
      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        await _firestore
            .collection('users')
            .doc(userModel.id)
            .set(
              userModel.toFirestore(),
              SetOptions(merge: true), // Merge if user exists
            );
        return userModel;
      }
      return null;
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }
Future<void> signOut() async {
  try {
    await _auth.signOut();
    await _googleSignIn.signOut(); // If using Google Sign-In
    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
    throw Exception('Failed to sign out');
  }
}
  // Firestore
  Future<void> savePlace(Map<String, dynamic> placeData) async {
    await _firestore.collection('saved_places').add(placeData);
  }

  Stream<QuerySnapshot> getSavedPlaces() {
    return _firestore.collection('saved_places').snapshots();
  }
}
