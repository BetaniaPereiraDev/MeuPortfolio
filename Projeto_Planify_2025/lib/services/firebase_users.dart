import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsers {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<void> updateProfile(String userId, String name, String bio) async {
    await _firestore.collection('users').doc(userId).update({
      'name': name,
      'bio': bio,
    });
  }

  
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }
}
