// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/formatter.dart';

class WalletDetailSuccessPage extends StatefulWidget {
  final String docId;
  const WalletDetailSuccessPage({Key key, this.docId}) : super(key: key);

  @override
  _WalletDetailSuccessPageState createState() =>
      _WalletDetailSuccessPageState();
}

class _WalletDetailSuccessPageState extends State<WalletDetailSuccessPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("Wallet Detail"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db
              .collection(transactions)
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection(manyTransaction)
              .doc(widget.docId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TransactionModel item =
                  TransactionModel.fromJson(snapshot.data.data());
              return SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(0.0),
                  width: ScreenUtil().setSp(900), //
                  //height:ScreenUtil().setSp(2100),//
                  padding: EdgeInsets.only(
                      top: 10.0, left: 8.0, right: 8.0, bottom: 0.0),
                  child: Container(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/payment/success.png",
                              width: 50,
                              height: 50,
                            ),
                            Text(
                                Tran.of(context)
                                    .text("notification_toup_success")
                                    .toString(),
                                style: TextStyle(fontSize: 24)),
                            Text(item.amount.toString() + " (Ks)"),
                            SizedBox(height: 10),
                            Dash(
                              direction: Axis.horizontal,
                              length: MediaQuery.of(context).size.width * 0.8,
                              dashLength: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Transaction Date"),
                                  Spacer(),
                                  Text(
                                      Formatter.dateTimeFormat(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.createdDate
                                                  .millisecondsSinceEpoch)),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Amount"),
                                  Spacer(),
                                  Text(item.amount.toString(),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Transaction Date"),
                                  Spacer(),
                                  Text(
                                      Formatter.dateTimeFormat(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.createdDate
                                                  .millisecondsSinceEpoch)),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Amount"),
                                  Spacer(),
                                  Text(item.amount.toString(),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Transaction Date"),
                                  Spacer(),
                                  Text(
                                      Formatter.dateTimeFormat(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.createdDate
                                                  .millisecondsSinceEpoch)),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Amount"),
                                  Spacer(),
                                  Text(item.amount.toString(),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Transaction Date"),
                                  Spacer(),
                                  Text(
                                      Formatter.dateTimeFormat(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.createdDate
                                                  .millisecondsSinceEpoch)),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Amount"),
                                  Spacer(),
                                  Text(item.amount.toString(),
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(
                                      color: Colors.black12, width: 2.0)),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 12),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close")),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(child: Text("No data"));
            }
          }),
    );
  }
}
