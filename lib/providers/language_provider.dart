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

class LanguageProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  Future<void> changeLang(BuildContext context, String lang) async {
    await DatabaseHelper.setLanguage(context, lang);

    notifyListeners();
  }
}
