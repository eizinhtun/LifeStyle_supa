// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/validators/validator.dart';

import 'register_verify_pin_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerformKey = GlobalKey<FormState>();
  bool _obscureText = true;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isPhoneToken = false;
  String phone = "";

  var userRef = FirebaseFirestore.instance.collection(userCollection);
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String verificationId = "";
  String fcmtoken = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SmsApi _smsApi = SmsApi(this.context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "Register",
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 0.0,
          ),
          SliverToBoxAdapter(
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
                              Form(
                                key: _registerformKey,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _phoneController,
                                          validator: (val) {
                                            String phoneFormate =
                                                Validator.registerPhone(
                                                    val.toString());
                                            if (phoneFormate != null) {
                                              return phoneFormate;
                                            }
                                            String data =
                                                Validator.showPhoneToken(
                                                    isPhoneToken);
                                            if (data != "") {
                                              return data;
                                            }

                                            return null;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('phone')}",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _nameController,
                                          validator: (val) {
                                            return Validator.userName(
                                                context,
                                                val.toString(),
                                                "User Name",
                                                true);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('full_name')}",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _passwordController,
                                          obscureText: _obscureText,
                                          validator: (val) {
                                            return Validator.password(
                                                context,
                                                val.toString(),
                                                "Password",
                                                true);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('password')}",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _obscureText =
                                                        !_obscureText;
                                                  });
                                                },
                                                child: Icon(_obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _confirmPasswordController,
                                          obscureText: _obscureText,
                                          validator: (val) {
                                            return Validator.confirmPassword(
                                                context,
                                                val.toString(),
                                                _passwordController.text,
                                                "Confirm Password",
                                                true);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('confirm_password')}",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _obscureText =
                                                        !_obscureText;
                                                  });
                                                },
                                                child: Icon(_obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      )
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
                                    if (!isTaken) {
                                      register();
                                    }
                                  },
                                  child: Text(
                                    "${Tran.of(context)?.text('register')}",
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

  void register() async {
    if (_registerformKey.currentState.validate()) {
      print("Validate");
      // var pass = new DBCrypt()
      //     .hashpw(_passwordController.text, new DBCrypt().gensalt());
      // var isCorrect = new DBCrypt().checkpw(plain, hashed);

      String token = await checkToken(fcmtoken);
      UserModel user = UserModel(
          fullName: _nameController.text,
          phone: phone,
          fcmtoken: token,
          createdDate: Timestamp.fromDate(DateTime.now()));

      try {
        await _auth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: const Duration(seconds: timeOut),
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
            // codeSent,
            codeAutoRetrievalTimeout: (String verificationId) {
              print("verification code: " + verificationId);
              MessageHandler.showSnackbar(
                  "verification code: " + verificationId, context, 6);
              verificationId = verificationId;
            });
      } catch (e) {
        MessageHandler.showSnackbar(
            "Failed to Verify Phone Number: $e", context, 6);
      }
    }
  }

  Future<bool> checkUserIsExist(String phoneNumber) async {
    QuerySnapshot snaptData =
        await userRef.where('phone', isEqualTo: phoneNumber).get();
    if (snaptData.docs.length > 0) {
      return true;
    } else {
      return true;
    }
  }
}
