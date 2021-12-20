// @dart=2.9
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/register_verify_pin_page.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/validator.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
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
      body: LoadingOverlay(
        isLoading: isWaiting,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(30),
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
                        padding: const EdgeInsets.all(5),
                        // decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     boxShadow: [
                        //       BoxShadow(
                        //           color: Color.fromRGBO(143, 148, 251, .2),
                        //           blurRadius: 20.0,
                        //           offset: Offset(0, 10))
                        //     ]),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _phoneController,
                              validator: (val) {
                                return Validator.registerPhone(
                                    context, val.toString());
                              },
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: Tran.of(context)?.text("phone"),
                                //     border: InputBorder.none,
                                //     hintText: Tran.of(context)?.text("phone"),
                                //     hintStyle:
                                //         const TextStyle(color: Colors.grey[400])
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
                          if (!isTaken &&
                              _loginformKey.currentState.validate()) {
                            register();
                          }
                        },
                        child: Text(
                          "${Tran.of(context)?.text("login")}",
                          style: const TextStyle(
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
                        style: const TextStyle(color: Colors.black26),
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
                            onPressed: () async {
                              await _googlelogin();
                              // setState(() {});
                            },
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
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            Tran.of(context).text("select_language"),
                            style: const TextStyle(color: mainColor),
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

  bool isWaiting = false;
  void register() async {
    setState(() {
      isWaiting = true;
    });
    String token = await checkToken(fcmtoken);
    UserModel user = UserModel(
        phone: phone,
        fcmtoken: token,
        isActive: true,
        createdDate: Timestamp.fromDate(DateTime.now()));

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
            ShowMessageHandler.showSnackbar(
                Tran.of(context).text("checkPhoneNumberVerificationCode"),
                context,
                6);
            verificationId = verificationId;

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterVerifyPinPage(
                    user: user, verificationId: verificationId)));
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
    isWaiting = false;
  }

  Future<void> _fblogin() async {
    setState(() {
      isWaiting = true;
    });
    String token = await checkToken(fcmtoken);
    await context.read<LoginProvider>().fbLogin(context, token);
    // setState(() {
    //   isWaiting = false;
    // });
    isWaiting = false;
  }

  Future<void> _googlelogin() async {
    setState(() {
      isWaiting = true;
    });
    String token = await checkToken(fcmtoken);
    await context.read<LoginProvider>().googleLogin(context, token);
    // setState(() {
    //   isWaiting = false;
    // });
    isWaiting = false;
  }

  String prettyPrint(Map json) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
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
