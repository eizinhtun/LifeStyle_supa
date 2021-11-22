//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class NotiModel {
  String id;
  Timestamp createdDate;
  String createdDateTimeStr;
  String title;
  int userId;
  String type;
  int refid;
  String content;
  String imageUrl;
  String accountNo;
  int amount;
  String bill;
  int balance;
  String body;
  String bodyValue;
  String category;
  String clickAction;
  Timestamp currentdate;
  String currentDateStr;
  String fortime;
  String number;
  String phoneno;
  String requestDate;
  String requestDateStr;
  String sound;
  String state;
  bool status;

  String messageId;

  NotiModel(
      {this.id,
      this.createdDate,
      this.createdDateTimeStr,
      this.title,
      this.userId,
      this.type,
      this.refid,
      this.content,
      this.imageUrl,
      this.accountNo,
      this.amount,
      this.bill,
      this.balance,
      this.body,
      this.bodyValue,
      this.category,
      this.clickAction,
      this.currentdate,
      this.messageId});

  NotiModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    type = json['type'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    id = json['id'];
    messageId = json['message_id'].toString().trim();
    createdDate = json['created_date'];
    currentdate = json['currentdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['content'] = this.content;
    data['imageUrl'] = this.imageUrl;
    data['status'] = this.status;
    data['id'] = this.id;
    data['message_id'] = this.messageId;
    data['created_date'] = this.createdDate;
    data['currentdate'] = this.currentdate;

    return data;
  }
}
