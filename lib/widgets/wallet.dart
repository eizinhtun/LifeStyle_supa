// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/topup_widget.dart';
import 'package:left_style/widgets/withdrawal_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalletState();
}

class WalletState extends State<Wallet> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<TransactionModel> tracList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    getData();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {});
  }

  getData() async {
    tracList = await context.read<WalletProvider>().getTransactionList(context);
    print("TracList: ${tracList.length}");
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.blue,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 0.0,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200))),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: Container(),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await context.read<LoginProvider>().logOut(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.logout))
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                    constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height,
                    ),
                    child: Container()),
              ),
            ],
          ),
          Positioned(
            top: 100,
            left: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width - 30,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      elevation: 10,
                      child: Container(
                        // padding:
                        //     EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.account_balance_wallet),
                                  SizedBox(width: 10),
                                  Text("Wallet Balance (Ks) "),
                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Row(
                                children: [
                                  Text("2000000.00",
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (contex) =>
                                                      TopUpPage()));
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
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (contex) =>
                                                      WithdrawalPage()));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.payments),
                                            SizedBox(width: 5),
                                            Text("Withdrawal"),
                                          ],
                                        )),
                                  ),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //         padding: EdgeInsets.only(
                                  //             left: 35,
                                  //             right: 35,
                                  //             top: 10,
                                  //             bottom: 10) // foreground
                                  //         ),
                                  //     onPressed: () {},
                                  //     child: Text("Cash In")),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //         padding: EdgeInsets.only(
                                  //             left: 35,
                                  //             right: 35,
                                  //             top: 10,
                                  //             bottom: 10) // foreground
                                  //         ),
                                  //     onPressed: () {},
                                  //     child: Text("Cash Out")),
                                ],
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     ElevatedButton(
                            //         style: ElevatedButton.styleFrom(
                            //             padding: EdgeInsets.only(
                            //                 left: 20,
                            //                 right: 20,
                            //                 top: 10,
                            //                 bottom: 10) // foreground
                            //         ),
                            //         onPressed: () {},
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.cached),
                            //             SizedBox(width: 5),
                            //             Text("Top Up    "),
                            //           ],
                            //         )
                            //     ),
                            //     ElevatedButton(
                            //         style: ElevatedButton.styleFrom(
                            //             padding: EdgeInsets.only(
                            //                 left: 20,
                            //                 right: 20,
                            //                 top: 10,
                            //                 bottom: 10) // foreground
                            //         ),
                            //         onPressed: () {},
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.payment),
                            //             SizedBox(width: 5),
                            //             Text("Withdrawal"),
                            //           ],
                            //         )
                            //     ),
                            //     // ElevatedButton(
                            //     //     style: ElevatedButton.styleFrom(
                            //     //         padding: EdgeInsets.only(
                            //     //             left: 35,
                            //     //             right: 35,
                            //     //             top: 10,
                            //     //             bottom: 10) // foreground
                            //     //         ),
                            //     //     onPressed: () {},
                            //     //     child: Text("Cash In")),
                            //     // ElevatedButton(
                            //     //     style: ElevatedButton.styleFrom(
                            //     //         padding: EdgeInsets.only(
                            //     //             left: 35,
                            //     //             right: 35,
                            //     //             top: 10,
                            //     //             bottom: 10) // foreground
                            //     //         ),
                            //     //     onPressed: () {},
                            //     //     child: Text("Cash Out")),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (BuildContext context, mode) {
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
                        itemBuilder: (c, i) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                    tracList[i].type == TransactionType.Topup
                                        ? Icons.add
                                        : Icons.minimize,
                                    size: 20),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        tracList[i].type ==
                                                TransactionType.Topup
                                            ? "Top Up"
                                            : "Withdraw",
                                        style: TextStyle(fontSize: 12)),
                                    Text(
                                        Formatter.dateTimeFormat(
                                            tracList[i].createdDate),
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Spacer(),
                                Text(tracList[i].amount.toString(),
                                    style: TextStyle(fontSize: 12)),
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
          ),
        ],
      ),
    ));
  }
}
