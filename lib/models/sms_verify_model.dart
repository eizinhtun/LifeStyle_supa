// @dart=2.9
class SmsVerifyModel {
  bool status;
  int requestId;

  SmsVerifyModel({this.status, this.requestId});

  SmsVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    return data;
  }
}
