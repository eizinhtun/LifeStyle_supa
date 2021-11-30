// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/intro_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/utils/message_handler.dart';

class LoginProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var userRef = FirebaseFirestore.instance.collection(userCollection);
  var introRef = FirebaseFirestore.instance.collection(introCollection);

  Future<UserModel> getUser(BuildContext context) async {
    UserModel userModel = UserModel();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      await userRef
          .doc(uid)
          .get(GetOptions(source: Source.server))
          .then((value) {
        userModel = UserModel.fromJson(value.data());

        notifyListeners();
        return userModel;
      });
    }
    notifyListeners();
    return userModel;
  }

  Future<UserModel> getUserScanData(BuildContext context, uid) async {
    UserModel userModel = UserModel();
    if (uid != null) {
      uid = uid.toString();
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
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vId,
        smsCode: vCode,
      );
      await _auth.signInWithCredential(credential).then((value) {
        User user = value.user;

        MessageHandler.showSnackbar(
            "${Tran.of(context).text("success_sigin_uid")}: ${user.uid}",
            context,
            5);
        if (user.uid != null) {
          DatabaseHelper.setAppLoggedIn(context, true);
          notifyListeners();
        } else {}
      });
    } catch (e) {
      MessageHandler.showSnackbar(
          "${Tran.of(context).text("fail_sigin")}: " + e.toString(),
          context,
          5);
    }
  }

  Future<void> fbLogin(BuildContext context, String fcmtoken) async {
    User user = await Authentication.signInWithFacebook(context: context);

    if (user != null && user.uid != null) {
      DatabaseHelper.setAppLoggedIn(context, true);
      notifyListeners();
      // bool userIdExist = await Validator.checkUserIdIsExist(user.uid);
      //
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
      //       .catchError((error) =>
      // }

    } else {}
    notifyListeners();
  }

  Future<void> googleLogin(BuildContext context, String fcmtoken) async {
    User user = await Authentication.signInWithGoogle(context: context);
    if (user != null && user?.uid != null) {
      DatabaseHelper.setAppLoggedIn(context, true);
      // FirebaseAuth.instance.currentUser.
      notifyListeners();
      // bool userIdExist = await Validator.checkUserIdIsExist(user.uid);
      //
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
      //       .catchError((error) =>
      // }
    } else {}
  }

  Future<bool> register(BuildContext context, String vId, String vCode,
      UserModel userModel) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vId,
        smsCode: vCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      MessageHandler.showSnackbar(
          "${Tran.of(context).text("success_sigin_uid")}: ${user.uid}",
          context,
          5);

      if (user.uid != null) {
        DatabaseHelper.setAppLoggedIn(context, true);
        userModel.uid = user.uid;

        // userRef
        //     .doc(user.uid)
        //     .set(userModel.toJson())
        //     .catchError((error) =>
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      MessageHandler.showErrSnackbar(
          "${Tran.of(context).text("fail_sigin")}" + e.toString(), context, 5);
      return false;
    }
  }

  Future<void> addUserProfile(BuildContext context, UserModel userModel) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      try {
        userRef.doc(uid).set(userModel.toJson()).then((value) {
          MessageHandler.showMessage(context, Tran.of(context).text("success"),
              Tran.of(context).text("update_user_success"));
        });

        notifyListeners();
      } catch (e) {
        MessageHandler.showErrMessage(context, Tran.of(context).text("fail"),
            Tran.of(context).text("update_user_fail"));
      }
    }
    notifyListeners();
  }

  Future<void> updateUserInfo(BuildContext context, UserModel user) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      try {
        userRef.doc(uid).set(user.toJson())
            // update({
            //   'full_name': user.fullName,
            //   'email': user.email,
            //   'phone': user.phone,
            //   'photoUrl': user.photoUrl,
            //   'uid': user.uid,
            //   'balance': user.balance,
            //   'fcmtoken': user.fcmtoken,
            //   'password': user.password,
            //   'isActive': user.isActive,
            //   'createdDate': user.createdDate,
            //   'address': user.address,
            //   'showBalance': user.showBalance
            // })

            .then((value) {
          MessageHandler.showMessage(context, Tran.of(context).text("success"),
              Tran.of(context).text("update_user_success"));
        });

        notifyListeners();
      } catch (e) {
        MessageHandler.showErrMessage(context, Tran.of(context).text("fail"),
            Tran.of(context).text("update_user_fail"));
      }
    }
    notifyListeners();
  }

  Future<bool> updateFCMtoken(BuildContext context, String fcmtoken) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      try {
        userRef.doc(uid).update({"fcmToken": fcmtoken}).then((_) {
          MessageHandler.showMessage(context, Tran.of(context).text("success"),
              Tran.of(context).text("update_token_success"));
          return true;
        });

        notifyListeners();
      } catch (e) {
        MessageHandler.showErrMessage(
          context,
          Tran.of(context).text("fail"),
          Tran.of(context).text("update_token_fail"),
        );
      }
    }

    notifyListeners();
    return false;
  }

  Future<List<IntroModel>> getIntroList(BuildContext context) async {
    List<IntroModel> list = [];

    await introRef.get().then((value) {
      value.docs.forEach((result) {
        if (result.data()['isActive']) {
          list.add(IntroModel.fromJson(result.data()));
        }
      });
    });

    notifyListeners();
    return list;
  }
}
