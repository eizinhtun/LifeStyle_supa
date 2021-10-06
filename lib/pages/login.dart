// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:left_style/pages/register.dart';
import 'package:left_style/pages/sign_in_screen.dart';
import 'package:left_style/validators/validator.dart';

import 'facebook_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          // FlutterLogo(
                          //   size: 180,
                          // ),

                          CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                "assets/icon/icon.png",
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
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
                                      controller: _phoneController,
                                      validator: (val) {
                                        return Validator.phone(val.toString());
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email or Phone number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
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
                              onPressed: () {
                                // _formKey.currentState.validate();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              "Login With",
                              style: TextStyle(color: Colors.black26),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FacebookLoginPage(),
                                        ));
                                    //write method
                                  },
                                  icon: Icon(Icons.facebook),
                                  iconSize: 50,
                                  color: Color(0xff3b5998),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignInScreen(),
                                        ));
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
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Container(
                                width: 1,
                                height: 15,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                                },
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  //for facebook login
  // bool isLoggedIn = false;
  // bool isLoading = false;
  // var profileData;
  // var facebookLogin = FacebookLogin();
  // void initiateFacebookLogin() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var facebookLoginResult = await facebookLogin.logIn(['email']);
  //   // logInWithReadPermissions(['email']);

  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.error:
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       var graphResponse = await http.get(Uri.parse(
  //           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}'));

  //       var profile = json.decode(graphResponse.body);
  //       print(profile.toString());

  //       onLoginStatusChanged(true, profileData: profile);
  //       break;
  //   }
  // }

  // void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
  //   setState(() {
  //     isLoading = false;
  //     this.isLoggedIn = isLoggedIn;
  //     this.profileData = profileData;
  //   });
  // }

}
