// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/validators/validator.dart';

class LoginProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
    DatabaseHelper.setAppLoggedIn(context, false);
    notifyListeners();
  }

  Future<void> login(BuildContext context, String vId, String vCode) async {
    // if (FirebaseAuth.instance.currentUser?.uid == null) {
    //   DatabaseHelper.setAppLoggedIn(context, true);
    //   notifyListeners();
    //   return true;
    // }
    // notifyListeners();
    // return false;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      print("After: $vId");
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vId,
        smsCode: vCode,
      );
      await _auth.signInWithCredential(credential).then((value) {
        User user = value.user;
        print("Successfully signed in UID: ${user.uid}");
        MessageHandler.showSnackbar(
            "Successfully signed in UID: ${user.uid}", context, 5);
        if (user.uid != null) {
          DatabaseHelper.setAppLoggedIn(context, true);
          notifyListeners();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        }
      });
    } catch (e) {
      print(e.toString());
      MessageHandler.showSnackbar(
          "Failed to sign in: " + e.toString(), context, 5);
    }
  }

  Future<void> fbLogin(BuildContext context) async {
    User user = await Authentication.signInWithFacebook(context: context);

    if (user.uid != null) {
      DatabaseHelper.setAppLoggedIn(context, true);
      notifyListeners();
      bool userIdExist = await Validator.checkUserIdIsExist(user.uid);
      print("UserIdExist : $userIdExist");
      if (!userIdExist) {
        userRef.doc(user.uid).set({
          "uid": user.uid,
          "full_name": user.displayName,
          "email": user.email,
          "phone": user.phoneNumber,
          "photo": user.photoURL
        })
            // .then((value) => print("User Added $value"))
            .catchError((error) => print("Failed to add user: $error"));
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  Future<void> googleLogin(BuildContext context) async {
    User user = await Authentication.signInWithGoogle(context: context);
    if (user.uid != null) {
      DatabaseHelper.setAppLoggedIn(context, true);
      notifyListeners();
      bool userIdExist = await Validator.checkUserIdIsExist(user.uid);
      print("UserIdExist : $userIdExist");
      if (!userIdExist) {
        userRef.doc(user.uid).set({
          "uid": user.uid,
          "full_name": user.displayName,
          "email": user.email,
          "phone": user.phoneNumber,
          "photo": user.photoURL
        })
            // .then((value) => print("User Added $value"))
            .catchError((error) => print("Failed to add user: $error"));
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }
}
