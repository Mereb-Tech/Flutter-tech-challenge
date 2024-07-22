// lib/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService(this._firebaseAuth, this._firestore);

  TaskEither<String, User> registerWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) {
    return TaskEither.tryCatch(
      () async {
        final UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user!;

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // await _firestore.collection('chats').doc(user.uid).set({
        //   'users': [user.uid],
        //   'createdAt': FieldValue.serverTimestamp(),
        // });

        return user;
      },
      (error, _) => error.toString(),
    );
  }

  TaskEither<String, User> loginWithEmailPassword(
    String email,
    String password,
  ) {
    return TaskEither.tryCatch(
      () async {
        final UserCredential userCredential = await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);
        return userCredential.user!;
      },
      (error, _) => error.toString(),
    );
  }

  TaskEither<String, void> signOut() {
    return TaskEither.tryCatch(
      () async {
        await Future.wait([
          _firebaseAuth.signOut(),
        ]);
        return;
      },
      (error, _) => error.toString(),
    );
  }
}
