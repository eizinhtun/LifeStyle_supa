// @dart=2.9
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier, DiagnosticableTreeMixin {
  LoginProvider() {}

  Future<void> logOut(BuildContext context) async {
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {}
}
