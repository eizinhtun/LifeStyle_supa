// @dart=2.9
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/show_balance.dart';
import 'package:left_style/widgets/wallet_detail_success_page.dart';
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
  String uid=FirebaseAuth.instance.currentUser.uid.toString();
  int showlist = 10;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _onRefresh();
  }

  List<DocumentSnapshot> documentList = [];
  List<TransactionModel> tracList = [];
  Future fetchFirstList() async {
    try {
      tracList.clear();
      // documentList = (await FirebaseFirestore.instance
      //         .collection(transactions)
      //         .doc(FirebaseAuth.instance.currentUser.uid)
      //         .collection(manyTransaction)
      //         .orderBy("createdDate", descending: true)
      //         .limit(showlist)
      //         .get())
      //     .docs;
      documentList = (await FirebaseFirestore.instance
          .collection(transactions)
          .where("uid", isEqualTo: uid)
          //.orderBy("createdDate", descending: true)
          .limit(showlist)
          .get())
          .docs;

      documentList.forEach((result) {
        tracList.add(TransactionModel.fromJson(result.data(), doc: result.id));
      });
      print(tracList);
      setState(() {
        _isLoading = false;
      });
      setState(() {});
    } on SocketException {} catch (e) {
      print(e.toString());
    }
  }

  fetchNext() async {
    try {
      // List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
      //         .collection(transactions)
      //         .doc(FirebaseAuth.instance.currentUser.uid)
      //         .collection(manyTransaction)
      //         .orderBy("createdDate", descending: true)
      //         .startAfterDocument(documentList[documentList.length - 1])
      //         .limit(showlist)
      //         .get())
      //     .docs;
      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
          .collection(transactions)
          .where("uid", isEqualTo: uid)
          //.orderBy("createdDate", descending: true)
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
    setState(() {
      _isLoading=true;
    });

    fetchFirstList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    fetchNext();

    _refreshController.loadComplete();

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              // child: StreamBuilder(
              //   stream: db
              //       .collection(userCollection)
              //       .doc(FirebaseAuth.instance.currentUser.uid)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(
              //         child: CupertinoActivityIndicator(),
              //       );
              //     } else if (snapshot.hasData) {
              //       UserModel _user = UserModel.fromJson(snapshot.data.data());
              //       return Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           TextButton.icon(
              //               onPressed: () {
              //                 db
              //                     .collection(userCollection)
              //                     .doc(FirebaseAuth.instance.currentUser.uid)
              //                     .update({"showBalance": !_user.showBalance});
              //               },
              //               icon: Icon(
              //                 Icons.account_balance_wallet,
              //                 color: Colors.black38,
              //                 size: 35,
              //               ),
              //               label: Row(
              //                 children: [
              //                   Text(
              //                     "${_user.showBalance ? Formatter.balanceFormat(_user.balance) : Formatter.balanceFormat(_user.balance)} ${Tran.of(context).text("ks")}",
              //                     style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 16,
              //                         color: Colors.black),
              //                   ),
              //                   InkWell(
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Icon(
              //                         _user.showBalance
              //                             ? Icons.visibility
              //                             : Icons.visibility_off,
              //                         size: 15,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               )
              //           ),
              //
              //
              //           /* Expanded(
              //       child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //               // primary: Colors.white,
              //               padding: EdgeInsets.only(
              //             left: 15,
              //             right: 15,
              //             top: 10,
              //             bottom: 10,
              //           ) // foreground
              //               ),
              //           onPressed: () {
              //             Navigator.of(context).push(MaterialPageRoute(
              //                 builder: (contex) => TopUpPage()));
              //           },
              //           child: Row(
              //             children: [
              //               Icon(Icons.cached),
              //               SizedBox(width: 5),
              //               Text("Top Up"),
              //             ],
              //           )),
              //     ),
              //     SizedBox(width: 5),
              //     Expanded(
              //       child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //               padding: EdgeInsets.only(
              //             left: 15,
              //             right: 15,
              //             top: 10,
              //             bottom: 10,
              //           ) // foreground
              //               ),
              //           onPressed: () {
              //             Navigator.of(context).push(MaterialPageRoute(
              //                 builder: (contex) => WithdrawalPage()));
              //           },
              //           child: Row(
              //             children: [
              //               Icon(Icons.payments),
              //               SizedBox(width: 5),
              //               Text("Withdrawal"),
              //             ],
              //           )),
              //     ),*/
              //         ],
              //       );
              //     } else {
              //       return Text("No data found");
              //     }
              //   },
              // ),
              child: ShowBalance(
                onTopued: (result){
                  if (result != null && result == true) {
                        _isLoading = true;
                        _onRefresh();
                      }
                },
                onWithdrawed: (result){
                  if (result != null && result == true) {
                    _isLoading = true;
                    _onRefresh();
                  }
                },


              ),

            ),
            Divider(
              //length: MediaQuery.of(context).size.width,
              thickness: 2,
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
                  child: _isLoading
                      ? Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (c, i) => Card(
                            elevation: 0.3,
                            child: Center(
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      var returnResult = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  new WalletDetailSuccessPage(
                                                      docId: tracList[i].docId,
                                                      type: tracList[i].type,
                                                      status: tracList[i].status)));
                                      if (returnResult != null &&
                                          returnResult) {
                                        _onRefresh();
                                      }
                                    },
                                    title: Column(
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Container(
                                                color: Colors.transparent,
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                alignment: Alignment.center,
                                                width: 45,
                                                height: 45,
                                                child: new CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black12,
                                                  radius: 100.0,
                                                  backgroundImage: NetworkImage(
                                                    tracList[i].paymentLogoUrl,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  tracList[i].paymentType,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                Text(
                                                    Formatter.dateTimeFormat(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            tracList[i]
                                                                .createdDate
                                                                .millisecondsSinceEpoch)),
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                            Spacer(),
                                            Text(tracList[i].amount.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: tracList[i].type ==
                                                            TransactionType
                                                                .Topup
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        ),
                                        Dash(
                                          direction: Axis.horizontal,
                                          length: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          dashLength: 2,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                    "${Tran.of(context)?.text(tracList[i].status)}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: tracList[i]
                                                                    .status
                                                                    .trim()
                                                                    .toLowerCase() ==
                                                                "approved"
                                                            ? Colors.green
                                                            : Colors.red)),
                                              ],
                                            ),
                                            Spacer(),
                                            getTypeInfo(tracList[i]
                                                .status
                                                .trim()
                                                .toLowerCase()),
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

  Widget getTypeInfo(String type) {
    switch (type) {
      case "approved":
        return Image.asset(
          "assets/payment/success.png",
          width: 20,
          height: 20,
        );
        break;
      case "rejected":
        return Icon(
          Icons.error,
          color: Colors.red,
        );
        break;
      case "verifying":
        return Text("");
        break;
    }
  }
}
