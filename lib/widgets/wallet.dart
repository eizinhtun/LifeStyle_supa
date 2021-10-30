// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/topup_widget.dart';
import 'package:left_style/widgets/wallet_detail_success_page.dart';
import 'package:left_style/widgets/withdrawal_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalletState();
}

class WalletState extends State<Wallet> {
  RefreshController _refreshController;
  final db = FirebaseFirestore.instance;
  //List<TransactionModel> totalList = [];
  //List<TransactionModel> tracList = [];

  int showlist = 5;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    _onRefresh();
  }

  List<DocumentSnapshot> documentList = [];
  List<TransactionModel> tracList = [];
  Future fetchFirstList() async {
    try {
      tracList.clear();
      documentList = (await FirebaseFirestore.instance
              .collection(transactions)
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection(manyTransaction)
              .orderBy("createdDate")
              .limit(showlist)
              .get())
          .docs;
      documentList.forEach((result) {
        tracList.add(TransactionModel.fromJson(result.data(), doc: result.id));
      });
      setState(() {});
    } on SocketException {} catch (e) {
      print(e.toString());
    }
  }

  fetchNext() async {
    try {
      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
              .collection(transactions)
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection(manyTransaction)
              .orderBy("createdDate")
              .startAfterDocument(documentList[documentList.length - 1])
              .limit(showlist)
              .get())
          .docs;
      newDocumentList.forEach((result) {
        tracList.add(TransactionModel.fromJson(result.data(), doc: result.id));
      });
      documentList.addAll(newDocumentList);

      setState(() {});
    } on SocketException {} catch (e) {
      print(e.toString());
    }
  }

  void _onRefresh() async {
    fetchFirstList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    fetchNext();

    _refreshController.loadComplete();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 10),
              alignment: Alignment.bottomCenter,
              color: Colors.transparent,
              child: StreamBuilder<DocumentSnapshot>(
                stream: db
                    .collection(userCollection)
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    UserModel _user = UserModel.fromJson(snapshot.data.data());
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              db
                                  .collection(userCollection)
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .update({"showBalance": !_user.showBalance});
                            },
                            icon: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.black38,
                              size: 35,
                            ),
                            label: Row(
                              children: [
                                Text(
                                  "${_user.showBalance ? Formatter.balanceFormatFromDouble(_user.balance) : Formatter.balanceUnseenFormat(_user.balance)} Ks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      _user.showBalance
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        PopupMenuButton(
                            onSelected: (val) {
                              if (val == 1) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (contex) => TopUpPage()));
                              }
                              if (val == 2) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (contex) => WithdrawalPage()));
                              }
                            },
                            icon: Icon(Icons.more_horiz_rounded),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Icon(
                                                  Icons.add_circle,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                            Text("Top up"),
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    ),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                )),
                                            Text("Withdraw"),
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    ),
                                    value: 2,
                                  )
                                ])

                        /* Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // primary: Colors.white,
                            padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                          bottom: 10,
                        ) // foreground
                            ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contex) => TopUpPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.cached),
                            SizedBox(width: 5),
                            Text("Top Up"),
                          ],
                        )),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                          bottom: 10,
                        ) // foreground
                            ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contex) => WithdrawalPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.payments),
                            SizedBox(width: 5),
                            Text("Withdrawal"),
                          ],
                        )),
                  ),*/
                      ],
                    );
                  } else {
                    return Text("No data found");
                  }
                },
              ),
            ),
            Divider(
                //length: MediaQuery.of(context).size.width,
                ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.65,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Center(child: Text("pull up load"));
                        return body;
                      } else if (mode == LoadStatus.loading) {
                        body = Center(child: CupertinoActivityIndicator());
                        return body;
                      } else if (mode == LoadStatus.failed) {
                        body = Center(child: Text("Load Failed!Click retry!"));
                        return body;
                      } else if (mode == LoadStatus.canLoading) {
                        body = Center(child: Text("release to load more"));
                        return body;
                      } else {
                        body = Center(child: Text("No more Data"));
                        return body;
                      }
                      /*  if (tracList.length == end) {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );*/
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (c, i) => Card(
                      elevation: 0.3,
                      child: Center(
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                print(tracList[i].docId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new WalletDetailSuccessPage(
                                                docId: tracList[i].docId)));
                              },
                              title: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      documentList[i].get("type") ==
                                              TransactionType.Topup
                                          ? Image.asset(
                                              "assets/payment/topup.png",
                                              width: 50,
                                              height: 50,
                                            )
                                          : Image.asset(
                                              "assets/payment/withdraw.png",
                                              width: 50,
                                              height: 50,
                                            ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            tracList[i].type ==
                                                    TransactionType.Topup
                                                ? "Top Up"
                                                : "Withdraw",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              Formatter.dateTimeFormat(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      tracList[i]
                                                          .createdDate
                                                          .millisecondsSinceEpoch)),
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      Spacer(),
                                      Text(tracList[i].amount.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: tracList[i].type ==
                                                      TransactionType.Topup
                                                  ? Colors.green
                                                  : Colors.red)),
                                    ],
                                  ),
                                  Dash(
                                    direction: Axis.horizontal,
                                    length:
                                        MediaQuery.of(context).size.width * 0.7,
                                    dashLength: 2,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text("Top up successful",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.green)),
                                        ],
                                      ),
                                      Spacer(),
                                      Image.asset("assets/payment/success.png",
                                          width: 20, height: 20)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemExtent: 100.0,
                    itemCount: documentList.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String title = "";
  String imgUrl = "";
  Color textColor;
  void getTypeInfo(String type) {
    switch (type) {
      case TransactionType.Topup:
        title = "Top Up";
        imgUrl = "assets/payment/topup.png";
        textColor = Colors.green;
        break;
      case TransactionType.Withdraw:
        title = "Withdraw";
        imgUrl = "assets/payment/withdraw.png";
        textColor = Colors.red;
        break;
      case TransactionType.meterbill:
        title = "Meter Bill";
        imgUrl = "assets/payment/withdraw.png";
        textColor = Colors.purple;
        break;
    }
  }
}
