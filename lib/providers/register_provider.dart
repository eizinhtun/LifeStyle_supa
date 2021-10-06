// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:left_style/apis/register_otp_api.dart';
import 'package:left_style/models/OtpSms.dart';

class RegisterProvider with ChangeNotifier, DiagnosticableTreeMixin {
  RegisterOTPApi _registerOTPApi;
  bool _requestingOtp = false;

  bool _verifingOtp = false;
  bool get verifingOtp => _verifingOtp;

  OtpSms _smsData = OtpSms();

  Future<OtpSms> getOtp(BuildContext context, String phoneNumber) async {
    _requestingOtp = true;
    notifyListeners();
    _registerOTPApi = RegisterOTPApi(context);
    _smsData = await _registerOTPApi.getOtp(phoneNumber: phoneNumber);
    _requestingOtp = false;
    notifyListeners();
    return _smsData;
  }

  Future<bool> verifyOtp(
      BuildContext context, String requestId, String otpCode) async {
    _verifingOtp = true;
    notifyListeners();
    _registerOTPApi = RegisterOTPApi(context);
    bool result =
        await _registerOTPApi.verifyOtp(requestId: requestId, otpCode: otpCode);
    _verifingOtp = false;
    notifyListeners();
    return result;
  }
}
