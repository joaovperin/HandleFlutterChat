import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handle_flutter_chat/core/users/user.model.dart';

class UserService {
  ///
  /// Get logged user data
  ///
  static Future<UserModel> getLoggedUserData({Function userNotLogged}) async {
    final completer = Completer<UserModel>();
    try {
      var currentUser = await FirebaseAuth.instance.currentUser();
      if (currentUser == null)
        userNotLogged();
      else {
        completer.complete(await getUserDataByUid(currentUser.uid));
      }
    } catch (err) {
      completer.completeError(err);
    }
    return completer.future;
  }

  ///
  /// Login on firebase
  ///
  static Future<UserModel> login({String email, String password}) async {
    final completer = Completer<UserModel>();
    try {
      var currentUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      completer.complete(await getUserDataByUid(currentUser.user.uid));
    } catch (err) {
      completer.completeError(err);
    }
    return completer.future;
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  ///
  /// Get user data using it's uid
  ///
  static Future<UserModel> getUserDataByUid(String uid) async {
    return UserModel.fromSnapshot(
        await Firestore.instance.collection("users").document(uid).get());
  }
}
