import 'package:flutter/material.dart';

const String smsUrl = "https://verify.smspoh.com/api/";
const String token =
    "VcDFsbOAZ3xpFVql7yLczsbAZmihyV9eZnUBdJHiz6-4k7_ggfNVllQxie5gEPMc";
const String smsToken =
    "SzhDl_-ytQEe2tTnRdg2UW4U7rFIbMmonUUQF8uJ1nAVxH5D08vNz8X_vA5TBLR1";
const String backendUrl = "https://api.thai2d3d.com/api";
const String version = "1.2.1";
const String serverKey =
    "AAAAp5abKQ0:APA91bG6Vl7FxmbqOqM1mCeZUzSpI-nJ3ieMC_-YVCQF7CW5jzAs10u1iu5asZ5HnwCDKd5v8mCMYPGYw6cRVf8j-uU6hjP9AONShIM5Sgijgh6tODZym01C5-KmJB2QiHX7hMhvegjd";

Future<Map<String, String>> getHeaders() async {
  //timezone
  try {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Access-Control-Allow-Credentials': 'true',
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "apikey": "5b927b5a7f672",
      "app": "App",
      "version": version,
      "language": "en",
      // "Authorization": sysData.token == "" ? "" : "Bearer " + sysData.token,
    };
    return headers;
  } catch (ex) {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Access-Control-Allow-Credentials': 'true',
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "apikey": "5b927b5a7f672",
      "app": "App",
      "version": version,
      "language": "my",
      "Authorization": "",
    };
    return headers;
  }
}

Future<Map<String, String>> getHeadersWithOutToken() async {
  //timezone
  try {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    };
    return headers;
  } catch (ex) {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    };
    return headers;
  }
}

const Color mainColor = Color(0xFFfa2e73);

const String userCollection = "users";
const String meterCollection = "meters";
const String userUploadUnitCollection = "user_upload_unit";
const String meterBillsCollection = "meter_bills";
const String userMeterCollection = "user_meters";
const String userReadUnitCollection = "user_read_unit";
const String transactions = "transactions";
const String manyTransaction = "manyTransition";
const String notifications = "notifications";
const String testCollection = "tests";

const String notilist = "notilist";
const String myTransactions = "myTransactions";

class ActionButton {
  static const String ReadUnit = "ReadUnit";
  static const String MeterBill = "MeterBill";
  static const String MeterList = "MeterList";
  static const String AddMeter = "AddMeter";
}

class TransactionType {
  static const String Topup = "topup";
  static const String Withdraw = "withdraw";
  static const String meterbill = "meterbill";
}

class PaymentType {
  static const String kpay = "kpay";
  static const String cbpay = "cbpay";
  static const String wavepay = "wavepay";
}
