// @dart=2.9
import 'dart:async';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:provider/provider.dart';

class LoginVerifyPinPage extends StatefulWidget {
  const LoginVerifyPinPage(
      {Key key, @required this.verificationId, @required this.phone})
      : super(key: key);
  final String verificationId;
  final String phone;

  @override
  _LoginVerifyPinPageState createState() => _LoginVerifyPinPageState();
}

class _LoginVerifyPinPageState extends State<LoginVerifyPinPage> {
  var userRef = FirebaseFirestore.instance.collection(userCollection);
  OTPTextEditController controller;
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";

  String codeExtractor(String code) {
    return code;
  }

  @override
  void initState() {
    super.initState();

    OTPInteractor.getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 6,
      // autoStop: false,
      // onTimeOutException: () {
      //   print("Time OUt");
      // },
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
        //  senderNumber: "+959263025596"
      );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.stopListen();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
        // senderNumber: "+959263025596"
      );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 0.0,
          ),
          // SliverToBoxAdapter(
          SliverFillRemaining(
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              PinCodeTextField(
                                appContext: context,
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
                                validator: (v) {
                                  if (v.length < 3) {
                                    return "I'm from validator";
                                  } else {
                                    return null;
                                  }
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
                              SizedBox(
                                height: 20,
                              ),
                              ArgonTimerButton(
                                initialTimer: 120,
                                highlightColor: Colors.transparent,
                                highlightElevation: 0,
                                height: 40,
                                width: 100,
                                onTap: (startTimer, btnState) async {
                                  if (btnState == ButtonState.Idle) {
                                    resendOTP(widget.phone);
                                    // var returnResult = await context
                                    //     .read<RegisterProvider>()
                                    //     .getForgetPasswordOtp(
                                    //         context, widget.otpSms.number);
                                    // if (returnResult != null) {
                                    //   widget.otpSms.requestId =
                                    //       returnResult.requestId;
                                    //   widget.otpSms.status =
                                    //       returnResult.status;
                                    // }
                                    startTimer(120);
                                  }
                                },
                                child: Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                loader: (timeLeft) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    margin: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    child: Text(
                                      "$timeLeft",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  );
                                },
                                borderRadius: 5.0,
                                color: Colors.transparent,
                                elevation: 0,
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.2),
                                    width: 1.5),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minHeight: 50,
                                    minWidth: double.infinity,
                                    maxHeight: 400),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    print("Pressed");
                                    signInWithPhoneNumber();
                                  },
                                  child: Text(
                                    "Verify Pin",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void resendOTP(String phone) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 5),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
            MessageHandler.showSnackbar(
                "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}",
                context,
                6);
          },
          verificationFailed: (FirebaseAuthException authException) {
            print(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
            MessageHandler.showSnackbar(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
                context,
                6);
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            print('Please check your phone for the verification code.' +
                verificationId);
            MessageHandler.showSnackbar(
                'Please check your phone for the verification code.',
                context,
                6);
            verificationId = verificationId;
            print("Before: $verificationId");
          },
          // codeSent,
          codeAutoRetrievalTimeout: (String verificationId) {
            print("verification code: " + verificationId);
            MessageHandler.showSnackbar(
                "verification code: " + verificationId, context, 6);
            verificationId = verificationId;
          });

      // print("Before: $verificationId");
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => RegisterVerifyPinPage(
      //         user: user, verificationId: verificationId)));

    } catch (e) {
      MessageHandler.showSnackbar(
          "Failed to Verify Phone Number: $e", context, 6);
    }
  }

  void signInWithPhoneNumber() async {
    // var recaptchaVerifier = RecaptchaVerifier(
    //   container: null,
    //   size: RecaptchaVerifierSize.compact,
    //   theme: RecaptchaVerifierTheme.dark,
    //   onSuccess: () async {
    //     print('reCAPTCHA Completed!');
    //     // setState(() {
    //     //   currentInput = "otp";
    //     //   _isLoading = false;
    //     // });
    //   },
    //   onError: (FirebaseAuthException error) async {
    //     print("error");
    //     print(error);
    //     // setState(() {
    //     //   _isLoading = false;
    //     // });
    //     _scaffoldKey.currentState
    //         .showSnackBar(SnackBar(content: Text(error.message)));
    //   },
    //   onExpired: () async {
    //     print('reCAPTCHA Expired!');
    //     // setState(() {
    //     //   _isLoading = false;
    //     // });
    //   },
    // );

    await context
        .read<LoginProvider>()
        .login(context, widget.verificationId, controller.text);
  }
}
