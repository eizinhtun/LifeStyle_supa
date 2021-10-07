// @dart=2.9
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:left_style/models/OtpSms.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

// ignore: must_be_immutable
class OtpPage extends StatefulWidget {
  OtpPage({Key key, this.otpSms}) : super(key: key);
  OtpSms otpSms = OtpSms();

  @override
  _OtpPage createState() => _OtpPage();
}

class _OtpPage extends State<OtpPage> {
  String otp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.9,
        title: Center(
          child: Container(
              margin: EdgeInsets.only(right: 40), child: Text("Hello")),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001950),
              Color(0xFF04205a),
              Color(0xFF0b2b6a),
              Color(0xFF0b2b6a),
              Color(0xFF2253a2),
              Color(0xFF2253a2)
            ],
          )),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 10),
              alignment: Alignment.center,
              child: Text(
                "We sent an OTP code to your phone number",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
              alignment: Alignment.center,
              child: Text(
                widget.otpSms.number.toString().contains("+")
                    ? widget.otpSms.number.toString()
                    : ("+" + widget.otpSms.number.toString()),
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter OTP Code from SMS",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              height: 70,
              //padding: EdgeInsets.only(left: 20,right: 20,),
              child: OTPTextField(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 15,
                style: GoogleFonts.roboto(
                    fontSize: 17, fontStyle: FontStyle.normal),
                onChanged: (pin) {
                  otp = pin;
                  //print("Changed: " + pin);
                },
                onCompleted: (pin) {
                  //print("Completed: " + pin);
                  otp = pin;
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   padding: EdgeInsets.only(right: 30.0),
                  //   alignment: Alignment.center,
                  //   child:  Text("+"+
                  //     widget.otpSms.number.toString(),
                  //     style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey),
                  //   ),
                  // ),
                  ArgonTimerButton(
                    initialTimer: 120,
                    highlightColor: Colors.transparent,
                    highlightElevation: 0,
                    height: 40,
                    width: 100,
                    onTap: (startTimer, btnState) async {
                      if (btnState == ButtonState.Idle) {
                        // var returnResult = await context
                        //     .read<RegisterProvider>()
                        //     .getOtp(context, widget.otpSms.number.toString());
                        // if (returnResult != null) {
                        //   widget.otpSms.requestId = returnResult.requestId;
                        //   widget.otpSms.status = returnResult.status;
                        // }
                        // startTimer(120);
                      }
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    loader: (timeLeft) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: Text(
                          "$timeLeft",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                    borderRadius: 5.0,
                    color: Colors.transparent,
                    elevation: 0,
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.2), width: 1.5),
                  ),
                ],
              ),
            ),
            // context.watch<RegisterProvider>().verifingOtp
            //     ? Center(
            //         child: SpinKitWave(
            //           color: Colors.green,
            //           size: 30,
            //         ),
            //       )
            //     :
            Container(
              padding: EdgeInsets.only(top: 30),
              child: MaterialButton(
                // minWidth: 160,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minWidth: MediaQuery.of(context).size.width - 30,
                height: 43,
                color: Color(0xFF2456A6),
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),

                onPressed: () async {
                  if (otp.length < 6) {
                    MessageHandler.showError(
                        context, "", "Please fill with 6 digits!");
                    return;
                  } else {
                    // var data = await context
                    //     .read<RegisterProvider>()
                    //     .verifyOtp(context,
                    //         widget.otpSms.requestId.toString(), otp);
                    // if (data != null && data == true) {
                    // Navigator.push(
                    //     context,
                    //      MaterialPageRoute(
                    //       builder: (BuildContext context) =>
                    //        RegInfoPage(phoneNo:widget.otpSms.number.toString(),),
                    //     ));
                    // }
                  }
                  // set up the button
                  // show the dialog
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
