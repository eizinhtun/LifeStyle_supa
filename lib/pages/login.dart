// @dart=2.9

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/register_verify_pin_page.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'language_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginformKey = GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  var userRef = FirebaseFirestore.instance.collection(userCollection);
  String verificationId = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String fcmtoken = "";
  bool isPhoneToken = false;
  String phone = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        "assets/icon/icon.png",
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _loginformKey,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _phoneController,
                              validator: (val) {
                                return Validator.registerPhone(val.toString());
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: Tran.of(context)?.text("phone"),
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                        ],
                      ),
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
                        bool isTaken = await checkPhoneIsTaken();
                        phone = phNoFormat();
                        if (!isTaken && _loginformKey.currentState.validate()) {
                          register();
                        }
                      },
                      child: Text(
                        "${Tran.of(context)?.text("login")}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "${Tran.of(context)?.text("login_with")}",
                      style: TextStyle(color: Colors.black26),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => _fblogin(),
                          icon: Icon(Icons.facebook),
                          iconSize: 50,
                          color: Color(0xff3b5998),
                        ),
                        MaterialButton(
                          onPressed: () => _googlelogin(),
                          child: Image.asset(
                            "assets/image/google.png",
                            height: 40,
                          ),
                          shape: CircleBorder(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LanguagePage()));

                        setState(() {});
                      },
                      child: Text(
                        "Select Language",
                        style: TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String phNoFormat() {
    String phoneNumber = _phoneController.text;
    if (phoneNumber.startsWith("0")) {
      phoneNumber = phoneNumber.substring(1, phoneNumber.length);
    }
    phoneNumber = "+95" + phoneNumber;
    return phoneNumber;
  }

  Future<bool> checkPhoneIsTaken() async {
    isPhoneToken =
        phone == null ? false : await Validator.checkUserIsExist(phone);

    if (isPhoneToken) {
      setState(() {});
    }
    return isPhoneToken;
  }

  void register() async {
    if (_loginformKey.currentState.validate()) {
      print("Validate");

      String token = await checkToken(fcmtoken);
      UserModel user = UserModel(
          phone: phone,
          fcmtoken: token,
          isActive: true,
          createdDate: DateTime.now());

      try {
        await _auth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: const Duration(seconds: 120),
            verificationCompleted:
                (PhoneAuthCredential phoneAuthCredential) async {},
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterVerifyPinPage(
                      user: user, verificationId: verificationId)));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              print("verification code: " + verificationId);

              verificationId = verificationId;
            });
      } catch (e) {
        MessageHandler.showSnackbar(
            "Failed to Verify Phone Number: $e", context, 6);
      }
    }
  }

  Future<void> _fblogin() async {
    String token = await checkToken(fcmtoken);
    await context.read<LoginProvider>().fbLogin(context, token);
  }

  Future<void> _googlelogin() async {
    String token = await checkToken(fcmtoken);
    await context.read<LoginProvider>().googleLogin(context, token);
  }

  String prettyPrint(Map json) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
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
