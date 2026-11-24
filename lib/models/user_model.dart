import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final bool isPremium;
  final DateTime? createdAt;

  UserModel({

    required this.uid,
    required this.username,
    required this.email,
    required this.isPremium,
    this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      isPremium: data['isPremium'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'isPremium': false,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
