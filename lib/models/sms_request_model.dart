// @dart=2.9
class SmsRequestModel {
  bool status;
  int requestId;
  String number;

  SmsRequestModel({this.status, this.requestId, this.number});

  SmsRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    data['number'] = this.number;
    return data;
  }
}
