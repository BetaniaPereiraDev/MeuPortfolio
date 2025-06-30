import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePermissions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> canUserEdit(String projectId, String userId) async {
    DocumentSnapshot doc = await _firestore
        .collection('permissions')
        .doc('${projectId}_$userId')
        .get();
    return doc.exists && doc['canEdit'] == true;
  }
}
