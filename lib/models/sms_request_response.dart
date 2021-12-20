// @dart=2.9
class SmsRequestResponse {
  bool status;
  int requestId;
  String number;

  SmsRequestResponse({this.status, this.requestId, this.number});

  SmsRequestResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    data['number'] = this.number;
    return data;
  }
}
