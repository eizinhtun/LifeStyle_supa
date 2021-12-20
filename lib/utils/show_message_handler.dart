import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:left_style/localization/translate.dart';

class ShowMessageHandler {
  static showError(BuildContext context, String title, String msg) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.red, //.withOpacity(0.9),
      margin: const EdgeInsets.only(top: 200.0, left: 10.0, right: 10.0),
      message: msg,

      duration: Duration(seconds: 3),

      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
    //if(msg.contains(other))
  }

  static copy(BuildContext context, String msg) async {
    ClipboardData data = ClipboardData(text: msg);
    await Clipboard.setData(data);
    //await  Clipboard.setData(ClipboardData(text: msg));
    // ClipboardData cb = await Clipboard.getData('text/plain');
    // print(cb);
    // Clipboard.setData(ClipboardData(text: msg));
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      // title: title,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.only(top: 300.0, left: 10.0, right: 10.0),
      message: msg + " " + Tran.of(context).text("copy_success"),

      duration: Duration(seconds: 1),
      backgroundColor: Colors.black45,
      icon: Icon(
        Icons.info,
        color: Colors.black,
      ),
    )..show(context);
  }

  static showMessage(BuildContext context, String title, String msg) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      title: title,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.only(top: 300.0, left: 10.0, right: 10.0),
      message: msg,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
  }

  static showErrMessage(BuildContext context, String title, String msg) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      title: title,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.only(top: 300.0, left: 10.0, right: 10.0),
      message: msg,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
  }

  static void showErrSnackbar(
      String message, BuildContext context, int durationInSecs) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.red, //.withOpacity(0.9),
      margin: const EdgeInsets.only(top: 200.0, left: 10.0, right: 10.0),
      message: message,

      duration: Duration(seconds: durationInSecs),

      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
  }

  static void showSnackbar(
      String message, BuildContext context, int durationInSecs) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.green, //.withOpacity(0.9),
      margin: const EdgeInsets.only(top: 200.0, left: 10.0, right: 10.0),
      message: message,

      duration: Duration(seconds: durationInSecs),

      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
  }
}
