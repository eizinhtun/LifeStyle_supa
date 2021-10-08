// @dart=2.9
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/pages/register.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/validators/validator.dart';
import 'facebook_user_info_screen.dart';
import 'user_info_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginformKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AccessToken _accessToken;
  String lang = "en";

  Color langEnBtnColor = Colors.black38;
  Color langMyBtnColor = Colors.black38;
  Color langZhBtnColor = Colors.black38;

  @override
  void initState() {
    super.initState();

    getLang();
  }

  getLang() async {
    lang = await DatabaseHelper.getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    // Tran.of(context).text('login');
    changeLangColor();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          "assets/icon/icon.png",
                        )),
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
                                controller: _phoneController,
                                validator: (val) {
                                  return Validator.registerPhone(
                                      val.toString());
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: Tran.of(context)?.text("phone"),
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                validator: (val) {
                                  return Validator.password(context,
                                      val.toString(), "Password", true);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        Tran.of(context)?.text("password"),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
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
                        onPressed: () {
                          _loginformKey.currentState.validate();

                          if (!_loginformKey.currentState.validate()) {
                            print("Not");
                            return;
                          } else {}
                        },
                        child: Text(
                          "Login",
                          // Tran.of(context)?.text('login'),
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
                        "Login With",
                        // Tran.of(context).text("login_with"),
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
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text(
                        "Forgot Password",
                        // Tran.of(context)?.text("forgot_password"),
                        style:
                            TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        "Register Now",
                        // Tran.of(context)?.text("register_now"),
                        style:
                            TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            print("Myanmar Pressed");
                            await DatabaseHelper.setLanguage(context, "my");
                            setState(() {
                              lang = "my";
                            });
                          },
                          child: Text(
                            "မြန်မာ",
                            style: TextStyle(color: langMyBtnColor),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            print("English Pressed");
                            await DatabaseHelper.setLanguage(context, "en");
                            setState(() {
                              lang = "en";
                            });
                          },
                          child: Text(
                            "English",
                            style: TextStyle(color: langEnBtnColor),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            print("Chinese Pressed");
                            await DatabaseHelper.setLanguage(context, "zh");
                            setState(() {
                              lang = "zh";
                            });
                          },
                          child: Text(
                            "中文",
                            style: TextStyle(color: langZhBtnColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  changeLangColor() {
    switch (lang) {
      case "en":
        {
          langEnBtnColor = Color.fromRGBO(143, 148, 251, 1);
          langMyBtnColor = Colors.black38;
          langZhBtnColor = Colors.black38;
        }
        break;
      case "my":
        {
          langMyBtnColor = Color.fromRGBO(143, 148, 251, 1);
          langEnBtnColor = Colors.black38;
          langZhBtnColor = Colors.black38;
        }
        break;
      case "zh":
        {
          langZhBtnColor = Color.fromRGBO(143, 148, 251, 1);
          langEnBtnColor = Colors.black38;
          langMyBtnColor = Colors.black38;
        }
        break;
    }
  }

  Future<void> _fblogin() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      _printCredentials();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => FacebookUserInfoScreen()),
      );
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {});
  }

  Future<void> _googlelogin() async {
    User user = await Authentication.signInWithGoogle(context: context);

    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UserInfoScreen(user: user)),
      );
    }
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken.toJson()),
    );
  }

  String prettyPrint(Map json) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }
}
