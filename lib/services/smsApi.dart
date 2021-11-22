// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/sms_request_response.dart';
import 'package:left_style/models/sms_verify_response.dart';
import 'package:left_style/utils/message_handler.dart';
import '../datas/constants.dart';

class SmsApi {
  BuildContext context;
  SmsApi(this.context);
  Future<SmsRequestResponse> requestPin(
      BuildContext context, String phone) async {
    SmsRequestResponse result = SmsRequestResponse();
    String templateString = Tran.of(context).text("sms_template");
    var url =
        "$smsUrl/v1/request?access-token=$smsToken&number=$phone&brand_name=$brandName&code_length=$codeLength&sender_name=$brandName&template=$templateString";
    // {brand_name} အတွက် အတည်ပြုရန်ကုဒ်နံပါတ်မှာ {code} ဖြစ်ပါတယ်";

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Access-Control_Allow_Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
    });
    print("Response: ${response.statusCode}");
    if (response != null) {
      var obj = json.decode(response.body);
      result = SmsRequestResponse.fromJson(obj);

      return result;
    }
    return null;
  }

  Future<int> verifyPin(
      BuildContext context, int requestId, String code) async {
    var url =
        "$smsUrl/v1/verify?access-token=$smsToken&request_id=$requestId&code=$code";
    SmsVerifyResponse result = SmsVerifyResponse();
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Access-Control_Allow_Origin": "*",
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
    });
    print("Response: ${response.statusCode}");
    return response.statusCode;
  }

  Future<void> sendMessage(String phone, String signature, String otp) async {
    // SmsRequestResponse result = SmsRequestResponse();
    var body = json.encode({
      "to": "$phone",
      "message": "OTP ကုဒ် $otp။ ဤကုဒ်အား မည်သူ့ကိုမှ မပေးပါရန်။.$signature",
      "sender": "SMSPoh",
      "test": "true"
    });
    // var url = "$smsUrl/v2/send";
    var smsurl = "https://smspoh.com/api/v2/send";
    http.Response response = await http.post(Uri.parse(smsurl),
        headers: {
          "Authorization": "Bearer $smsToken",
          "Content-Type": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
        },
        body: body);
    print("Response: ${response.statusCode}");
    print(response.body);
    // if (response != null) {
    //   var obj = json.decode(response.body);
    //   result = SmsRequestResponse.fromJson(obj);

    //   return result;
    // }
    // return null;
  }
}
