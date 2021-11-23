// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _profileformKey = GlobalKey<FormState>();
  bool _obscureText = true;
  // bool isEnabled = true;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isPhoneToken = false;
  User _user;

  String fcmtoken = "";
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _phoneController.text = _user.phoneNumber;
    _nameController.text = _user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Center(
              child: Text(
                "User Profile",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
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
                              /*   Container(
                                padding: EdgeInsets.all(4),
                                child: Center(
                                  child: Text(
                                    "Add User Profile",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                ),
                              ),*/
                              Form(
                                key: _profileformKey,
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
                                          // enabled: isEnabled,
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
                                    minHeight: 60,
                                    minWidth: double.infinity,
                                    maxHeight: 400),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.grey,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 15),
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () async {
                                        await context
                                            .read<LoginProvider>()
                                            .logOut(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                      ),
                                      onPressed: () async {
                                        // bool isTaken = await checkPhoneIsTaken();
                                        // phone = phNoFormat();
                                        // if (!isTaken) {
                                        //   register();
                                        // }
                                        if (_profileformKey.currentState
                                            .validate()) {
                                          var pass = DBCrypt().hashpw(
                                              _passwordController.text,
                                              DBCrypt().gensalt());
                                          // var isCorrect = new DBCrypt().checkpw(plain, hashed);

                                          String token =
                                              await checkToken(fcmtoken);
                                          UserModel userModel = UserModel(
                                              uid: _user.uid,
                                              fullName: _nameController.text
                                                  .toString(),
                                              phone: Formatter.formatPhone(
                                                  _phoneController.text
                                                      .toString()),
                                              password: pass,
                                              photoUrl: _user.photoURL,
                                              email: _user.email,
                                              balance: 0,
                                              showBalance: false,
                                              address: "",
                                              fcmtoken: token,
                                              isActive: true,
                                              createdDate: Timestamp.fromDate(
                                                  DateTime.now()));
                                          print(userModel);
                                          await context
                                              .read<LoginProvider>()
                                              .updateUserInfo(
                                                  context, userModel);
                                        }
                                      },
                                      child: Text(
                                        "Add User Profile",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  // child: ElevatedButton(
                                  //   onPressed: () async {
                                  //     // bool isTaken = await checkPhoneIsTaken();
                                  //     // phone = phNoFormat();
                                  //     // if (!isTaken) {
                                  //     //   register();
                                  //     // }
                                  //     var pass = DBCrypt().hashpw(
                                  //         _passwordController.text,
                                  //         DBCrypt().gensalt());
                                  //     // var isCorrect = new DBCrypt().checkpw(plain, hashed);
                                  //     UserModel userModel = UserModel(
                                  //         uid: FirebaseAuth
                                  //             .instance.currentUser.uid,
                                  //         fullName:
                                  //             _nameController.text.toString(),
                                  //         phone: phNoFormat(),
                                  //         password: pass,
                                  //         isActive: true,
                                  //         createdDate: DateTime.now());
                                  //     await context
                                  //         .read<LoginProvider>()
                                  //         .addUserProfile(context, userModel);
                                  //   },
                                  //   child: Text(
                                  //     "Add User Profile",
                                  //     style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),

                                  // ),
                                  // ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
