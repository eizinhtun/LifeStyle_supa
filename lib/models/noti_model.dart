//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class NotiModel {
  String id;
  DateTime createdDate;
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
  DateTime currentdate;
  String currentDateStr;
  String fortime;
  String number;
  String phoneno;
  String requestDate;
  String requestDateStr;
  String sound;
  String state;
  bool status;
  String time;
  String transactionNo;
  int odd;
  String guid;
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
      this.currentDateStr,
      this.fortime,
      this.number,
      this.phoneno,
      this.requestDate,
      this.requestDateStr,
      this.sound,
      this.state,
      this.status,
      this.time,
      this.transactionNo,
      this.odd,
      this.guid,
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
    // refid = json['refid'];

    Timestamp createdtimestamp = json['created_date'];
    createdDate = createdtimestamp.toDate();
    //  Timestamp()
    // createdDateTimeStr = json['created_date_time_Str'];
    // userId = json['userId'];
    // accountNo = json['account_no'];
    // amount = json['amount'];
    // bill = json['bill'];
    // balance = json['balance'];
    // bodyValue = json['body_value'];
    // category = json['category'];
    // clickAction = json['click_action'];
    Timestamp currenttimestamp = json['currentdate'];
    currentdate = currenttimestamp.toDate();
    // currentDateStr = json['current_date_Str'];
    // fortime = json['fortime'];
    // number = json['number'];
    // phoneno = json['phoneno'];
    // requestDate = json['request_date'];
    // requestDateStr = json['request_date_Str'];
    // sound = json['sound'];
    // state = json['state'];
    // time = json['time'];
    // transactionNo = json['transaction_no'];
    // odd = json['odd'];
    // guid = json['guid'];
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
    // data['refid'] = this.refid;
    data['created_date'] = Timestamp.fromDate(this.createdDate);
    //  this.createdDate;

    // data['created_date_time_Str'] = this.createdDateTimeStr;
    // data['userId'] = this.userId;
    // data['account_no'] = this.accountNo;
    // data['amount'] = this.amount;
    // data['bill'] = this.bill;
    // data['balance'] = this.balance;
    // data['body_value'] = this.bodyValue;
    // data['category'] = this.category;
    // data['click_action'] = this.clickAction;
    data['currentdate'] = Timestamp.fromDate(this.currentdate);
    // data['current_date_Str'] = this.currentDateStr;
    // data['fortime'] = this.fortime;
    // data['number'] = this.number;
    // data['phoneno'] = this.phoneno;
    // data['request_date'] = this.requestDate;
    // data['request_date_Str'] = this.requestDateStr;
    // data['sound'] = this.sound;
    // data['state'] = this.state;
    // data['time'] = this.time;
    // data['transaction_no'] = this.transactionNo;
    // data['odd'] = this.odd;
    // data['guid'] = this.guid;

    return data;
  }
}
