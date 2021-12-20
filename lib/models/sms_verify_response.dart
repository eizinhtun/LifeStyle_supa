// @dart=2.9
class SmsVerifyResponse {
  bool status;
  int requestId;

  SmsVerifyResponse({this.status, this.requestId});

  SmsVerifyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    return data;
  }
}
