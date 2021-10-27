
// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/topup_widget.dart';
import 'package:left_style/widgets/wallet.dart';
import 'package:left_style/widgets/withdrawal_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class WalletTest extends StatefulWidget {
  const WalletTest({Key key}) : super(key: key);

  @override
  _WalletTestState createState() => _WalletTestState();
}

class _WalletTestState extends State<WalletTest> {

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<TransactionModel> totalList = [];
  List<TransactionModel> tracList = [];

  // UserModel userModel = UserModel();
  int end = 5;
  int i = 1;

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
    //await Future.delayed(Duration(milliseconds: 100));
    // if failed,use refreshFailed()
    // userModel = await context.read<LoginProvider>().getUser(context);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  getData() async {
   // await Future.delayed(Duration(milliseconds: 100));
    totalList =
    await context.read<WalletProvider>().getManyTransactionList(context);
    print(totalList);
    if (totalList.length < end) {
      end = totalList.length;
    }
    tracList = totalList.sublist(0, end);
    //userModel = await context.read<LoginProvider>().getUser(context);
    //  print("User: ${userModel.fullName}");
    //  print("TracList: ${tracList.length}");
  }

  void _onLoading() async {
    i++;
    end = end * i;
    if (totalList.length < end) {
      end = totalList.length;
    }
    tracList = totalList.sublist(0, end);
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Container(margin:EdgeInsets.only(right:40),
            child: Text("Wallet"),
          ),
        ),

      ),
     body: SmartRefresher(
       enablePullDown: true,
       enablePullUp: true,
       header: WaterDropHeader(),
       footer: CustomFooter(
         builder: (BuildContext context,LoadStatus mode){
           Widget body ;
           if(mode==LoadStatus.idle){
             body =  Text("pull up load");
           }
           else if(mode==LoadStatus.loading){
             body =  CupertinoActivityIndicator();
           }
           else if(mode == LoadStatus.failed){
             body = Text("Load Failed!Click retry!");
           }
           else if(mode == LoadStatus.canLoading){
             body = Text("release to load more");
           }
           else{
             body = Text("No more Data");
           }
           return Container(
             height: 55.0,
             child: Center(child:body),
           );
         },
       ),
       controller: _refreshController,
       onRefresh: _onRefresh,
       onLoading: _onLoading,
       child: Container(
         child: ListView.builder(
           itemBuilder: (c, i) => Card(
             margin: EdgeInsets.symmetric(
                 horizontal: 15, vertical: 5),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(2.0),
             ),
             elevation: 2,
             child: Center(
               child: Column(
                 children: [
                   ListTile(
                     title: Column(
                       children: <Widget>[
                         Row(
                           children: [
                             tracList[i].type ==
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
                                         fontWeight:
                                         FontWeight.bold)),
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
                           length:
                           MediaQuery.of(context).size.width *
                               0.7,
                           dashLength: 2,
                         ),
                         Row(
                           children: [
                             Column(
                               children: [
                                 Text("Top up successful",
                                     style: TextStyle(
                                         fontSize: 13)),
                               ],
                             ),
                             Spacer(),
                             Image.asset(
                                 "assets/payment/success.png",
                                 width: 20,
                                 height: 20)
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
      // body: CustomScrollView(slivers: <Widget>[
      //   SliverAppBar(
      //     iconTheme: IconThemeData(color: Colors.white),
      //     backgroundColor: Color(0xfffa2e73),
      //     pinned: true,
      //     snap: false,
      //     floating: false,
      //   ),
      //   SliverToBoxAdapter(
      //
      //     // child: Container(
      //     //     constraints: BoxConstraints.expand(
      //     //       height: MediaQuery.of(context).size.height,
      //     //     ),
      //     //     child: Container(
      //     //       child: Column(
      //     //         children: <Widget>[
      //     //           // Container(
      //     //           //   margin: EdgeInsets.all(10),
      //     //           //   color: Colors.transparent,
      //     //           //   child: Row(
      //     //           //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     //           //     children: [
      //     //           //       Expanded(
      //     //           //         child: ElevatedButton(
      //     //           //             style: ElevatedButton.styleFrom(
      //     //           //               // primary: Colors.white,
      //     //           //                 padding: EdgeInsets.only(
      //     //           //                   left: 15,
      //     //           //                   right: 15,
      //     //           //                   top: 10,
      //     //           //                   bottom: 10,
      //     //           //                 ) // foreground
      //     //           //             ),
      //     //           //             onPressed: () {
      //     //           //               Navigator.of(context).push(MaterialPageRoute(
      //     //           //                   builder: (contex) => TopUpPage()));
      //     //           //             },
      //     //           //             child: Row(
      //     //           //               children: [
      //     //           //                 Icon(Icons.cached),
      //     //           //                 SizedBox(width: 5),
      //     //           //                 Text("Top Up"),
      //     //           //               ],
      //     //           //             )),
      //     //           //       ),
      //     //           //
      //     //           //
      //     //           //       SizedBox(width: 5),
      //     //           //       Expanded(
      //     //           //         child: ElevatedButton(
      //     //           //             style: ElevatedButton.styleFrom(
      //     //           //                 padding: EdgeInsets.only(
      //     //           //                   left: 15,
      //     //           //                   right: 15,
      //     //           //                   top: 10,
      //     //           //                   bottom: 10,
      //     //           //                 ) // foreground
      //     //           //             ),
      //     //           //             onPressed: () {
      //     //           //               Navigator.of(context).push(MaterialPageRoute(
      //     //           //                   builder: (contex) => WithdrawalPage()));
      //     //           //             },
      //     //           //             child: Row(
      //     //           //               children: [
      //     //           //                 Icon(Icons.payments),
      //     //           //                 SizedBox(width: 5),
      //     //           //                 Text("Withdrawal"),
      //     //           //               ],
      //     //           //             )),
      //     //           //       ),
      //     //           //     ],
      //     //           //   ),
      //     //           // ),
      //     //           // SizedBox(height: 20,),
      //     //           Flexible(
      //     //             child: Container(
      //     //               child: SmartRefresher(
      //     //                 enablePullDown: true,
      //     //                 enablePullUp: true,
      //     //                 header: WaterDropHeader(),
      //     //                 footer: CustomFooter(
      //     //                   builder: (BuildContext context, mode) {
      //     //                     Widget body;
      //     //                     if (mode == LoadStatus.idle) {
      //     //                       body = Text("pull up load");
      //     //                     } else if (mode == LoadStatus.loading) {
      //     //                       body = CupertinoActivityIndicator();
      //     //                     } else if (mode == LoadStatus.failed) {
      //     //                       body = Text("Load Failed!Click retry!");
      //     //                     } else if (mode == LoadStatus.canLoading) {
      //     //                       body = Text("release to load more");
      //     //                     } else {
      //     //                       body = Text("No more Data");
      //     //                     }
      //     //                     return Container(
      //     //                       height: 55.0,
      //     //                       child: Center(child: body),
      //     //                     );
      //     //                   },
      //     //                 ),
      //     //                 controller: _refreshController,
      //     //                 onRefresh: _onRefresh,
      //     //                 onLoading: _onLoading,
      //     //                 child: Container(
      //     //                   child: ListView.builder(
      //     //                     itemBuilder: (c, i) => Card(
      //     //                       margin: EdgeInsets.symmetric(
      //     //                           horizontal: 15, vertical: 5),
      //     //                       shape: RoundedRectangleBorder(
      //     //                         borderRadius: BorderRadius.circular(2.0),
      //     //                       ),
      //     //                       elevation: 2,
      //     //                       child: Center(
      //     //                         child: Column(
      //     //                           children: [
      //     //                             ListTile(
      //     //                               title: Column(
      //     //                                 children: <Widget>[
      //     //                                   Row(
      //     //                                     children: [
      //     //                                       tracList[i].type ==
      //     //                                           TransactionType.Topup
      //     //                                           ? Image.asset(
      //     //                                         "assets/payment/topup.png",
      //     //                                         width: 50,
      //     //                                         height: 50,
      //     //                                       )
      //     //                                           : Image.asset(
      //     //                                         "assets/payment/withdraw.png",
      //     //                                         width: 50,
      //     //                                         height: 50,
      //     //                                       ),
      //     //                                       Column(
      //     //                                         mainAxisAlignment:
      //     //                                         MainAxisAlignment.center,
      //     //                                         children: [
      //     //                                           Text(
      //     //                                               tracList[i].type ==
      //     //                                                   TransactionType.Topup
      //     //                                                   ? "Top Up"
      //     //                                                   : "Withdraw",
      //     //                                               style: TextStyle(
      //     //                                                   fontSize: 14,
      //     //                                                   fontWeight:
      //     //                                                   FontWeight.bold)),
      //     //                                           Text(
      //     //                                               Formatter.dateTimeFormat(
      //     //                                                   tracList[i].createdDate),
      //     //                                               style: TextStyle(fontSize: 12)),
      //     //                                         ],
      //     //                                       ),
      //     //                                       Spacer(),
      //     //                                       Text(tracList[i].amount.toString(),
      //     //                                           style: TextStyle(
      //     //                                               fontSize: 14,
      //     //                                               color: tracList[i].type ==
      //     //                                                   TransactionType.Topup
      //     //                                                   ? Colors.green
      //     //                                                   : Colors.red)),
      //     //                                       IconButton(
      //     //                                           onPressed: () {
      //     //                                             //Navigator.push(context, MaterialPageRoute(builder: (context)=>new WalletDetailSuccessPage(docId:doc.id)));
      //     //                                           },
      //     //                                           icon: Icon(
      //     //                                             Icons.arrow_forward_ios_rounded,
      //     //                                             size: 18,
      //     //                                           ))
      //     //                                     ],
      //     //                                   ),
      //     //                                   Dash(
      //     //                                     direction: Axis.horizontal,
      //     //                                     length:
      //     //                                     MediaQuery.of(context).size.width *
      //     //                                         0.7,
      //     //                                     dashLength: 2,
      //     //                                   ),
      //     //                                   Row(
      //     //                                     children: [
      //     //                                       Column(
      //     //                                         children: [
      //     //                                           Text("Top up successful",
      //     //                                               style: TextStyle(
      //     //                                                   fontSize: 13)),
      //     //                                         ],
      //     //                                       ),
      //     //                                       Spacer(),
      //     //                                       Image.asset(
      //     //                                           "assets/payment/success.png",
      //     //                                           width: 20,
      //     //                                           height: 20)
      //     //                                     ],
      //     //                                   ),
      //     //                                 ],
      //     //                               ),
      //     //                             ),
      //     //                           ],
      //     //                         ),
      //     //                       ),
      //     //                     ),
      //     //                     itemExtent: 100.0,
      //     //                     itemCount: tracList.length,
      //     //                   ),
      //     //                 ),
      //     //               ),
      //     //             ),
      //     //           ),
      //     //         ],
      //     //       ),
      //     //     )),
      //   ),
      // ]),
    );
  }
}
