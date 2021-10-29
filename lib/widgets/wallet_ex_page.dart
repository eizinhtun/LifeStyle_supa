// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/topup_widget.dart';
import 'package:left_style/widgets/withdrawal_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class WalletExPage extends StatefulWidget {
  const WalletExPage({Key key}) : super(key: key);

  @override
  _loadingPageState createState() => _loadingPageState();
}

class _loadingPageState extends State<WalletExPage> {
  // List<String> totalList=[];
  // List<String> tracList=[];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<TransactionModel> totalList = [];
  List<TransactionModel> tracList = [];
  // int end = 5;
  int i = 1;
  int showlist = 10;
  int start;
  int end;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Future.delayed(Duration(milliseconds: 100));
    totalList =
        await context.read<WalletProvider>().getTransactionList(context);
    print(totalList);
    // totalList =[];
    // for(var i = 0;i<25;i++){
    //   totalList.add((i+1).toString());
    // }

    _onRefresh();
  }

  void _onRefresh() async {
    tracList.clear();
    await Future.delayed(Duration(milliseconds: 100));
    showlist = 10;
    tracList = totalList.sublist(0, showlist);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
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

    // else{
    //   _refreshController.loadNoData();
    // }
    _refreshController.loadComplete();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("Wallet"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
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
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
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
                        // ListTile(
                        //   title:  Text(tracList[i].toString()),
                        // ),
                        ListTile(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          tracList[i].type ==
                                                  TransactionType.Topup
                                              ? "Top Up"
                                              : "Withdraw",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
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
                                  IconButton(
                                      onPressed: () {
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>new WalletDetailSuccessPage(docId:doc.id)));
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                      ))
                                ],
                              ),
                              Dash(
                                direction: Axis.horizontal,
                                length: MediaQuery.of(context).size.width * 0.7,
                                dashLength: 2,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text("Top up successful",
                                          style: TextStyle(fontSize: 13)),
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
    );
  }
}
