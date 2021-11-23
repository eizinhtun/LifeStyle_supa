// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/database_helper.dart';

class LanguageProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  Future<void> changeLang(BuildContext context, String lang) async {
    await DatabaseHelper.setLanguage(context, lang);

    notifyListeners();
  }
  Locale _currentLocale = new Locale("en");


  Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale){
    this._currentLocale = new Locale(_locale);
    notifyListeners();
  }
}
