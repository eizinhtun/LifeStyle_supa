// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:left_style/apis/smsApi.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyPinPage extends StatefulWidget {
  const VerifyPinPage({Key key, @required this.requestId}) : super(key: key);
  final int requestId;

  @override
  _VerifyPinPageState createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> with CodeAutoFill {
  String otp = "123456";

  String appSignature = "{{app signature}}";
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  @override
  void codeUpdated() {
    setState(() {
      otp = code;
      textEditingController.text = otp;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  @override
  Widget build(BuildContext context) {
    SmsApi _smsApi = SmsApi(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            FlutterLogo(
                              size: 180,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("App Signature : $appSignature"),
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
                                  otp = "135796";
                                  setState(() {});
                                  _smsApi.sendMessage(
                                      "09401531039", appSignature, otp);
                                },
                                child: Text(
                                  "Send Message",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            otp == null
                                ? Text(
                                    "Listening for code...",
                                  )
                                : Text(
                                    "Code Received: $otp",
                                  ),
                            SizedBox(
                              height: 20,
                            ),
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
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                              ),
                              cursorColor: Colors.black,
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
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
                              height: 70,
                              child: OTPTextField(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 45,
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 15,
                                style: GoogleFonts.roboto(
                                    fontSize: 17, fontStyle: FontStyle.normal),
                                onChanged: (pin) {
                                  otp = pin;
                                },
                                onCompleted: (pin) {
                                  otp = pin;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: 50,
                                  minWidth: double.infinity,
                                  maxHeight: 400),
                              child: ElevatedButton(
                                onPressed: () async {
                                  print("Pressed");
                                  _smsApi.verifyPin(
                                      widget.requestId, int.parse(otp));
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
          Positioned(
            top: 20.0,
            left: 4.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey[900]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
