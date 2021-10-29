// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/topup_widget.dart';
import 'package:left_style/widgets/wallet_detail_success_page.dart';
import 'package:left_style/widgets/withdrawal_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalletState();
}

class WalletState extends State<Wallet> {
  RefreshController _refreshController;

  List<TransactionModel> totalList = [];
  List<TransactionModel> tracList = [];
  List<String> docList = [];
  final db = FirebaseFirestore.instance;
  int i = 1;
  int showlist = 10;
  int start;
  int end;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(
        initialRefresh: false, initialLoadStatus: LoadStatus.loading);
    // getData();
  }

  getData() async {
    totalList =
        await context.read<WalletProvider>().getTransactionList(context);
    print(totalList);
    db
        .collection(transactions)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(manyTransaction)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        docList.add(result.id);
      });
    });

    _onRefresh();
  }

  void _onRefresh() async {
    tracList.clear();

    showlist = 10;
    if (totalList.length < showlist) showlist = totalList.length;
    tracList = totalList.sublist(0, showlist);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    start = showlist;
    showlist = showlist + 10; //start +showlist;
    end = totalList.length;
    if (tracList.length < end) {
      print(tracList.length);
      print(end);
      print(showlist);
      if (showlist > end) {
        tracList..addAll(totalList.sublist(start, end));
      } else {
        tracList..addAll(totalList.sublist(start, showlist));
      }
    }

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.black38,
                        size: 35,
                      ),
                      label: Row(
                        children: [
                          Text(
                            "${Formatter.balanceFormat(1098765)} Ks",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.remove_red_eye_rounded,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      )),
                  PopupMenuButton(
                      icon: Icon(Icons.more_horiz_rounded),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: ElevatedButton(
                                onPressed: () {},
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
                                              right: 8.0, top: 10, bottom: 10),
                                          child: Icon(
                                            Icons.remove_circle,
                                            color: Colors.grey.withOpacity(0.5),
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
              ),
            ),
            Divider(
                //length: MediaQuery.of(context).size.width,
                ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("pull up load");
                      return body;
                    } else if (mode == LoadStatus.loading) {
                      body = Container(
                          color: Colors.red,
                          height: 100,
                          width: 100,
                          child: Text(
                              "Load Failed!Click retry!")); // CupertinoActivityIndicator());
                      return body;
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                      return body;
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("release to load more");
                      return body;
                    } else {
                      body = Text("No more Data");
                      return body;
                    }
                    if (tracList.length == end) {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (c, i) => Card(
                    child: Center(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new WalletDetailSuccessPage(
                                              docId: docList[i])));
                            },
                            title: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    tracList[i].type == TransactionType.Topup
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
                                            Formatter.dateTimeFormat(
                                                tracList[i].createdDate),
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
                  itemCount: tracList.length,
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
