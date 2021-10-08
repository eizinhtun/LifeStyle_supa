// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/pages/verify_pin_page.dart';
import 'package:left_style/validators/validator.dart';

import 'firebase_verify_pin_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerformKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _confirmObscureText = true;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String phoneNumber = "";
  bool isPhoneToken = false;

  var userRef = FirebaseFirestore.instance.collection(userCollection);

  @override
  Widget build(BuildContext context) {
    // SmsApi _smsApi = SmsApi(this.context);
    return Scaffold(
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
                              CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                    "assets/icon/icon.png",
                                  )),
                              SizedBox(
                                height: 20,
                              ),
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
                                          controller: _phoneController,
                                          validator: (val) {
                                            String data =
                                                Validator.showPhoneToken(
                                                    isPhoneToken);
                                            if (data != "") {
                                              return data;
                                            }
                                            return Validator.registerPhone(
                                                val.toString());
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: Tran.of(context)
                                                  .text('phone'),
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
                                              hintText: Tran.of(context)
                                                  .text('full_name'),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
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
                                              hintText: Tran.of(context)
                                                  .text('password'),
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
                                          controller:
                                              _confirmPasswordController,
                                          obscureText: _confirmObscureText,
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
                                              hintText: Tran.of(context)
                                                  .text('confirm_password'),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _confirmObscureText =
                                                        !_confirmObscureText;
                                                  });
                                                },
                                                child: Icon(_confirmObscureText
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
                                    register();
                                  },
                                  child: Text(
                                    Tran.of(context).text('register'),
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

  void register() async {
    phoneNumber = _phoneController.text;
    // isPhoneToken = await Validator.checkUserIsExist(phoneNumber);

    // if (phoneNumber.startsWith("0")) {
    //   phoneNumber = phoneNumber.substring(1, phoneNumber.length);
    // }
    // phoneNumber = "+95" + phoneNumber;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VerifyPinPage()));

    // if (_registerformKey.currentState.validate()) {
    //   print("Validate");
    //   var pass = new DBCrypt()
    //       .hashpw(_passwordController.text, new DBCrypt().gensalt());
    //   // var isCorrect = new DBCrypt().checkpw(plain, hashed);
    //   userRef
    //       .add({
    //         'full_name': _nameController.text,
    //         'phone': _phoneController.text,
    //         'password': pass
    //       })
    //       .then((value) => print("User Added $value"))
    //       .catchError((error) => print("Failed to add user: $error"));
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => VerifyPinPage()));
    // }
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



                                    // phoneNumber = _phoneController.text;
                                    //   SmsRequestModel requestModel =
                                    //       await _smsApi.requestPin(phoneNumber);
                                    //   Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               VerifyPinPage(
                                    //                   requestId: requestModel
                                    //                       .requestId)));
                                    // }
                                    // print("OK");
                                    // phoneNumber = _phoneController.text;
                                    // if (phoneNumber.startsWith("0")) {
                                    //   phoneNumber = phoneNumber.substring(
                                    //       1, phoneNumber.length);
                                    // }
                                    // phoneNumber = "+95" + phoneNumber;
                                    // //}
                                    // setState(() {});
                                    // set up the button
                                    // ignore: deprecated_member_use
                                    // Widget okButton = FlatButton(
                                    //   child: Text("Next",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold)),
                                    //   onPressed: () async {
                                    //     Navigator.of(context).pop();
                                    //     // OtpSms obj = await context
                                    //     //     .read<RegisterProvider>()
                                    //     //     .getOtp(context, phoneNumber);
                                    //     // if (obj != null) {
                                    //     //   // openNextPage(obj);
                                    //     //   Navigator.push(
                                    //     //       context,
                                    //     //       MaterialPageRoute(
                                    //     //         builder: (BuildContext context) =>
                                    //     //             OtpPage(
                                    //     //           otpSms: obj,
                                    //     //         ),
                                    //     //       ));
                                    //     // }
                                    //     // OtpSms obj = OtpSms();
                                    //     // Navigator.push(
                                    //     //     context,
                                    //     //     MaterialPageRoute(
                                    //     //       builder: (BuildContext context) =>
                                    //     //           OtpPage(
                                    //     //         otpSms: obj,
                                    //     //       ),
                                    //     //     ));
                                    //     // setState(() {});
                                    //     phoneNumber = _phoneController.text;
                                    //     SmsRequestModel requestModel =
                                    //         await _smsApi.requestPin(phoneNumber);
                                    //     Navigator.of(context).push(
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 VerifyPinPage(
                                    //                     requestId: requestModel
                                    //                         .requestId)));
                                    //   },
                                    // );
                                    // // ignore: deprecated_member_use
                                    // Widget editButton = FlatButton(
                                    //   child: Text(
                                    //     "Edit",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    //   onPressed: () =>
                                    //       Navigator.of(context).pop(),
                                    // );
                                    // // set up the AlertDialog
                                    // AlertDialog alert = AlertDialog(
                                    //   title: Column(
                                    //     mainAxisSize: MainAxisSize.max,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       Padding(
                                    //         padding: const EdgeInsets.all(8.0),
                                    //         child: Text(
                                    //           "Is this your phone number?",
                                    //           style: TextStyle(
                                    //               fontSize: 16,
                                    //               color: Colors.grey),
                                    //         ),
                                    //       ),
                                    //       Text(
                                    //         phoneNumber,
                                    //         style: TextStyle(
                                    //             fontSize: 20, color: Colors.blue),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   content: Text(
                                    //     "The OTP code will send the the phone number ",
                                    //     style: TextStyle(
                                    //         fontSize: 14, color: Colors.grey),
                                    //   ),
                                    //   actions: [
                                    //     editButton,
                                    //     okButton,
                                    //   ],
                                    // );
                                    // // show the dialog
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return alert;
                                    //   },
                                    // );