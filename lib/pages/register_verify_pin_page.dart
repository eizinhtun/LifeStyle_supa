// @dart=2.9
import 'dart:async';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterVerifyPinPage extends StatefulWidget {
  const RegisterVerifyPinPage(
      {Key key, @required this.user, @required this.verificationId})
      : super(key: key);
  final UserModel user;
  final String verificationId;

  @override
  _RegisterVerifyPinPageState createState() => _RegisterVerifyPinPageState();
}

class _RegisterVerifyPinPageState extends State<RegisterVerifyPinPage> {
  var userRef = FirebaseFirestore.instance.collection(userCollection);
  TextEditingController controller = TextEditingController();
  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    super.initState();
    // OTPInteractor.getAppSignature()
    //     //ignore: avoid_print
    //     .then((value) =>
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

  @override
  Future<void> dispose() async {
    super.dispose();
    // await controller.stopListen();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              PinCodeTextField(
                                appContext: context,
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
                                validator: (v) {
                                  if (v.length != 6) {
                                    return Tran.of(context)
                                        .text("otp_6_digits");
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
                                      requestOTP(widget.user.phone);

                                      startTimer(timeOut);
                                    }
                                  },
                                  child: Text(
                                    Tran.of(context).text("resend_otp"),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  loader: (timeLeft) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      margin: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      width: 40,
                                      height: 40,
                                      child: Text(
                                        "$timeLeft",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
                              Container(
                                constraints: BoxConstraints(
                                    minHeight: 50,
                                    minWidth: double.infinity,
                                    maxHeight: 400),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    signInWithPhoneNumber();
                                  },
                                  child: Text(
                                    Tran.of(context).text("verify_pin"),
                                    style: const TextStyle(
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
  Future<void> requestOTP(String phone) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: timeOut),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            String str = Tran.of(context)
                .text("phoneNumberVerificationFailedCode")
                .replaceAll('@authExceptionCode', authException.code)
                .replaceAll('@authExceptionMessage', authException.message);
            ShowMessageHandler.showSnackbar(str, context, 6);
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            print('Please check your phone for the verification code.' +
                verificationId);
            ShowMessageHandler.showSnackbar(
                Tran.of(context).text("checkPhoneNumberVerificationCode"),
                context,
                6);
            verificationId = verificationId;

            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => RegisterVerifyPinPage(
            //         user: user, verificationId: verificationId)));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
          });
    } catch (e) {
      ShowMessageHandler.showSnackbar(
          Tran.of(context).text("failVerifyPhoneNumber").replaceAll('@e', e),
          context,
          6);
    }
  }

  void signInWithPhoneNumber() async {
    bool isSuccess = await context
        .read<LoginProvider>()
        .register(context, widget.verificationId, controller.text, widget.user);
    if (isSuccess) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}

// var recaptchaVerifier = RecaptchaVerifier(
//   container: null,
//   size: RecaptchaVerifierSize.compact,
//   theme: RecaptchaVerifierTheme.dark,
//   onSuccess: () async {
//
//     // setState(() {
//     //   currentInput = "otp";
//     //   _isLoading = false;
//     // });
//   },
//   onError: (FirebaseAuthException error) async {
//
//
//     // setState(() {
//     //   _isLoading = false;
//     // });
//     _scaffoldKey.currentState
//         .showSnackBar(SnackBar(content: Text(error.message)));
//   },
//   onExpired: () async {
//
//     // setState(() {
//     //   _isLoading = false;
//     // });
//   },
// );
