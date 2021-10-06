// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:left_style/models/sms_request_model.dart';
import 'package:left_style/models/sms_verify_model.dart';
import 'package:left_style/utils/message_handler.dart';
import '../constants.dart';

class SmsApi {
  BuildContext context;
  SmsApi(this.context);
  Future<SmsRequestModel> requestPin(String phone) async {
    SmsRequestModel result = SmsRequestModel();
    var url =
        "$smsUrl/v1/request?access-token=$token&number=$phone&brand_name=EPC";
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Access-Control_Allow_Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
    });
    print("Response: ${response.statusCode}");
    if (response != null) {
      var obj = json.decode(response.body);
      result = SmsRequestModel.fromJson(obj);

      return result;
    }
    return null;
  }

  Future<SmsVerifyModel> verifyPin(int requestId, int code) async {
    var url =
        "$smsUrl/v1/verify?access-token=$token&request_id=$requestId&code=$code";
    SmsVerifyModel result = SmsVerifyModel();
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Access-Control_Allow_Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
    });
    print("Response: ${response.statusCode}");
    print(response.body);
    if (response != null) {
      if (response.statusCode == 0) {
        MessageHandler.showError(context, "Invalid PIN", "Your pin is invalid");
        return null;
      } else if (response.statusCode == 10) {
        MessageHandler.showError(
            context, "Attempt Exceed", "PIN Verify Attempt Exceed");
        return null;
      } else if (response.statusCode == 11) {
        MessageHandler.showError(context, "PIN Expired", "PIN Expired");
        return null;
      } else if (response.statusCode == 200) {
        var obj = json.decode(response.body);
        result = SmsVerifyModel.fromJson(obj);
        MessageHandler.ShowMessage(context, "PIN Verified", "PIN Vefify OK");

        return result;
      }
    }
    return null;
  }

  Future<void> sendMessage(String phone, String signature, String otp) async {
    SmsRequestModel result = SmsRequestModel();
    var body = json.encode({
      "to": "$phone",
      "message": "OTP ကုဒ် $otp။ ဤကုဒ်အား မည်သူ့ကိုမှ မပေးပါရန်။.$signature",
      "sender": "SMSPoh",
      "test": "true"
    });
    var url = "$smsUrl/v2/send";
    var smsurl = "https://smspoh.com/api/v2/send";
    http.Response response = await http.post(Uri.parse(smsurl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
        },
        body: body);
    print("Response: ${response.statusCode}");
    print(response.body);
    // if (response != null) {
    //   var obj = json.decode(response.body);
    //   result = SmsRequestModel.fromJson(obj);

    //   return result;
    // }
    // return null;
  }
}
