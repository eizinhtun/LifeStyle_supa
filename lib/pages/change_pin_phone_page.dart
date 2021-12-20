// @dart=2.9
import 'dart:async';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/sms_request_response.dart';
import 'package:left_style/services/sms_api.dart';
import 'package:provider/provider.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:left_style/utils/validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';

class ChangePinPhonePage extends StatefulWidget {
  const ChangePinPhonePage({Key key}) : super(key: key);

  @override
  _ChangePinPhonePageState createState() => _ChangePinPhonePageState();
}

class _ChangePinPhonePageState extends State<ChangePinPhonePage> {
  TextEditingController controller = TextEditingController();
  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";
  TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = false;
  bool isVisible = false;

  UserModel user = UserModel();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String fcmtoken = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<UserModel> getUser() async {
    user = await context.read<LoginProvider>().getUser(context);
    return user;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    // await controller.stopListen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Tran.of(context).text("changePin")),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: !isVisible,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isVisible = !isVisible;
                      });

                      await requestOTP(context, user.phone);
                    },
                    child: Text(Tran.of(context).text("getOtpCode")),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Tran.of(context).text("enterYourOtpCode"),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          PinCodeTextField(
                            appContext: context,
                            autoFocus: true,
                            // pastedTextStyle: TextStyle(
                            //   color: Colors.green.shade600,
                            //   fontWeight: FontWeight.bold,
                            // ),
                            length: 6,
                            obscureText: false,

                            // obscuringCharacter: '*',
                            // obscuringWidget: FlutterLogo(
                            //   size: 24,
                            // ),
                            // blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            validator: (val) {
                              return Validator.pin(context, val.toString(),
                                  Tran.of(context).text("pin"), true);
                            },
                            pinTheme: PinTheme(
                                inactiveFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                                selectedColor: Colors.black38,
                                inactiveColor: Colors.black26,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                activeColor: Colors.black38),
                            // cursorColor: Colors.black,
                            animationDuration: Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: controller,
                            keyboardType: TextInputType.numberWithOptions(),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            boxShadows: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {},
                            // onTap: () {
                            //
                            // },
                            onChanged: (value) {
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ArgonTimerButton(
                              initialTimer: timeOut,
                              highlightColor: Colors.white,
                              // Colors.transparent,
                              highlightElevation: 0,
                              height: 40,
                              width: 100,
                              onTap: (startTimer, btnState) async {
                                if (btnState == ButtonState.Idle) {
                                  await requestOTP(context, user.phone);

                                  startTimer(timeOut);
                                }
                              },
                              child: Text(
                                Tran.of(context).text("resendOtp"),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                              loader: (timeLeft) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  margin: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  child: Text(
                                    Tran.of(context)
                                        .text("timeLeft")
                                        .replaceAll("@timeLeft", "$timeLeft"),
                                    //"$timeLeft",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                );
                              },
                              borderRadius: 5.0,
                              color: Colors.transparent,
                              elevation: 0,
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  // Colors.black.withOpacity(0.2),
                                  width: 1.5),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _pinController,
                            keyboardType: TextInputType.text,
                            obscureText: _obscureText,
                            validator: (val) {
                              return Validator.password(context, val.toString(),
                                  Tran.of(context).text("password"), true);
                            },
                            // decoration: InputDecoration(
                            //   labelText: "Password",
                            //   // contentPadding: const EdgeInsets.all(16),
                            // ),
                            decoration: InputDecoration(
                              labelText: Tran.of(context).text("password"),
                              labelStyle: TextStyle(),
                              hintText: "${Tran.of(context)?.text('password')}",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                side: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  user.fcmtoken = await checkToken(fcmtoken);
                                  await submit(context);
                                  // await submit(context).then((value) {
                                  //   Navigator.pop(context);
                                  // });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  Tran.of(context).text("changePinSubmit"),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String verificationId = "";
  int requestId;
  Future<void> requestOTP(BuildContext context, String phone) async {
    SmsApi api = SmsApi(context);
    // String templateString =
    // "{brand_name} အတွက် အတည်ပြုရန်ကုဒ်နံပါတ်မှာ {code} ဖြစ်ပါတယ်";
    // String templateString = Tran.of(context).text("sms_template");

    // String phone = "09401531039";
    // var url =
    //     "$smsUrl/v1/request?access-token=$smsToken&number=$phone&brand_name=$brandName&code_length=$codeLength&sender_name=$brandName&template={brand_name} အတွက် အတည်ပြုရန်ကုဒ်နံပါတ်မှာ {code} ဖြစ်ပါတယ်";

    SmsRequestResponse resModel = await api.requestPin(context, user.phone);
    requestId = resModel.requestId;
  }

  Future<void> submit(BuildContext context) async {
    SmsApi api = SmsApi(context);
    String smsCode = controller.text.trim();
    await api.verifyPin(context, requestId, smsCode).then((statusCode) async {
      if (statusCode == 0) {
        ShowMessageHandler.showError(
            context,
            Tran.of(context).text("invalid_pin"),
            Tran.of(context).text("invalid_pin_str"));
      } else if (statusCode == 10) {
        ShowMessageHandler.showError(
            context,
            Tran.of(context).text("attempt_exceed"),
            Tran.of(context).text("attempt_exceed_str"));
      } else if (statusCode == 11) {
        ShowMessageHandler.showError(
            context,
            Tran.of(context).text("pin_expired"),
            Tran.of(context).text("pin_expired_str"));
      } else if (statusCode == 200) {
        ShowMessageHandler.showMessage(
            context,
            Tran.of(context).text("pin_verified"),
            Tran.of(context).text("pin_verified_str"));
        var pass = DBCrypt().hashpw(_pinController.text, DBCrypt().gensalt());
        user.password = pass;
        // user.password = _pinController.text;
        await context.read<LoginProvider>().updateUserInfo(context, user);
        Navigator.of(context).pop();
      } else {
        ShowMessageHandler.showError(context, Tran.of(context).text("unknown"),
            Tran.of(context).text("unknown_str"));
      }
    });
  }

  Future<String> checkToken(String fcmtoken) async {
    String tokenStr = "";
    if (!kIsWeb) {
      if (fcmtoken == null || fcmtoken == "") {
        tokenStr = await _messaging.getToken();
        if (tokenStr == null || tokenStr == "") {
          tokenStr = await checkToken(tokenStr);
        } else {
          SystemData.fcmtoken = tokenStr;
        }
        return tokenStr;
      } else {
        return fcmtoken;
      }
    } else {
      return null;
    }
  }
}
