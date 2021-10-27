// // @dart=2.9
// class TestModel {
//   String uid;
//   String fullName;
//   String email;
//   String phone;
//   String address;
//
//   TestModel({
//     this.fullName,
//     this.email,
//     this.phone,
//     this.uid,
//     this.address,
//   });
//
//   TestModel.fromJson(Map<String, dynamic> json) {
//     fullName = json['full_name'];
//     phone = json['phone'];
//     email = json['email'];
//     uid = json['uid'];
//     address = json['address'];
//     //  DateTime.parse(json['createdDate']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['full_name'] = this.fullName;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['uid'] = this.uid;
//     data['address'] = this.address;
//     return data;
//   }
// }
// @dart=2.9
// enum TestType { Topup, Withdraw }
// enum PaymentType { KPay, CbPay, WavePay }

class TestModel {
  String uid;
  String type;
  String paymentType;
  double amount;
  DateTime createdDate;

  TestModel({
    this.uid,
    this.type,
    this.paymentType,
    this.amount,
    this.createdDate,
  });

  TestModel.fromJson(Map<String, dynamic> json) {
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

  // TestType getType(String s) {
  //   TestType type = TestType.Topup;
  //   switch (s) {
  //     case "Topup":
  //       type = TestType.Topup;
  //       break;
  //     case "Withdraw":
  //       type = TestType.Withdraw;
  //       break;
  //   }
  //   return type;
  // }

  // String getString(TestType type) {
  //   String s = "Topup";
  //   switch (type) {
  //     case TestType.Topup:
  //       s = "Topup";
  //       break;
  //     case TestType.Withdraw:
  //       s = "Withdraw";
  //       break;
  //   }
  //   return s;
  // }

  // PaymentType getPayType(String s) {
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

  // String getPayString(PaymentType type) {
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
