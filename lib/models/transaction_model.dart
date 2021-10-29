// @dart=2.9

class TransactionModel {
  String uid;
  String type;
  String paymentType;
  int amount;
  DateTime createdDate;
  String imageUrl;
  int transactionId;


  TransactionModel({
    this.uid,
    this.type,
    this.paymentType,
    this.amount,
    this.createdDate,
    this.imageUrl,
    this.transactionId
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    type = json['type'];
    paymentType = json['paymentType'];
    amount = json['amount'];
    createdDate =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));
    imageUrl= json['imageUrl'];
    transactionId= json['transactionId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['paymentType'] = this.paymentType;
    data['amount'] = this.amount;
    data['createdDate'] = this.createdDate.microsecondsSinceEpoch.toString();
   data['imageUrl'] = this.imageUrl;
   data['transactionId'] = this.transactionId;
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
