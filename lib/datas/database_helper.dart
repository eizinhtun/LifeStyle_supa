// @dart=2.9
import 'dart:async';
import 'package:left_style/datas/data_key_name.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/system_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
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

  static Future<bool> setBoolData(bool data, String keyName) async {
    var dbClient = await db;
    dbClient.setString(keyName, data ? "1" : "0");
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
      await DatabaseHelper.setData(lang, "language").then((value) {});
      await Tran.of(context).load();
      return;
    } catch (ex) {
      await DatabaseHelper.setData("en", "language");
      return;
    }
  }

  static Future<void> setAppLoggedIn(
      BuildContext context, bool isLoggedIn) async {
    try {
      SystemData.isLoggedIn = isLoggedIn;

      await DatabaseHelper.setBoolData(isLoggedIn, "isLoggedIn");
      await Tran.of(context).load();
      return;
    } catch (ex) {
      await setBoolData(isLoggedIn, "isLoggedIn");
      return;
    }
  }

  static Future<void> setIsFirstTimeData(
      BuildContext context, bool isFirstTime) async {
    try {
      SystemData.isFirstTime = isFirstTime;
      await DatabaseHelper.setBoolData(isFirstTime, DataKeyValue.isFirstTime);
      return;
    } catch (ex) {
      await setBoolData(isFirstTime, DataKeyValue.isFirstTime);
      return;
    }
  }

  static Future<void> setSystemConfigData(
      BuildContext context, SystemConfig config) async {
    try {
      SystemData.introAutoSkip = config.introAutoSkip;
      SystemData.introDisplaySec = config.introDisplaySec;
      SystemData.onMeterUploadFunc = config.onMeterUploadFunc;
      SystemData.payMeterBillVideoLink = config.payMeterBillVideoLink;
      SystemData.topupVideoLink = config.topupVideoLink;
      SystemData.uploadMeterVideoLink = config.uploadMeterVideoLink;
      SystemData.withdrawVideoLink = config.withdrawVideoLink;
      await DatabaseHelper.setBoolData(
          config.introAutoSkip, DataKeyValue.introAutoSkip);
      await DatabaseHelper.setData(
          config.introDisplaySec.toString(), DataKeyValue.introDisplaySec);
      await DatabaseHelper.setBoolData(
          config.onMeterUploadFunc, DataKeyValue.onMeterUploadFunc);
      await DatabaseHelper.setData(
          config.payMeterBillVideoLink, DataKeyValue.payMeterBillVideoLink);
      await DatabaseHelper.setData(
          config.topupVideoLink, DataKeyValue.topupVideoLink);
      await DatabaseHelper.setData(
          config.uploadMeterVideoLink, DataKeyValue.uploadMeterVideoLink);
      await DatabaseHelper.setData(
          config.withdrawVideoLink, DataKeyValue.withdrawVideoLink);

      return;
    } catch (ex) {
      await DatabaseHelper.setBoolData(
          config.introAutoSkip, DataKeyValue.introAutoSkip);
      await DatabaseHelper.setData(
          config.introDisplaySec.toString(), DataKeyValue.introDisplaySec);
      await DatabaseHelper.setBoolData(
          config.onMeterUploadFunc, DataKeyValue.onMeterUploadFunc);
      await DatabaseHelper.setData(
          config.payMeterBillVideoLink, DataKeyValue.payMeterBillVideoLink);
      await DatabaseHelper.setData(
          config.topupVideoLink, DataKeyValue.topupVideoLink);
      await DatabaseHelper.setData(
          config.uploadMeterVideoLink, DataKeyValue.uploadMeterVideoLink);
      await DatabaseHelper.setData(
          config.withdrawVideoLink, DataKeyValue.withdrawVideoLink);
      return;
    }
  }

  static Future<void> clearStorage() async {
    await _db.clear();
  }

  // static Future<String> getTimeZone() async {
  //   // final timeInUtc = DateTime.utc(1995, 1, 1);

  //   String timeZoneStr = DateTime.now().timeZoneOffset.toString();
  //   int index = timeZoneStr.indexOf(".", 2) - 3;
  //   timeZoneStr = timeZoneStr.substring(0, index);

  //   if (timeZoneStr.substring(0, 1) != "-") {
  //     timeZoneStr = "+" + timeZoneStr;
  //   }
  //   return timeZoneStr;
  // }
}
