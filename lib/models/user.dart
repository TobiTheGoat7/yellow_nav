import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.createdAt,
  });

  // Convert Firestore Document to UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  // Convert UserModel to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Convert Firebase User to UserModel
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
  }
}