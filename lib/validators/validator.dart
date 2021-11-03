// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/Translate.dart';

class Validator {
  static String showPhoneToken(bool isToken) {
    if (isToken) {
      return "This Phone is already registered";
    }
    return null;
  }

  static Future<bool> checkUserIsExist(String phoneNumber) async {
    var userRef = FirebaseFirestore.instance.collection(userCollection);
    QuerySnapshot snaptData =
        await userRef.where('phone', isEqualTo: phoneNumber).get();
    if (snaptData.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkUserIdIsExist(String uid) async {
    var userRef = FirebaseFirestore.instance.collection(userCollection);
    // userRef.
    // QuerySnapshot snaptData = await userRef.where('uid', isEqualTo: uid).get();
    // if (snaptData.docs.length > 0) {
    //   return true;
    // } else {
    //   return false;
    // }

    try {
      var doc = await userRef.doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static String registerPhone(String value) {
    // String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // RegExp regExp =  RegExp(patttern);

    RegExp phoneExp = RegExp(r'^09\d{6,9}$');

    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!phoneExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }

    return null;
  }

  static String requiredField(
      BuildContext context, String value, String fileName) {
    if (value.isEmpty) {
      return "${Tran.of(context)?.text("requiredField")}"
          .replaceAll("@value", fileName);
    }
    return null;
  }

  static String email(
      BuildContext context, String value, String fileName, bool isRequired) {
    if (isRequired) {
      if (value.isEmpty) {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", fileName);
      }
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (regex.hasMatch(value)) {
      return "";
    } else {
      return "${Tran.of(context)?.text("emailInvaild")}";
    }
  }

  static String pin(
      BuildContext context, String value, String fileName, bool isRequired) {
    if (isRequired) {
      if (value.isEmpty) {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", fileName);
      }
    }
    if (value.length < 6) {
      String tip = "${Tran.of(context)?.text("lenghtInvaild")}";
      tip =
          tip.replaceAll("@filed", "${Tran.of(context)?.text("length_field")}");

      tip = tip.replaceAll("@size", "4");
      if (SystemData.language == "zh") {
        return tip;
      } else {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", tip);
      }
    }
    return null;
  }

  static String password(
      BuildContext context, String value, String fileName, bool isRequired) {
    if (isRequired) {
      if (value.isEmpty) {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", fileName);
      }
    }
    if (value.length < 4) {
      String tip = "${Tran.of(context)?.text("lenghtInvaild")}";
      tip =
          tip.replaceAll("@filed", "${Tran.of(context)?.text("length_field")}");

      tip = tip.replaceAll("@size", "4");
      if (SystemData.language == "zh") {
        return tip;
      } else {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", tip);
      }
    }
    return null;
  }

  static String confirmPassword(BuildContext context, String value,
      String confirmValue, String fileName, bool isRequired) {
    if (isRequired) {
      if (confirmValue.isEmpty) {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", fileName);
      }
    }
    if (value != confirmValue) {
      return "$fileName is not match!";
    }
    return null;
  }

  static String restPassword(BuildContext context, String newPassword,
      String oldPassword, String fileName, bool isRequired) {
    if (isRequired) {
      if (newPassword.isEmpty) {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", fileName);
      }
    }
    if (newPassword == oldPassword) {
      return "${Tran.of(context)?.text("newPwdCantNewPwd")}";
    }

    if (newPassword.length < 4) {
      String tip = "${Tran.of(context)?.text("lenghtInvaild1")}";
      tip =
          tip.replaceAll("@filed", "${Tran.of(context)?.text("length_field")}");
      tip = tip.replaceAll("@size", "4");
      if (SystemData.language == "zh") {
        return tip;
      } else {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", tip);
      }
    }
    return null;
  }

  static String userName(
      BuildContext context, String value, String fileName, bool isRequired) {
    if (isRequired) {
      if (value.isEmpty) {
        return "${Tran.of(context)?.text("requiredField")}"
            .replaceAll("@value", fileName);
      }
    }
    if (value.length < 4) {
      String tip = "${Tran.of(context)?.text("lenghtInvaild")}";
      tip = tip.replaceAll("@filed", fileName);
      tip = tip.replaceAll("@size", "4");
      return tip;
    }
    // RegExp phoneExp = RegExp(r'^[A-Za-z0-9]*$'); //english and number only
    // if (!phoneExp.hasMatch(value)) {
    //   return "Account is not correct";
    //   // Tran.of(context).text("userInvaild");
    // }
    return null;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    double.parse(s);
    return true;
  }
}
