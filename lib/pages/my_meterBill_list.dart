// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/meter_bill.dart';
import 'package:left_style/pages/my_meterBill_detail.dart';
import 'package:left_style/utils/formatter.dart';

class MyMeterBillList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My uploaded unit',
      home: new MyMeterBillListPage(),
    );
  }
}

class MyMeterBillListPage extends StatefulWidget {
  const MyMeterBillListPage({Key key}) : super(key: key);

  @override
  MyMeterBillListPageState createState() => new MyMeterBillListPageState();
}

class MyMeterBillListPageState extends State<MyMeterBillListPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;

  List<String> customerIds = ["7324392739"];

  bool _isLoading = true;

  @override
  void initState() {
    getBandingMeterList();
    super.initState();
  }

  getBandingMeterList() async {
    var data = db
        .collection(meterCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(userMeterCollection)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          customerIds.add(element.id);
        });
      }

      setState(() {
        _isLoading = false;
      });
    });
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
        title: Text(Tran.of(context).text("my_meter_bills").toString()),
        /*flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF001950),Color(0xFF04205a),Color(0xFF0b2b6a),
                   Color(0xFF0b2b6a),Color(0xFF2253a2), Color(0xFF2253a2)],
              )
         ),
        ),*/
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection(meterBillsCollection)
                  .where(FieldPath.documentId, whereIn: customerIds)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                    child: ListView(
                      children: snapshot.data.docs.map((doc) {
                        MeterBill bill = MeterBill.fromJson(doc.data());
                        // MyReadUnit item = MyReadUnit.fromJson(doc.data());
                        print(bill.readImageUrl);
                        return InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MeterBillDetailPage(docId: doc.id),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            elevation: 1,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                          width: 60,
                                          height: 60,
                                          child: new CircleAvatar(
                                            radius: 100.0,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              bill.readImageUrl,
                                            ),

                                            // NetworkImage(bill.readImageUrl),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(top: 10),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "No:" +
                                                    bill.billNo +
                                                    " ," +
                                                    bill.meterNo,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      bill.monthName + "  ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(bill.unitsToPay
                                                                .toString() +
                                                            " Unit  " +
                                                            bill.totalCost
                                                                .toString() +
                                                            " Ks"
                                                        // bill.readUnit
                                                        // NumberFormat('#,###,000').format(item.readUnit)
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(bill.consumerName +
                                                      " - " +
                                                      bill.state
                                                  // bill.readUnit
                                                  // NumberFormat('#,###,000').format(item.readUnit)
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            top: 5,
                                            bottom: 10,
                                            right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              alignment: Alignment.centerRight,
                                              child: bill.isPaid
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green
                                                              .withOpacity(0.8),
                                                        ),
                                                        Text(
                                                          " paid",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color:
                                                                  Colors.green),
                                                        )
                                                      ],
                                                    )
                                                  : Text(
                                                      "Due date " +
                                                          bill.dueDate,
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.black26,
                                                          fontSize: 12),
                                                    ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                bill.isPaid
                                                    ? bill.payDate
                                                    : Formatter.getDate(new DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                        bill.readDate
                                                            .millisecondsSinceEpoch)),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black26,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                Visibility(
                                  visible: !bill.isPaid &&
                                      bill.status.toLowerCase() == "paid",
                                  child: Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
    );
  }

  String getDate(DateTime date) {
    var dateFormat =
        DateFormat("dd-MM-yyyy hh:mm a"); // you can change the format here
    return dateFormat.format(date);
  }
}
