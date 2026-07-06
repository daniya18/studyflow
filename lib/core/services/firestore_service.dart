import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc =
        _firestore.collection('users').doc(user.uid);

    final snapshot = await doc.get();

    if (snapshot.exists) return;

    await doc.set({
      'name': user.displayName ??
          user.email?.split('@').first ??
          'Student',
      'email': user.email ?? '',
      'progress': 0,
      'streak': 0,
      'achievements': 0,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }
  static Future<UserModel?> getCurrentUserProfile() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return null;

  final snapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

  if (!snapshot.exists) return null;

  return UserModel.fromMap(snapshot.data()!);
}
}