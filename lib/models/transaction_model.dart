// @dart=2.9

import 'package:left_style/datas/constants.dart';

class TransactionModel {
  String uid;
  String type;
  String paymentType;
  var amount;
  DateTime createdDate;

  TransactionModel({
    this.uid,
    this.type,
    this.paymentType,
    this.amount,
    this.createdDate,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    type = json['type'];
    paymentType = json['paymentType'];
    amount = json['amount'];
    createdDate =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['paymentType'] = this.paymentType;
    data['amount'] = this.amount;
    data['createdDate'] = this.createdDate.microsecondsSinceEpoch.toString();
    return data;
  }
}
