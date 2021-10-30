// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:provider/provider.dart';

class loadingPage extends StatefulWidget {
  const loadingPage({Key key}) : super(key: key);

  @override
  _loadingPageState createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  List<String> totalList = [];
  List<String> tracList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
    totalList = [];
    for (var i = 0; i < 50; i++) {
      totalList.add((i + 1).toString());
    }

    tracList = totalList.sublist(0, showlist);
  }

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await context.read<WalletProvider>().getTransactionList(context);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("Wallet"),
      ),
      body: Container(
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
              // if(tracList.length == end){
              //   body = Text("No more Data");
              // }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: FutureBuilder(
              future:
                  context.read<WalletProvider>().getTransactionList(context),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TransactionModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: SpinKitCircle(
                            color: Color.fromRGBO(91, 74, 127, 10),
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (c, i) => SingleChildScrollView(
                      child: Card(
                          child: ListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                snapshot.data[i].type == TransactionType.Topup
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
                                        snapshot.data[i].type ==
                                                TransactionType.Topup
                                            ? "Top Up"
                                            : "Withdraw",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    // Text(
                                    //     Formatter.dateTimeFormat(
                                    //         snapshot.data[i].createdDate),
                                    //     style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Spacer(),
                                Text(snapshot.data[i].amount.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: snapshot.data[i].type ==
                                                TransactionType.Topup
                                            ? Colors.green
                                            : Colors.red)),
                                IconButton(
                                    onPressed: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>new WalletDetailSuccessPage(docId:doc.id)));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                    ))
                              ],
                            ),
                            Dash(
                              direction: Axis.horizontal,
                              length: MediaQuery.of(context).size.width * 0.8,
                              dashLength: 2,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Top up successful",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      "Top up successful",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      "Top up successful",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Image.asset(
                                    "assets/payment/success.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
