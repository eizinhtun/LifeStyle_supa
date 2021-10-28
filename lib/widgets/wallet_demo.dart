// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/wallet_detail_success_page.dart';

class WalletDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My uploaded unit',
      home: new WalletDemoPage(),
    );
  }
}

class WalletDemoPage extends StatefulWidget {
  const WalletDemoPage({Key key}) : super(key: key);

  @override
  WalletDemoPageState createState() => new WalletDemoPageState();
}

class WalletDemoPageState extends State<WalletDemoPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 40),
            child: Text("Wallet"),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _searchShow(context);
                setState(() {});
              },
              icon: Icon(
                Icons.filter_alt_rounded,
                size: 20,
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection(transactions)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(manyTransaction)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((doc) {
                TransactionModel item = TransactionModel.fromJson(doc.data());
                return Column(
                  children: [
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                item.type == TransactionType.Topup
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
                                        item.type == TransactionType.Topup
                                            ? "Top Up"
                                            : "Withdraw",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        Formatter.dateTimeFormat(
                                            item.createdDate),
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Spacer(),
                                Text(item.amount.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            item.type == TransactionType.Topup
                                                ? Colors.green
                                                : Colors.red)),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  new WalletDetailSuccessPage(
                                                      docId: doc.id)));
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
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return Text("No data found");
          }
        },
      ),
    );
  }

  @override
  void showError(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        content: new Text(Tran.of(context).text(text))));
  }

  _searchDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: SizedBox.expand(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Wrap(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Sample type",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Expanded(flex: 1, child: Text(""))
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ));
        });
      },
    );
  }

  _searchShow(context) {
    return showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text("hello")],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
