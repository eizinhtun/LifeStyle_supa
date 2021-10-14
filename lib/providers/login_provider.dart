// @dart=2.9
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier, DiagnosticableTreeMixin {
  LoginProvider() {}

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
}
