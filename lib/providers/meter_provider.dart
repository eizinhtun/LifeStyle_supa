// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/meter_model.dart';
import 'package:left_style/utils/message_handler.dart';

class MeterProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var meterRef = FirebaseFirestore.instance.collection(meterCollection);

  Future<bool> addMeter(BuildContext context, Meter model) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      try {
        await meterRef.doc(uid).set(model.toJson());

        notifyListeners();
        return true;
      } catch (e) {
        MessageHandler.showErrMessage(
            context, "Fail", "Updating User Info is fail");
        return false;
      }
    }
    notifyListeners();
    return false;
  }

  Future<List<Meter>> getMeterList(BuildContext context) async {
    List<Meter> list = [];
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      try {
        await meterRef
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(userMeterCollection)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            list.add(Meter.fromJson(result.data()));
          });
        });
      } catch (e) {
        // MessageHandler.showErrMessage(context, "Fail", "Get meter list fail");
      }
    }
    notifyListeners();
    return list;
  }
}
