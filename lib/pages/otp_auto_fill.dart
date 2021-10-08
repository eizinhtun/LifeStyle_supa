import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';

class OTPFill extends StatefulWidget {
  const OTPFill({Key? key}) : super(key: key);

  @override
  _OTPFillState createState() => _OTPFillState();
}

class _OTPFillState extends State<OTPFill> {
  late OTPTextEditController controller;
  final scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    OTPInteractor.getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 5,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          //SampleStrategy(),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await controller.stopListen();
    super.dispose();
  }
}
