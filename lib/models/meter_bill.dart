// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class MeterBill {
  bool isPaid;
  Timestamp payDate;
  String remark;
  String readImageUrl;
  Timestamp readDate;
  String status;

  String block;

  String street;

  String billNo;

  String ledgerNo;

  String ledgerPostFix;

  String mainLedgerTitle;

  String layerDes1;

  int layerRate1;

  int layerAmount1;

  String layerDes2;

  int layerRate2;

  int layerAmount2;

  int oldUnit;

  String layerDes3;

  int layerRate3;

  int layerAmount3;

  String layerDes4;

  int layerRate4;

  int layerAmount4;

  int totalUnitUsed;

  String layerDes5;

  int layerRate5;

  int layerAmount5;

  int multiplier;

  String layerDes6;

  int layerRate6;

  int layerAmount6;

  double percentage;

  String layerDes7;

  int layerRate7;

  int layerAmount7;

  int unitsToPay;

  int mHorsePower;

  int cost;

  int mMaintenanceCost;

  int mHorsePowerCost;

  int totalCostOrg;

  int creditAmount;

  int disscountAmt;

  int totalCost;

  String signUrl;

  int refundAmount;

  String hotline;

  String companyName;

  String state;

  Timestamp dueDate;

  String monthName;

  String consumerName;

  String customerId;

  String meterNo;

  int readUnit;
  MeterBill(
      {this.isPaid,
      this.remark,
      this.payDate,
      this.status,
      this.readDate,
      this.readImageUrl,
      this.block,
      this.street,
      this.billNo,
      this.ledgerNo,
      this.ledgerPostFix,
      this.mainLedgerTitle,
      this.layerDes1,
      this.layerDes2,
      this.layerDes3,
      this.layerDes4,
      this.layerDes5,
      this.layerDes6,
      this.layerDes7,
      this.layerRate1,
      this.layerRate2,
      this.layerRate3,
      this.layerRate4,
      this.layerRate5,
      this.layerRate6,
      this.layerRate7,
      this.layerAmount1,
      this.layerAmount2,
      this.layerAmount3,
      this.layerAmount4,
      this.layerAmount5,
      this.layerAmount6,
      this.layerAmount7,
      this.oldUnit,
      this.totalUnitUsed,
      this.multiplier,
      this.unitsToPay,
      this.mHorsePower,
      this.cost,
      this.mHorsePowerCost,
      this.totalCostOrg,
      this.creditAmount,
      this.disscountAmt,
      this.totalCost,
      this.signUrl,
      this.refundAmount,
      this.hotline,
      this.companyName,
      this.state,
      this.monthName,
      this.consumerName,
      this.customerId,
      this.meterNo,
      this.dueDate,
      this.readUnit});

  MeterBill.fromJson(Map<String, dynamic> json,{String meterName}) {
    // print(json['isPaid']);
    // print(json['isPaid'] == false);
    meterName=meterName;
    isPaid = json['isPaid'];
    remark = json['remark'];
    payDate = json['payDate'];
    status = json['status'] == null ? "Unpaid" : json['status'];
    readDate = json['readDate'];
    readImageUrl = json['readImageUrl'];
    block = json['block'];
    dueDate = json['dueDate'];
    street = json['street'];
    billNo = json['billNo'];
    ledgerNo = json['ledgerNo'];
    ledgerPostFix = json['ledgerPostFix'];
    mainLedgerTitle = json['mainLedgerTitle'];
    layerDes1 = json['layerDes1'];
    layerDes2 = json['layerDes2'];
    layerDes3 = json['layerDes3'];
    layerDes4 = json['layerDes4'];
    layerDes5 = json['layerDes5'];
    layerDes6 = json['layerDes6'];
    layerDes7 = json['layerDes7'];
    layerRate1 = json['layerRate1'];
    layerRate2 = json['layerRate2'];
    layerRate3 = json['layerRate3'];
    layerRate4 = json['layerRate4'];
    layerRate5 = json['layerRate5'];
    layerRate6 = json['layerRate6'];
    layerRate7 = json['layerRate7'];
    layerAmount1 = json['layerAmount1'];
    layerAmount2 = json['layerAmount2'];
    layerAmount3 = json['layerAmount3'];
    layerAmount4 = json['layerAmount4'];
    layerAmount5 = json['layerAmount5'];
    layerAmount6 = json['layerAmount6'];
    layerAmount7 = json['layerAmount7'];
    oldUnit = json['oldUnit'];
    totalUnitUsed = json['totalUnitUsed'];
    multiplier = json['multiplier'];
    unitsToPay = json['unitsToPay'];
    mHorsePower = json['mHorsePower'];
    cost = json['cost'];

    mHorsePowerCost = json['mHorsePowerCost'];
    totalCostOrg = json['totalCostOrg'];
    creditAmount = json['creditAmount'];
    disscountAmt = json['disscountAmt'];
    totalCost = json['totalCost'];
    signUrl = json['signUrl'];
    refundAmount = json['refundAmount'];
    hotline = json['hotline'];
    companyName = json['companyName'];
    state = json['state'];
    monthName = json['monthName'];
    consumerName = json['consumerName'];
    customerId = json['customerId'];
    meterNo = json['meterNo'];
    readUnit = json['readUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPaid'] = this.isPaid;
    data['remark'] = this.remark;
    data['payDate'] = this.payDate;
    data['readDate'] = this.readDate;
    data['readImageUrl'] = this.readImageUrl;
    data['status'] = this.status;
    data['block'] = this.block;
    data['dueDate'] = this.dueDate;
    data['street'] = this.street;
    data['billNo'] = this.billNo;
    data['ledgerNo'] = this.ledgerNo;
    data['ledgerPostFix'] = this.ledgerPostFix;
    data['mainLedgerTitle'] = this.mainLedgerTitle;
    data['layerDes1'] = this.layerDes1;
    data['layerDes2'] = this.layerDes2;
    data['layerDes3'] = this.layerDes3;
    data['layerDes4'] = this.layerDes4;
    data['layerDes5'] = this.layerDes5;
    data['layerDes6'] = this.layerDes6;
    data['layerDes7'] = this.layerDes7;
    data['layerRate1'] = this.layerRate1;
    data['layerRate2'] = this.layerRate2;
    data['layerRate3'] = this.layerRate3;
    data['layerRate4'] = this.layerRate4;
    data['layerRate5'] = this.layerRate5;
    data['layerRate6'] = this.layerRate6;
    data['layerRate7'] = this.layerRate7;
    data['layerAmount1'] = this.layerAmount1;
    data['layerAmount2'] = this.layerAmount2;
    data['layerAmount3'] = this.layerAmount3;
    data['layerAmount4'] = this.layerAmount4;
    data['layerAmount5'] = this.layerAmount5;
    data['layerAmount6'] = this.layerAmount6;
    data['layerAmount7'] = this.layerAmount7;
    data['oldUnit'] = this.oldUnit;
    data['totalUnitUsed'] = this.totalUnitUsed;
    data['multiplier'] = this.multiplier;
    data['unitsToPay'] = this.unitsToPay;
    data['mHorsePower'] = this.mHorsePower;
    data['cost'] = this.cost;
    data['Cost'] = this.cost;
    data['mHorsePowerCost'] = this.mHorsePowerCost;
    data['totalCostOrg'] = this.totalCostOrg;
    data['creditAmount'] = this.creditAmount;
    data['disscountAmt'] = this.disscountAmt;
    data['totalCost'] = this.totalCost;
    data['signUrl'] = this.signUrl;
    data['refundAmount'] = this.refundAmount;
    data['hotline'] = this.hotline;
    data['companyName'] = this.companyName;
    data['state'] = this.state;
    data['monthName'] = this.monthName;
    data['consumerName'] = this.consumerName;
    data['customerId'] = this.customerId;
    data['meterNo'] = this.meterNo;
    data['readUnit'] = this.readUnit;
    return data;
  }
}
