import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel> registerAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final cleanEmail = email.trim();

    if (cleanUsername.isEmpty || cleanUsername.length > 50) {
      throw Exception('Username must be between 1 and 50 characters.');
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Failed to create account in Firebase Authentication.');
    }

    final newUser = UserModel(
      uid: user.uid,
      username: cleanUsername,
      email: cleanEmail,
      isPremium: false,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toCreateMap());

    return newUser;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserModel?> getUserProfile([String? uid]) async {
    final targetUid = uid ?? _auth.currentUser?.uid;
    if (targetUid == null) return null;

    final doc = await _firestore.collection('users').doc(targetUid).get();
    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromFirestore(doc);
  }

  Stream<UserModel?> streamUserProfile([String? uid]) {
    final targetUid = uid ?? _auth.currentUser?.uid;
    if (targetUid == null) return Stream.value(null);

    return _firestore.collection('users').doc(targetUid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  Future<void> updateUsername(String newUsername) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found.');

    final cleanUsername = newUsername.trim();
    if (cleanUsername.isEmpty || cleanUsername.length > 50) {
      throw Exception('Username must be between 1 and 50 characters.');
    }

    final docRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    final data = snapshot.data();

    if (data == null) throw Exception('User profile does not exist.');

    await docRef.update({
      'uid': data['uid'],
      'email': data['email'],
      'username': cleanUsername,
      'isPremium': data['isPremium'],
      'createdAt': data['createdAt'],
    });
  }
}