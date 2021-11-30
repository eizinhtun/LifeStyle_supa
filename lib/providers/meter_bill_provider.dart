// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_bill_model.dart';
import 'package:left_style/utils/message_handler.dart';

class MeterBillProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var meterBillRef =
      FirebaseFirestore.instance.collection(meterBillsCollection);

  // .collection(meterBillsCollection).doc(widget.docId).snapshots(),

  Future<bool> updateMeterBill(
      BuildContext context, MeterBill bill, String docId) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      try {
        await meterBillRef.doc(docId).set(bill.toJson());

        notifyListeners();
        return true;
      } catch (e) {
        MessageHandler.showErrMessage(context, Tran.of(context).text("fail"),
            Tran.of(context).text("update_user_fail"));
        return false;
      }
    }
    notifyListeners();
    return false;
  }
}
