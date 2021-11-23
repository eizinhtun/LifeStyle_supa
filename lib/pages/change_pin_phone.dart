// @dart=2.9
import 'dart:async';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/sms_request_response.dart';
import 'package:left_style/services/smsApi.dart';
import 'package:provider/provider.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/validators/validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel user = UserModel();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String fcmtoken = "";

  @override
  void initState() {
    super.initState();
    getUser();
    // OTPInteractor.getAppSignature()
    //     //ignore: avoid_print
    //     .then((value) => print('signature - $value'));
    // controller = OTPTextEditController(
    //   codeLength: 6,
    //   //ignore: avoid_print
    //   onCodeReceive: (code) => print('Your Application receive code - $code'),
    // )..startListenUserConsent(
    //     (code) {
    //       final exp = RegExp(r'(\d{6})');
    //       return exp.stringMatch(code ?? '') ?? '';
    //     },
    //     strategies: [
    //       // SampleStrategy(),
    //     ],
    //   );
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
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    padding: EdgeInsets.only(top: 16),
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
                            pastedTextStyle: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: false,

                            // obscuringCharacter: '*',
                            // obscuringWidget: FlutterLogo(
                            //   size: 24,
                            // ),
                            // blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            validator: (val) {
                              return Validator.pin(
                                  context, val.toString(), "Pin", true);
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
                            keyboardType: TextInputType.number,
                            boxShadows: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                              print("Completed");
                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
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
                                  margin: EdgeInsets.all(5),
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
                              return Validator.password(
                                  context, val.toString(), "Password", true);
                            },
                            // decoration: InputDecoration(
                            //   labelText: "Password",
                            //   // contentPadding: EdgeInsets.all(16),
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
                              contentPadding: EdgeInsets.symmetric(
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
    String templateString = Tran.of(context).text("sms_template");

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
        MessageHandler.showError(context, "Invalid PIN", "Your pin is invalid");
      } else if (statusCode == 10) {
        MessageHandler.showError(
            context, "Attempt Exceed", "PIN Verify Attempt Exceed");
      } else if (statusCode == 11) {
        MessageHandler.showError(context, "PIN Expired", "PIN Expired");
      } else if (statusCode == 200) {
        MessageHandler.showMessage(context, "PIN Verified", "PIN Vefify OK");
        var pass = DBCrypt().hashpw(_pinController.text, DBCrypt().gensalt());
        user.password = pass;
        // user.password = _pinController.text;
        await context.read<LoginProvider>().updateUserInfo(context, user);
        Navigator.of(context).pop();
      } else {
        MessageHandler.showError(context, "Unknown", "Unknown Error!");
      }
    });
    // var url =
    //     "$smsUrl/v1/verify?access-token=$smsToken&request_id=$requestId&code=$smsCode";
    // var response = await http.get(
    //   Uri.parse(url),
    // );

    // if (statusCode == 0) {
    //   // Invalid PIN
    //   MessageHandler.showErrMessage(
    //       context, "Invalid PIN", "Your Pin is Invalid!");
    // } else if (statusCode == 10) {
    //   // PIN Verify Attempt Exceed
    //   MessageHandler.showErrMessage(context, "PIN Verify Attempt Exceed",
    //       "Your PIN Verify Attempt is Exceed!");
    // } else if (statusCode == 11) {
    //   // PIN Expired
    //   MessageHandler.showErrMessage(
    //       context, "PIN Expired", "Your Pin is Expired!");
    // } else {
    //   MessageHandler.showErrMessage(
    //       context, "PIN Valid", "Your Pin is Success!");
    //   var pass = DBCrypt().hashpw(_pinController.text, DBCrypt().gensalt());
    //   user.password = pass;
    //   await context.read<LoginProvider>().updateUserInfo(context, user);
    // }
    // SmsVerifyResponse resModel =
    //     SmsVerifyResponse.fromJson(json.decode(response.body));
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


// void requestPin(){
// try {
    //   await _auth.verifyPhoneNumber(
    //       phoneNumber: phone,
    //       timeout: const Duration(seconds: timeOut),
    //       verificationCompleted:
    //           (PhoneAuthCredential phoneAuthCredential) async {},
    //       verificationFailed: (FirebaseAuthException authException) {
    //         print(
    //             'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    //         MessageHandler.showSnackbar(
    //             Tran.of(context)
    //                 .text("phoneNumberVerificationFailedCode")
    //                 .replaceAll("@authExceptionCode", "${authException.code}")
    //                 .replaceAll(
    //                     "@authExceptionMessage", "${authException.message}"),
    //             //'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
    //             context,
    //             6);
    //       },
    //       codeSent: (String vId, [int forceResendingToken]) async {
    //         verificationId = vId;
    //         print('Please check your phone for the verification code.' + vId);
    //         MessageHandler.showSnackbar(
    //             Tran.of(context).text("checkPhoneNumberVerificationCode"),
    //             //'Please check your phone for the verification code.',
    //             context,
    //             6);
    //         verificationId = vId;
    //         print("Before: $verificationId");
    //       },
    //       codeAutoRetrievalTimeout: (String verificationId) {
    //         print("verification code: " + verificationId);
    //         verificationId = verificationId;
    //       });
    // } catch (e) {
    //   MessageHandler.showSnackbar(
    //       Tran.of(context).text('failVerifyPhoneNumber').replaceAll("@e", "$e"),
    //       // "Failed to Verify Phone Number: $e",
    //       context,
    //       6);
    // }
  
// }

// void submit(){

    //  FirebaseAuth auth = FirebaseAuth.instance;
    // print(verificationId);
    // PhoneAuthCredential _phCredential = PhoneAuthProvider.credential(
    //     verificationId: verificationId, smsCode: smsCode);
    // EmailAuthCredential _emailCredential =
    // EmailAuthProvider.credential(email: email, password: password);
    // FacebookAuthCredential _fbCredential =
    //     FacebookAuthProvider.credential(accessToken);
    //         UserCredential euserCredential =
    // await auth.signInWithPhoneNumber(phoneNumber)
    // signInWithCredential(_phCredential);
    // print(_phCredential);

    // auth.
    // UserCredential userCredential =
    //     await auth.signInWithCredential(_phCredential);
    // if (userCredential.user != null) {
    //   var pass = DBCrypt().hashpw(_pinController.text, DBCrypt().gensalt());
    //   user.password = pass;

    //   await context.read<LoginProvider>().updateUserInfo(context, user);
    // }
// }