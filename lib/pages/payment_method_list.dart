// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/my_read_unit.dart';
import 'package:left_style/models/payment_method.dart';
import 'package:left_style/pages/my_meterBill_detail.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:flutter_dash/flutter_dash.dart';

class PaymentMethodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My uploaded unit',
      home: new PaymentMethodListPage(),
    );
  }
}

class PaymentMethodListPage extends StatefulWidget {
  const PaymentMethodListPage({Key key}) : super(key: key);

  @override
  PaymentMethodListPageState createState() => new PaymentMethodListPageState();
}

class PaymentMethodListPageState extends State<PaymentMethodListPage>
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
        centerTitle: true,
        title: Text(Tran.of(context).text("payment_method_list")),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection(paymentMethodCollection).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data.docs.map((doc) {
                PaymentMethod item = PaymentMethod.fromJson(doc.data());
                return Card(
                  margin: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 1,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Navigator.of(context).pop(item);
                        },
                        contentPadding: EdgeInsets.only(
                            top: 10.0, left: 0.0, right: 0.0, bottom: 10.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              alignment: Alignment.center,
                              width: 60,
                              height: 60,
                              child: new CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 100.0,
                                backgroundImage: NetworkImage(
                                  item.logoUrl,
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                )),
                          ],
                        ),
                        dense: true,
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
        },
      ),
    );
  }

  getDate(date) {
    DateTime tempDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);
    var dateFormat =
        DateFormat("dd-MM-yyyy hh:mm a"); // you can change the format here
    return dateFormat.format(tempDate);
  }

  @override
  void showError(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        content: new Text(Tran.of(context).text(text))));
  }

  @override
  void showMessage(String text) {
    MessageHandler.showMessage(context, "", text);
  }
}
