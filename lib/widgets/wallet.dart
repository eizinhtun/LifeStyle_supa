// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/firebase_crud_provider.dart';
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
  List<TransactionModel> totalList = [];
  List<TransactionModel> tracList = [];
  UserModel userModel = UserModel();
  int end = 10;
  static int i = 1;

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
    // getData();
   // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    userModel = await context.read<LoginProvider>().getUser(context);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  getData() async {
    totalList =await context.read<WalletProvider>().getManyTransactionList(context);
        //await context.read<WalletProvider>().getTransactionList(context);
    print(totalList);
    if (totalList.length < end) {
      end = totalList.length;
    }
    tracList = totalList.sublist(0, end);
    userModel = await context.read<LoginProvider>().getUser(context);
    print("User: ${userModel.fullName}");
    print("TracList: ${tracList.length}");

  }

  void _onLoading() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // items.add((items.length + 1).toString());
    i++;
    end = end * i;
    if (totalList.length < end) {
      end = totalList.length;
    }
    tracList = totalList.sublist(0, end);

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  // MaterialColor(0xFFfa2e73

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
                backgroundColor: Color(0xfffa2e73),
                // Colors.blue,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 0.0,
                stretchTriggerOffset: 70.0,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Container(),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Container(
              //       constraints: BoxConstraints.expand(
              //         height: MediaQuery.of(context).size.height,
              //       ),
              //       child: Container()),
              // ),
            ],
          ),
          Positioned(
            top: 30,
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
                                  Image.asset("assets/payment/wallet.png",width: 50,height: 50),
                                  SizedBox(width: 10),
                                  Text(
                                      "Wallet Balance ( ${Formatter.balanceFormat(userModel.balance ?? 0)} Ks) "),
                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 30,
                                  ),
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
                                ],
                              ),
                            ),

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

                                // Icon(
                                //     tracList[i].type == TransactionType.Topup
                                //         ? Icons.add
                                //         : Icons.minimize,
                                //     size: 20),
                                tracList[i].type == TransactionType.Topup?Image.asset("assets/payment/topup.png"):Image.asset("assets/payment/withdraw.png"),
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
                                Text(
                                    tracList[i].type == TransactionType.Topup?Formatter.balanceTopupFormat(tracList[i].amount)
                                    :Formatter.balanceFormat(tracList[i].amount),
                                    style: TextStyle(fontSize: 14)),
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
