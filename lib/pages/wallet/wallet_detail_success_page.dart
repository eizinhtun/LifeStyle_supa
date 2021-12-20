// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/formatter.dart';

class WalletDetailSuccessPage extends StatefulWidget {
  final String docId;
  final String type;
  final String status;
  const WalletDetailSuccessPage({Key key, this.docId, this.type, this.status})
      : super(key: key);

  @override
  _WalletDetailSuccessPageState createState() =>
      _WalletDetailSuccessPageState();
}

class _WalletDetailSuccessPageState extends State<WalletDetailSuccessPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    //Locale myLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.type.toString() == TransactionType.Withdraw
              ? Tran.of(context)
                  .text("withdrawal_pending_detail_title")
                  .toString()
              : Tran.of(context).text("topup_pending_detail_title").toString(),
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          checkTypeAndStatus(context),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db.collection(transactions).doc(widget.docId).snapshots(),
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
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 8.0, right: 8.0, bottom: 0.0),
                  child: Container(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(bottom: 5),
                              alignment: Alignment.center,
                              width: 60,
                              height: 60,
                              child: item.paymentLogoUrl == null ||
                                      item.paymentLogoUrl == ""
                                  ? CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 100.0,
                                      backgroundImage: AssetImage(
                                        'assets/image/mobile-card.png',
                                        // 'assets/image/meter_payment.png',
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      radius: 100.0,
                                      backgroundImage: NetworkImage(
                                        item.paymentLogoUrl,
                                      ),
                                    ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                      Tran.of(context)
                                          .text(
                                              item.status.trim().toLowerCase())
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: getStatusColor(item.status
                                              .trim()
                                              .toLowerCase()))),
                                  Text(Formatter.balanceFormat(item.amount),
                                      style: TextStyle(
                                          color: item.amount > 0
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
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
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(Tran.of(context)
                                      .text("transaction_detail_date")),
                                  Spacer(),
                                  Text(
                                      Formatter.getDates(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.createdDate
                                                  .millisecondsSinceEpoch)),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(Tran.of(context)
                                      .text("transaction_detail_time")),
                                  Spacer(),
                                  Text(
                                      Formatter.getHour(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.createdDate
                                                  .millisecondsSinceEpoch)),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(Tran.of(context)
                                      .text("transaction_detail_type")),
                                  Spacer(),
                                  Text(item.type,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(Tran.of(context)
                                      .text("transaction_detail_bank")),
                                  Spacer(),
                                  Text(item.paymentType,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(Tran.of(context)
                                      .text("transaction_detail_amount")),
                                  Spacer(),
                                  Text(
                                      Formatter.balanceFormat(item.amount) +
                                          " (" +
                                          Tran.of(context).text("ks") +
                                          ")",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        OutlinedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: Colors.white24,
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 10,
                                bottom: 10,
                              ),
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            Tran.of(context).text("cancel"),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
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
              return Center(child: Text(Tran.of(context).text("no_data")));
            }
          }),
    );
  }

  Color getStatusColor(status) {
    switch (status) {
      case "approved":
        return Colors.green;
        break;
      default:
        return Colors.red;
        break;
    }
  }

  Widget checkTypeAndStatus(context) {
    if ((widget.type == "topup" || widget.type == "withdraw") &&
        (widget.status.trim().toLowerCase() == "verifying" ||
            widget.status.trim().toLowerCase() == "rejected")) {
      return IconButton(
          onPressed: () async {
            showAlertDialog(context);
            setState(() {});
          },
          icon: Icon(Icons.delete));
    } else {
      return Container();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = OutlinedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          primary: Colors.white24,
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
            top: 10,
            bottom: 10,
          ),
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () async {
        Navigator.of(context).pop();
      },
      child: Text(
        Tran.of(context).text("cancel"),
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );

    Widget continueButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
              bottom: 10,
            ) // foreground
            ),
        onPressed: () async {
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          await db
              .collection(transactions)
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection(manyTransaction)
              .doc(widget.docId)
              .delete();
        },
        child: Text(Tran.of(context).text("ok")));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Tran.of(context).text("delete_confirm")),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            cancelButton,
            continueButton,
          ],
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
