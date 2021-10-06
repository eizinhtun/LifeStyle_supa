// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:left_style/models/sms_request_model.dart';
import 'package:left_style/models/sms_verify_model.dart';
import '../constants.dart';

class SmsApi {
  Future<SmsRequestModel> requestPin(String phone) async {
    SmsRequestModel result = SmsRequestModel();
    var url =
        "$smsUrl/v1/request?access-token=$token&number=$phone&brand_name=EPC";
    http.Response response = await http.get(Uri.parse(url));
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
    http.Response response = await http.get(Uri.parse(url));

    if (response != null) {
      var obj = json.decode(response.body);
      result = SmsVerifyModel.fromJson(obj);
      return result;
    }
    return null;
  }
}
