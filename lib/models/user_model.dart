// @dart=2.9
class UserModel {
  String uid;
  String fullName;
  String email;
  String phone;
  String photoUrl;
  int balance;
  String fcmtoken;
  String password;
  bool isActive;
  DateTime createdDate;
  String address;
  bool showBalance=true;

  UserModel({
    this.fullName,
    this.email,
    this.phone,
    this.photoUrl,
    this.uid,
    this.balance,
    this.fcmtoken,
    this.password,
    this.isActive,
    this.createdDate,
    this.address,
    this.showBalance,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    photoUrl = json['photoUrl'];
    uid = json['uid'];
    balance = json['balance']??0;
    fcmtoken = json['fcmtoken'];
    password = json['password'];
    isActive = json['isActive'];
    // createdDate =
    //     DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));
    address = json['address'];
    showBalance=json['showBalance']==null?true: json['showBalance'];
    //  DateTime.parse(json['createdDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['photoUrl'] = this.photoUrl;
    data['uid'] = this.uid;
    data['balance'] = this.balance;
    data['fcmtoken'] = this.fcmtoken;
    data['password'] = this.password;
    data['isActive'] = this.isActive;
    // data['createdDate'] = this.createdDate.toString();
    data['address'] = this.address;
    data['showBalance'] = this.showBalance;
    return data;
  }
}
