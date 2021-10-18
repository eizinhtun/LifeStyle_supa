// @dart=2.9
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_autofill/otp_autofill.dart';
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
  OTPTextEditController controller;
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    super.initState();
    OTPInteractor.getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));
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
