// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class MyReadUnit {
  MyReadUnit(
      {this.companyId,
      this.readDate,
      this.status,
      this.readUnit,
      this.mobile,
      this.branchId,
      this.consumerName,
      this.meterNo,
      this.customerId,
      this.monthName,
      this.readImageUrl});
  String meterNo;
  String consumerName;
  String customerId;
  String branchId;
  String companyId;
  String mobile;
  int readUnit;
  String readImageUrl;
  String monthName;
  Timestamp readDate;
  String status;
  String uid;

  MyReadUnit.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    meterNo = json['meterNo'];
    consumerName = json['consumerName'];
    customerId = json['customerId'];
    branchId = json['branchId'];
    companyId = json['companyId'];
    mobile = json['mobile'];
    readUnit = json['readUnit'];
    readImageUrl = json['readImageUrl'];
    monthName = json['monthName'];
    readDate = json['readDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['meterNo'] = this.meterNo;
    data['consumerName'] = this.consumerName;
    data['customerId'] = this.customerId;
    data['branchId'] = this.branchId;
    data['companyId'] = this.companyId;
    data['mobile'] = this.mobile;
    data['readUnit'] = this.readUnit;
    data['readImageUrl'] = this.readImageUrl;
    data['monthName'] = this.monthName;
    data['ConsumerName'] = this.consumerName;
    data['readDate'] = this.readDate;
    data['status'] = this.status;
    return data;
  }
}
