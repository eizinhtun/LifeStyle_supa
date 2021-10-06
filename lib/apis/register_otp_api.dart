// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:left_style/NetworkUtil.dart';
import 'package:left_style/models/OtpSms.dart';
import 'package:left_style/utils/message_handler.dart';

import '../constants.dart';

class RegisterOTPApi {
  BuildContext context;
  RegisterOTPApi(this.context);

  NetworkUtil _netUtil = NetworkUtil();
  Future<OtpSms> getOtp({@required String phoneNumber}) async {
    phoneNumber = phoneNumber.replaceAll("+", "");
    var url = "$backendUrl/user/getRegisterOTP?phoneNo=$phoneNumber";
    OtpSms result;
    var _header = await getHeaders();
    http.Response response = await _netUtil.get(this.context, url, _header);

    if (response != null) {
      //print(response.statusCode);

      if (response.statusCode == 200) {
        if (response.body.trim() == "Not valid OTP code") {
          MessageHandler.showError(context, "Tip",
              "System Unauthorized"); //showError(context,Tran.of(context).text("// @dart=2.9"));
          return null;
        }
        var obj = json.decode(response.body);
        result = OtpSms.fromJson(obj);
        return result;
      } else if (response.statusCode == 406) {
        // phone number is taken
        MessageHandler.showError(context, "Tip",
            "Phone Number is already Taken"); //showError(context,Tran.of(context).text("sys_unauthrized"));
        return null;
      } else if (response.statusCode == 400) {
        // phone number is taken
        MessageHandler.showError(context, "Tip",
            "Phone Number is inValid"); //showError(context,Tran.of(context).text("sys_unauthrized"));
        return null;
      }

      return null;
    } else {
      //print("response null");
    }
    return null;
  }

  Future<bool> verifyOtp({String requestId, String otpCode}) async {
    var url = "$backendUrl/user/checkOTP?code=$otpCode&request_id=$requestId";
    OtpSms result;
    var _header = await getHeaders();
    http.Response response = await _netUtil.get(this.context, url, _header);
    //print("response =");
    if (response != null) {
      //print(response.statusCode);

      if (response.statusCode == 200) {
        if (response.body == null || response.body.length == 0) {
          MessageHandler.showError(context, "Tip",
              "OTP is not correct"); //showError(context,Tran.of(context).text("sys_unauthrized"));
          return false;
        }
        //print(response.body);

        if (response.body.trim() == "Not valid OTP code") {
          MessageHandler.showError(context, "Tip",
              "OTP is not correct"); //showError(context,Tran.of(context).text("sys_unauthrized"));
          return false;
        }
        var obj = json.decode(response.body);
        //print(obj);
        result = OtpSms.fromJson(obj);
        if (result != null) {
          if (result.status == true) {
            return true;
          } else {
            MessageHandler.showError(context, "Tip",
                "OTP is not correct"); //showError(context,Tran.of(context).text("sys_unauthrized"));
            return false;
          }
        }
      } else if (response.statusCode == 406) {
        // phone number is taken
        MessageHandler.showError(context, "Tip",
            "This mobile is already registered"); //showError(context,Tran.of(context).text("sys_unauthrized"));
        return false;
      } else if (response.statusCode == 400) {
        // phone number is taken
        MessageHandler.showError(context, "Tip",
            "phone number is not correct"); //showError(context,Tran.of(context).text("sys_unauthrized"));
        return false;
      }
      return false;
    } else {
      //print("response null");
      MessageHandler.showError(context, "Tip", "OTP is not correct");
    }
    return null;
  }
}
