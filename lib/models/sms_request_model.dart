// @dart=2.9
class SmsRequestModel {
  bool status;
  int request_id;
  String number;

  SmsRequestModel({this.status, this.request_id, this.number});

  SmsRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    request_id = json['request_id'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.request_id;
    data['number'] = this.number;
    return data;
  }
}
