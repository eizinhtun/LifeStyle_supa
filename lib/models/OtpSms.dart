// @dart=2.9
class OtpSms {
  bool status = false;
  int requestId = 0;
  String number = "";
  String guid = "";

  OtpSms({this.status, this.requestId, this.number, this.guid});

  OtpSms.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    number = json['number'];
    guid = json['guid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    data['number'] = this.number;
    data['guid'] = this.guid;
    return data;
  }
}
