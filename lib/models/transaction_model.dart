// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String docId;
  String uid;
  String type;
  String paymentType;
  int amount;
  Timestamp createdDate;
  String imageUrl;
  String status;
  String transactionId;
  String transferAccount;
  String paymentLogoUrl;

  TransactionModel(
      {this.uid,
      this.type,
      this.status,
      this.paymentType,
      this.amount,
      this.createdDate,
      this.imageUrl,
      this.transactionId,
      this.transferAccount,
      this.paymentLogoUrl});

  TransactionModel.fromJson(Map<String, dynamic> json, {String doc}) {
    docId = doc;
    uid = json['uid'];
    type = json['type'];
    paymentType = json['paymentType'];
    amount = json['amount'];
    //   Timestamp createdDatetimestamp = json['createdDate'];
    // createdDate = createdDatetimestamp.toDate();
    createdDate = json['createdDate']; // Timestamp.fromDate();
    status = json['status'] ?? "verifying";
    // DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));

    //DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));
    imageUrl = json['imageUrl'];
    transactionId = json['transactionId'];

    //DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));
    imageUrl = json['imageUrl'];
    transactionId = json['transactionId'];
    transferAccount = json['transferAccount'];
    paymentLogoUrl = json['paymentLogoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['paymentType'] = this.paymentType;
    data['amount'] = this.amount;
    data['createdDate'] = this.createdDate;
    data['imageUrl'] = this.imageUrl;
    data['transactionId'] = this.transactionId;
    data['status'] = this.status;
    data['transferAccount'] = this.transferAccount;
    data['paymentLogoUrl'] = this.paymentLogoUrl;
    return data;
  }

  // TransactionType getType(String s) {
  //   TransactionType type = TransactionType.Topup;
  //   switch (s) {
  //     case "Topup":
  //       type = TransactionType.Topup;
  //       break;
  //     case "Withdraw":
  //       type = TransactionType.Withdraw;
  //       break;
  //   }
  //   return type;
  // }

  // String getString(TransactionType type) {
  //   String s = "Topup";
  //   switch (type) {
  //     case TransactionType.Topup:
  //       s = "Topup";
  //       break;
  //     case TransactionType.Withdraw:
  //       s = "Withdraw";
  //       break;
  //   }
  //   return s;
  // }

  // PaymentType String s) {
  //   PaymentType type = PaymentType.CbPay;
  //   switch (s) {
  //     case "KPay":
  //       type = PaymentType.KPay;
  //       break;
  //     case "CbPay":
  //       type = PaymentType.CbPay;
  //       break;
  //     case "WavePay":
  //       type = PaymentType.WavePay;
  //       break;
  //   }
  //   return type;
  // }

  // String PaymentType type) {
  //   String s = "KPay";
  //   switch (type) {
  //     case PaymentType.KPay:
  //       s = "KPay";
  //       break;
  //     case PaymentType.CbPay:
  //       s = "CbPay";
  //       break;
  //     case PaymentType.WavePay:
  //       s = "WavePay";
  //       break;
  //   }
  //   return s;
  // }
}
