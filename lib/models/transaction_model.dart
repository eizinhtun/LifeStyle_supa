// @dart=2.9
enum TransactionType { Topup, Withdraw }
enum PaymentType { KPay, CbPay, WavePay }

class TransactionModel {
  String uid;
  TransactionType type;
  PaymentType paymentType;
  double amount;

  TransactionModel({
    this.uid,
    this.type,
    this.paymentType,
    this.amount,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    type = getType(json['type']);
    paymentType = getPayType(json['paymentType']);
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['type'] = getString(this.type);
    data['paymentType'] = getPayString(this.paymentType);
    data['amount'] = this.amount;
    return data;
  }

  TransactionType getType(String s) {
    TransactionType type = TransactionType.Topup;
    switch (s) {
      case "Topup":
        type = TransactionType.Topup;
        break;
      case "Withdraw":
        type = TransactionType.Withdraw;
        break;
    }
    return type;
  }

  String getString(TransactionType type) {
    String s = "Topup";
    switch (type) {
      case TransactionType.Topup:
        s = "Topup";
        break;
      case TransactionType.Withdraw:
        s = "Withdraw";
        break;
    }
    return s;
  }

  PaymentType getPayType(String s) {
    PaymentType type = PaymentType.CbPay;
    switch (s) {
      case "KPay":
        type = PaymentType.KPay;
        break;
      case "CbPay":
        type = PaymentType.CbPay;
        break;
      case "WavePay":
        type = PaymentType.WavePay;
        break;
    }
    return type;
  }

  String getPayString(PaymentType type) {
    String s = "KPay";
    switch (type) {
      case PaymentType.KPay:
        s = "KPay";
        break;
      case PaymentType.CbPay:
        s = "CbPay";
        break;
      case PaymentType.WavePay:
        s = "WavePay";
        break;
    }
    return s;
  }
}
