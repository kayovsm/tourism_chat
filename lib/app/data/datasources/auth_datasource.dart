// lib/app/data/datasources/auth_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel?> login(String email, String password);

  Future<UserModel?> register(String email, String password);

  Future<void> logout();

  UserModel? getCurrentUser();
}

class FirebaseAuthDataSource implements AuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = UserModel.fromFirebaseUser(userCredential.user!);

        await _firestore.collection('users').doc(user.id).set({
          // 'id': user.id,
          'email': user.email,
          'name': user.displayName ?? email.split('@')[0],
          // 'photoUrl': user.photoUrl,
          'createdAt': Timestamp.now(),
        });

        return user;
      }
      return null;
    } catch (e) {
      print('Erro no registro: $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }
}
