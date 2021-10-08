// @dart=2.9
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:left_style/apis/smsApi.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'dart:async';

class FirebaseVerifyPinPage extends StatefulWidget {
  const FirebaseVerifyPinPage({Key key, @required this.requestId})
      : super(key: key);
  final int requestId;

  @override
  _FirebaseVerifyPinPageState createState() => _FirebaseVerifyPinPageState();
}

class _FirebaseVerifyPinPageState extends State<FirebaseVerifyPinPage>
    with CodeAutoFill {
  String otp = "123456";

  String appSignature = "{{app signature}}";
  TextEditingController textEditingController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  @override
  void codeUpdated() {
    setState(() {
      otp = code;
      textEditingController.text = otp;
    });
  }

  // late OTPTextEditController controller;
  @override
  void initState() {
    super.initState();
    // super.initState();
    // OTPInteractor.getAppSignature()
    //     //ignore: avoid_print
    //     .then((value) => print('signature - $value'));
    // controller = OTPTextEditController(
    //   codeLength: 5,
    //   //ignore: avoid_print
    //   onCodeReceive: (code) => print('Your Application receive code - $code'),
    // )..startListenUserConsent(
    //     (code) {
    //       final exp = RegExp(r'(\d{5})');
    //       return exp.stringMatch(code ?? '') ?? '';
    //     },
    //     strategies: [
    //       SampleStrategy(),
    //     ],
    //   );
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = "lifestyle-f0e4e.firebaseapp.com";
        // signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SmsApi _smsApi = SmsApi(context);
    return Scaffold(
      key: _scaffoldKey,
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
                            Text("App Signature : $appSignature"),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: 50,
                                  minWidth: double.infinity,
                                  maxHeight: 400),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // loginUser("09401531039", context);
                                  await verify("+959970376826");
                                },
                                child: Text(
                                  "Verify Phone",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _smsController,
                              decoration: const InputDecoration(
                                  labelText: 'Verification code'),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 16.0),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                  color: Colors.greenAccent[200],
                                  onPressed: () async {
                                    signInWithPhoneNumber();
                                  },
                                  child: Text("Sign in")),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: 50,
                                  minWidth: double.infinity,
                                  maxHeight: 400),
                              child: ElevatedButton(
                                onPressed: () async {
                                  print("Pressed");
                                  otp = "135796";
                                  setState(() {});
                                  _smsApi.sendMessage(
                                      "09401531039", appSignature, otp);
                                },
                                child: Text(
                                  "Send Message",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            otp == null
                                ? Text(
                                    "Listening for code...",
                                  )
                                : Text(
                                    "Code Received: $otp",
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              // obscuringCharacter: '*',
                              // obscuringWidget: FlutterLogo(
                              //   size: 24,
                              // ),
                              // blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v.length < 3) {
                                  return "I'm from validator";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                              ),
                              cursorColor: Colors.black,
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                print("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 70,
                              child: OTPTextField(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 45,
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 15,
                                style: GoogleFonts.roboto(
                                    fontSize: 17, fontStyle: FontStyle.normal),
                                onChanged: (pin) {
                                  otp = pin;
                                },
                                onCompleted: (pin) {
                                  otp = pin;
                                },
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
                                  _smsApi.verifyPin(
                                      widget.requestId, int.parse(otp));
                                },
                                child: Text(
                                  "Verify Pin",
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
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey[900]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  final _codeController = TextEditingController();

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '+95 401531039',
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
    );
  }

// Future registerUser(String mobile, BuildContext context) async{

//   FirebaseAuth _auth = FirebaseAuth.instance;

//   _auth.verifyPhoneNumber(
//     phoneNumber: mobile,
//     timeout: Duration(seconds: 60),
//     verificationCompleted: (AuthCredential authCredential){
// _auth.signInWithCredential(_credential).then((UserCredential result){
// // Navigator.pushReplacement(context, MaterialPageRoute(
// //     builder: (context) => HomeScreen(result.user)
// //   ));
// }).catchError((e){
//   print(e);
// });
// },
// verificationFailed: (FirebaseAuthException authException){
//   print(authException.message);
// },
// codeSent:(String verificationId, [int forceResendingToken]){
//   //show dialog to take input from the user
//   showDialog(
//   context: context,
//   barrierDismissible: false,
//   builder: (context) => AlertDialog(
//     title: Text("Enter SMS Code"),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         TextField(
//           controller: _codeController,
//         ),

//       ],
//     ),
//     actions: <Widget>[
//       FlatButton(
//         child: Text("Done"),
//         textColor: Colors.white,
//         color: Colors.redAccent,
//         onPressed: () {
//           FirebaseAuth auth = FirebaseAuth.instance;

//           smsCode = _codeController.text.trim();

//           _credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
//           auth.signInWithCredential(_credential).then((UserCredential result){
//             Navigator.pushReplacement(context, MaterialPageRoute(
//               builder: (context) => HomeScreen(result.user)
//             ));
//           }).catchError((e){
//             print(e);
//           });
//         },
//       )
//     ],
//   )
// );
// },
// codeAutoRetrievalTimeout: (String verificationId){
//   verificationId = verificationId;
//   print(verificationId);
//   print("Timout");
// }
// );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Force reCAPTCHA flow
// auth.getFirebaseAuthSettings().forceRecaptchaFlowForTesting();
  String _verificationId = "";

// void signInWithPhoneNumber() async {
//   try {
//     final AuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: _smsController.text,
//     );

//     final User user = (await _auth.signInWithCredential(credential)).user;

//     showSnackbar("Successfully signed in UID: ${user.uid}");
//   } catch (e) {
//     showSnackbar("Failed to sign in: " + e.toString());
//   }
// }
  Future<void> verify(String phone) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 5),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
            showSnackbar(
                "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
          },
          verificationFailed: (FirebaseAuthException authException) {
            showSnackbar(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            showSnackbar('Please check your phone for the verification code.');
            _verificationId = verificationId;
            _smsController.text = _verificationId.toString();
          },
          // codeSent,
          codeAutoRetrievalTimeout: (String verificationId) {
            showSnackbar("verification code: " + verificationId);
            _verificationId = verificationId;
          });
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
    }
    // await _auth.signInWithPhoneNumber(phoneController.text, recaptchaVerifier).then((confirmationResult) {
    //     // SMS sent. Prompt user to type the code from the message, then sign the
    //     // user in with confirmationResult.confirm(code).
    //     setState(() {
    //       verificationId = confirmationResult.verificationId;
    //     });
    //   }).catchError((error) {
    //     print(error);
    //   });
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 6),
    ));
  }

  void signInWithPhoneNumber() async {
    // var recaptchaVerifier = RecaptchaVerifier(
    //   container: null,
    //   size: RecaptchaVerifierSize.compact,
    //   theme: RecaptchaVerifierTheme.dark,
    //   onSuccess: () async {
    //     print('reCAPTCHA Completed!');
    //     // setState(() {
    //     //   currentInput = "otp";
    //     //   _isLoading = false;
    //     // });
    //   },
    //   onError: (FirebaseAuthException error) async {
    //     print("error");
    //     print(error);
    //     // setState(() {
    //     //   _isLoading = false;
    //     // });
    //     _scaffoldKey.currentState
    //         .showSnackBar(SnackBar(content: Text(error.message)));
    //   },
    //   onExpired: () async {
    //     print('reCAPTCHA Expired!');
    //     // setState(() {
    //     //   _isLoading = false;
    //     // });
    //   },
    // );

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      showSnackbar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      print(e.toString());
      showSnackbar("Failed to sign in: " + e.toString());
    }
  }
}
