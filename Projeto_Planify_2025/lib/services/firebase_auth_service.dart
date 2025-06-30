import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      
      await userCredential.user?.updateDisplayName(name);

    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'profileComplete': false,
      
    });

      return userCredential.user;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return null;
    }
  }

  
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  
  Future<void> logout() async {
    await _auth.signOut();
  }

  
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}
