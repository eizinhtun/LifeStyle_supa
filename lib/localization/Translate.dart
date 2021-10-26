// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/datas/system_data.dart';

class Tran {
  Tran(this.locale);

  final Locale locale;

  static Tran of(BuildContext context) {
    try {
      return Localizations.of<Tran>(context, Tran);
    } catch (ex) {
      return null;
    }
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String savedCode = "en";
    savedCode = SystemData.language;
    SystemData.language = savedCode;
    try {
      savedCode = await DatabaseHelper.getLanguage();
      SystemData.language = savedCode;
    } catch (e) {
      savedCode = "en";
      SystemData.language = savedCode;
    }

    print(savedCode);
    String data = await rootBundle.loadString('lang/I18n_$savedCode.json');
    Map<String, dynamic> _result = json.decode(data);
    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String text(String key) {
    if (key == null || key.length == 0) {
      return "";
    }
    try {
      var result = this._sentences[key];
      return result == null ? '$key Expection' : result;
    } catch (ex) {
      return '$key Expection';
    }
  }
}
