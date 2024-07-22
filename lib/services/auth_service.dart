import 'package:chat/interfaces/iauth.interface.dart';
import 'package:chat/models/ResponseData.dart';
import 'package:chat/models/UserAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollectionPath = "users";

  Future<UserAccount?> _userFromFirebaseUser(User? user) async {
    if (user != null) {
      var docSnapshot =
          await _firestore.collection(_usersCollectionPath).doc(user.uid).get();
      if (docSnapshot.exists) {
        dynamic data = docSnapshot.data();
        UserAccount account = UserAccount.fromJson(data);
        //sync lastupdated at
        _firestore
            .collection(_usersCollectionPath)
            .doc(user.uid)
            .update(account.toJson());

        return account;
      }
    }
    return null;
  }

  // Auth change user stream
  @override
  Stream<UserAccount?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  @override
  Future<ResponseData<UserAccount?>> createAccount(
      UserAccount account, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: account.email, password: password);
      User? user = result.user;

      if (user != null) {
        //Set to firestore collections
        _firestore
            .collection(_usersCollectionPath)
            .doc(user.uid)
            .set(account.toJson());
        return ResponseData<UserAccount?>(isSuccessful: true);
      } else {
        return ResponseData<UserAccount?>(
            isSuccessful: false,
            errorMessages: ["Unable to register user account"]);
      }
    } catch (e) {
      print(e);
      return ResponseData<UserAccount?>(
          isSuccessful: false, errorMessages: [e.toString()]);
    }
  }

  @override
  Future forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<ResponseData<UserAccount?>> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return ResponseData<UserAccount?>(isSuccessful: true);
    } catch (e) {
      return ResponseData<UserAccount?>(
          isSuccessful: false,
          errorMessages: ["Invalid credential, please try again."]);
    }
  }

  @override
  Future<ResponseData<UserAccount?>> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<ResponseData<UserAccount?>> loginWithGithub() {
    // TODO: implement loginWithGithub
    throw UnimplementedError();
  }

  @override
  Future<ResponseData<UserAccount?>> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<ResponseData<UserAccount?>> updateAccount(UserAccount? account) async {
    try {
      if (_auth.currentUser != null) {
        //
        await _firestore
            .collection(_usersCollectionPath)
            .doc(_auth.currentUser!.uid)
            .update(account!.toJson());
        return ResponseData(isSuccessful: true, data: account);
      }
    } catch (e) {
      //
    }
    return ResponseData(isSuccessful: false);
  }

  @override
  Future<ResponseData> logOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      return ResponseData(
          isSuccessful: false, errorMessages: ["Couldn't able to sign out"]);
    }
    return ResponseData(isSuccessful: true);
  }
}
