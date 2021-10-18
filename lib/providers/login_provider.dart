// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/validators/validator.dart';

class LoginProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  Future<UserModel> getUser(BuildContext context) async {
    UserModel userModel = UserModel();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      await userRef.doc(uid).get().then((value) {
        userModel = UserModel.fromJson(value.data());
        notifyListeners();
        return userModel;
      });
    }
    notifyListeners();
    return userModel;
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
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
      print("Provider After: $vId");
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
        } else {}
      });
    } catch (e) {
      print(e.toString());
      MessageHandler.showSnackbar(
          "Failed to sign in: " + e.toString(), context, 5);
    }
  }

  Future<void> fbLogin(BuildContext context, String fcmtoken) async {
    User user = await Authentication.signInWithFacebook(context: context);

    if (user.uid != null) {
      DatabaseHelper.setAppLoggedIn(context, true);
      notifyListeners();
      // bool userIdExist = await Validator.checkUserIdIsExist(user.uid);
      // print("UserIdExist : $userIdExist");
      // if (!userIdExist) {
      //   UserModel userModel = UserModel(
      //       uid: user.uid,
      //       fullName: user.displayName,
      //       email: user.email,
      //       phone: user.phoneNumber,
      //       photoUrl: user.photoURL,
      //       fcmtoken: fcmtoken,
      //       balance: 0.0,
      //       createdDate: DateTime.now());
      //   userRef
      //       .doc(user.uid)
      //       .set(userModel.toJson()
      //           //   {
      //           //   "uid": user.uid,
      //           //   "full_name": user.displayName,
      //           //   "email": user.email,
      //           //   "phone": user.phoneNumber,
      //           //   "photo": user.photoURL
      //           // }
      //           )
      //       // .then((value) => print("User Added $value"))
      //       .catchError((error) => print("Failed to add user: $error"));
      // }

    } else {}
  }

  Future<void> googleLogin(BuildContext context, String fcmtoken) async {
    User user = await Authentication.signInWithGoogle(context: context);
    if (user.uid != null) {
      DatabaseHelper.setAppLoggedIn(context, true);
      notifyListeners();
      // bool userIdExist = await Validator.checkUserIdIsExist(user.uid);
      // print("UserIdExist : $userIdExist");
      // if (!userIdExist) {
      //   UserModel userModel = UserModel(
      //       uid: user.uid,
      //       fullName: user.displayName,
      //       email: user.email,
      //       phone: user.phoneNumber,
      //       photoUrl: user.photoURL,
      //       fcmtoken: fcmtoken,
      //       balance: 0.0,
      //       createdDate: DateTime.now());
      //   userRef
      //       .doc(user.uid)
      //       .set(userModel.toJson()
      //           //   {
      //           //   "uid": user.uid,
      //           //   "full_name": user.displayName,
      //           //   "email": user.email,
      //           //   "phone": user.phoneNumber,
      //           //   "photo": user.photoURL,
      //           // }

      //           )
      //       // .then((value) => print("User Added $value"))
      //       .catchError((error) => print("Failed to add user: $error"));
      // }
    } else {}
  }

  Future<bool> register(BuildContext context, String vId, String vCode,
      UserModel userModel) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      print("After: $vId");
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vId,
        smsCode: vCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("Successfully signed in UID: ${user.uid}");
      MessageHandler.showSnackbar(
          "Successfully signed in UID: ${user.uid}", context, 5);

      if (user.uid != null) {
        DatabaseHelper.setAppLoggedIn(context, true);
        userModel.uid = user.uid;

        print("UserModel: $userModel");
        userRef
            .doc(user.uid)
            .set(userModel.toJson())
            .catchError((error) => print("Failed to add user: $error"));
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      print(e.toString());
      MessageHandler.showErrSnackbar(
          "Failed to sign in: " + e.toString(), context, 5);
      return false;
    }
  }

  Future<void> updateUserInfo(BuildContext context, UserModel userModel) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      try {
        userRef.doc(uid).set(userModel.toJson()).then((_) {
          print("add user profile success!");
          MessageHandler.showMessage(
              context, "Success", "Adding user profile is successful");
        });

        notifyListeners();
      } catch (e) {
        print("Failed to add user profile: $e");
        MessageHandler.showErrMessage(
            context, "Fail", "Adding User Profile is fail");
      }
    }
    notifyListeners();
  }

  Future<void> addUserProfile(BuildContext context, UserModel userModel) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      try {
        userRef.doc(uid).set(userModel.toJson()).then((_) {
          print("update user success!");
          MessageHandler.showMessage(
              context, "Success", "Updating User Info is successful");
        });

        notifyListeners();
      } catch (e) {
        print("Failed to update user: $e");
        MessageHandler.showErrMessage(
            context, "Fail", "Updating User Info is fail");
      }
    }
    notifyListeners();
  }

  Future<bool> updateFCMtoken(BuildContext context, String fcmtoken) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      try {
        userRef.doc(uid).update({"fcmToken": fcmtoken}).then((_) {
          print("update token success!");
          MessageHandler.showMessage(
              context, "Success", "Updating token is successful");
        });

        notifyListeners();
      } catch (e) {
        print("Failed to update token: $e");
        MessageHandler.showErrMessage(
            context, "Fail", "Updating token is fail");
      }
    }
    notifyListeners();
  }
}
