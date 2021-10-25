// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/models/Meter.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/validators/validator.dart';
import 'package:left_style/widgets/wallet.dart';

class MeterProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var meterRef = FirebaseFirestore.instance.collection(meterCollection);




  Future<bool> AddMeter(BuildContext context, Meter model) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      try {
       await meterRef.doc(uid).set(model.toJson());
       return true;
        notifyListeners();
      } catch (e) {
        return false;
        print("Failed to update user: $e");
        MessageHandler.showErrMessage(
            context, "Fail", "Updating User Info is fail");
      }
    }
    notifyListeners();
  }


}
