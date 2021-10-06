// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/apis/smsApi.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key key}) : super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  String phoneNumber = "";
  SmsApi _smsApi = SmsApi();

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
                            FlutterLogo(
                              size: 180,
                            ),
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
                                        // validator: (val) {
                                        //   return Validator.phone(
                                        //       val.toString());
                                        // },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Phone number",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
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
                                  print("Pressed");
                                  _formKey.currentState.validate();

                                  // if (!_formKey.currentState.validate()) {
                                  // print("Not");
                                  // return;
                                  // } else {
                                  print("OK");

                                  phoneNumber = _phoneController.text;
                                  _smsApi.requestPin(phoneNumber);
                                },
                                child: Text(
                                  "Add Phone Number",
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
