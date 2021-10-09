// @dart=2.9
class UserModel {
  String fullName;
  String phone;
  String password;

  UserModel({this.fullName, this.phone, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }
}
