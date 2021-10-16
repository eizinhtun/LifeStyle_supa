// @dart=2.9
class UserModel {
  String uid;
  String fullName;
  String email;
  String phone;
  String photoUrl;
  double balance;
  DateTime createdDate;
  String address;

  UserModel({
    this.fullName,
    this.email,
    this.phone,
    this.photoUrl,
    this.uid,
    this.balance,
    this.createdDate,
    this.address,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    photoUrl = json['photoUrl'];
    uid = json['uid'];
    balance = json['balance'];
    createdDate =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(json['createdDate']));
    address = json['address'];
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
    data['createdDate'] = this.createdDate.microsecondsSinceEpoch.toString();
    data['address'] = this.address;
    return data;
  }
}
