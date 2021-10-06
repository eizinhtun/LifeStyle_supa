// @dart=2.9
class SmsVerifyModel {
  bool status;
  int request_id;

  SmsVerifyModel({this.status, this.request_id});

  SmsVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    request_id = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.request_id;
    return data;
  }
}
