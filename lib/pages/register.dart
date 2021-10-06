// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/models/OtpSms.dart';
import 'package:left_style/providers/register_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';
import 'otpPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
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
                                          return Validator.phone(
                                              val.toString());
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Phone number",
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
                                        // validator: (val) {
                                        //   return Validator.phone(val.toString());
                                        // },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "User Name",
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
                                onPressed: () async {
                                  print("Pressed");
                                  _formKey.currentState.validate();

                                  // if (!_formKey.currentState.validate()) {
                                  // print("Not");
                                  // return;
                                  // } else {
                                  print("OK");
                                  phoneNumber = _phoneController.text;
                                  if (phoneNumber.startsWith("0")) {
                                    phoneNumber = phoneNumber.substring(
                                        1, phoneNumber.length);
                                  }
                                  phoneNumber = "+95" + phoneNumber;
                                  //}
                                  setState(() {});
                                  // set up the button
                                  // ignore: deprecated_member_use
                                  Widget okButton = FlatButton(
                                    child: Text("Next",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      // OtpSms obj = await context
                                      //     .read<RegisterProvider>()
                                      //     .getOtp(context, phoneNumber);
                                      // if (obj != null) {
                                      //   // openNextPage(obj);
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //             OtpPage(
                                      //           otpSms: obj,
                                      //         ),
                                      //       ));
                                      // }
                                      OtpSms obj = OtpSms();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                OtpPage(
                                              otpSms: obj,
                                            ),
                                          ));
                                      setState(() {});
                                    },
                                  );
                                  // ignore: deprecated_member_use
                                  Widget editButton = FlatButton(
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  );
                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Is this your phone number?",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Text(
                                          phoneNumber,
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      "The OTP code will send the the phone number ",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    actions: [
                                      editButton,
                                      okButton,
                                    ],
                                  );
                                  // show the dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                                child: Text(
                                  "Register",
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
              icon: Icon(
                  // Icons.keyboard_arrow_left_rounded,
                  Icons.arrow_back_ios,
                  // size: 30,
                  color: Colors.grey[900]),
              // color: Theme.of(context).primaryColor,
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
