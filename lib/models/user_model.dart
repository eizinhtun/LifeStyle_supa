// @dart=2.9
class UserModel {
  String uid;
  String fullName;
  String phone;

  UserModel({this.fullName, this.phone, this.uid});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['uid'] = this.uid;
    return data;
  }
}
