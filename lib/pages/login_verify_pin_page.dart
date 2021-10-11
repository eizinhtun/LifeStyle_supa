// @dart=2.9
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:provider/provider.dart';

// import 'package:pin_code_text_field/pin_code_text_field.dart';

class LoginVerifyPinPage extends StatefulWidget {
  const LoginVerifyPinPage({Key key, @required this.verificationId})
      : super(key: key);
  final String verificationId;

  @override
  _LoginVerifyPinPageState createState() => _LoginVerifyPinPageState();
}

class _LoginVerifyPinPageState extends State<LoginVerifyPinPage> {
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
    await controller.stopListen();
    super.dispose();
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
//                               PinCodeTextField(
//                                 autofocus: true,
//                                 controller: controller,
//                                 hideCharacter: true,
//                                 highlight: true,
//                                 highlightColor: Colors.blue,
//                                 defaultBorderColor: Colors.black,
//                                 hasTextBorderColor: Colors.green,
//                                 highlightPinBoxColor: Colors.orange,
//                                 maxLength: 6,
//                                 hasError: hasError,
//                                 maskCharacter: "😎",
//                                 onTextChanged: (text) {
//                                   setState(() {
//                                     hasError = false;
//                                   });
//                                 },
//                                 onDone: (text) {
//                                   print("DONE $text");
//                                   print("DONE CONTROLLER ${controller.text}");
//                                 },
//                                 pinBoxWidth: 50,
//                                 pinBoxHeight: 64,
//                                 hasUnderline: true,
//                                 wrapAlignment: WrapAlignment.spaceAround,
//                                 pinBoxDecoration: ProvidedPinBoxDecoration
//                                     .defaultPinBoxDecoration,
//                                 pinTextStyle: TextStyle(fontSize: 22.0),
//                                 pinTextAnimatedSwitcherTransition:
//                                     ProvidedPinBoxTextAnimation
//                                         .scalingTransition,
// //                    pinBoxColor: Colors.green[100],
//                                 pinTextAnimatedSwitcherDuration:
//                                     Duration(milliseconds: 300),
// //                    highlightAnimation: true,
//                                 highlightAnimationBeginColor: Colors.black,
//                                 highlightAnimationEndColor: Colors.white12,
//                                 keyboardType: TextInputType.number,
//                               ),

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 6),
    ));
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

    // try {
    //   print("After: ${widget.verificationId}");
    //   final AuthCredential credential = PhoneAuthProvider.credential(
    //     verificationId: widget.verificationId,
    //     smsCode: controller.text,
    //   );
    //   final User user = (await _auth.signInWithCredential(credential)).user;
    //   print("Successfully signed in UID: ${user.uid}");
    //   showSnackbar("Successfully signed in UID: ${user.uid}");
    //   bool isLogin = await context.read<LoginProvider>().login(context);
    //   if (isLogin) {
    //     Navigator.of(context)
    //         .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    //   } else {
    //     Navigator.of(context)
    //         .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    //   }
    // } catch (e) {
    //   print(e.toString());
    //   showSnackbar("Failed to sign in: " + e.toString());
    // }
  }
}
