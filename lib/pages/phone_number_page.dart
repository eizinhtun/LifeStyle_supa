// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/apis/smsApi.dart';
import 'package:left_style/models/sms_request_model.dart';
import 'package:left_style/pages/verify_pin_page.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key key}) : super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    SmsApi _smsApi = SmsApi(this.context);
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

                                  print("OK");

                                  phoneNumber = _phoneController.text;
                                  SmsRequestModel requestModel =
                                      await _smsApi.requestPin(phoneNumber);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VerifyPinPage(
                                          requestId: requestModel.request_id)));
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
        ],
      ),
    );
  }
}
