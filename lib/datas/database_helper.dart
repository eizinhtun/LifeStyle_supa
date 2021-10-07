// @dart=2.9
import 'dart:async';
import 'package:left_style/datas/system_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static SharedPreferences _db;
  static Future<SharedPreferences> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    _db = await SharedPreferences.getInstance();
    return _db;
  }

  static Future<bool> setData(String data, String keyName) async {
    var dbClient = await db;
    dbClient.setString(keyName, data);
    return true;
  }

  static Future<String> getData(String keyName) async {
    try {
      var dbClient = await db;
      return dbClient.getString(keyName);
    } catch (ex) {
      if (keyName == "language") {
        return "my";
      }
      return null;
    }
  }

  static Future<String> getLanguage() async {
    try {
      String langunage = await getData("language");
      if (langunage == "" || langunage == null) {
        await setData("my", "language");
      }
      langunage = (langunage == null || langunage == "" || langunage == "null")
          ? "my"
          : langunage;
      SystemData.language = langunage;
      return langunage;
    } catch (ex) {
      await setData("my", "language");
      SystemData.language = "my";
      return "my";
    }
  }

  static Future<void> setLanguage(BuildContext context, String lang) async {
    try {
      SystemData.language = lang;

      await DatabaseHelper.setData(lang, "language");
      await Tran.of(context).load();
      return;
    } catch (ex) {
      await setData("en", "language");
      return;
    }
  }

  // static Future<String> getTimeZone() async {
  //   // final timeInUtc = new DateTime.utc(1995, 1, 1);

  //   String timeZoneStr = new DateTime.now().timeZoneOffset.toString();
  //   int index = timeZoneStr.indexOf(".", 2) - 3;
  //   timeZoneStr = timeZoneStr.substring(0, index);

  //   if (timeZoneStr.substring(0, 1) != "-") {
  //     timeZoneStr = "+" + timeZoneStr;
  //   }
  //   return timeZoneStr;
  // }
}
