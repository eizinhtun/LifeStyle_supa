// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/meter_bill.dart';
import 'package:left_style/models/my_read_unit.dart';
import 'package:left_style/pages/my_meterBill_detail.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:flutter_dash/flutter_dash.dart';

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

  List<String> customerIds =
      // [];
      ["7324392739"];
  // //"7324392739"
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
        title: Center(
          child: Container(
              margin: EdgeInsets.only(right: 40),
              child: Text(Tran.of(context).text("my_meter_bills").toString())),
        ),
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
                        print(doc.data());
                        // isPaid = doc.get("isPaid");
                        MeterBill bill = MeterBill.fromJson(doc.data());
                        MyReadUnit item = MyReadUnit.fromJson(doc.data());
                        print(item);
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
                                top: 7, left: 5, right: 5, bottom: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3,
                            child: Column(
                              children: [
                                // ListTile(
                                //   contentPadding: EdgeInsets.only(
                                //       top: 5.0,
                                //       left: 0.0,
                                //       right: 0.0,
                                //       bottom: 0.0),
                                //   leading: Container(
                                //     padding: EdgeInsets.only(left: 10),
                                //     alignment: Alignment.center,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       border: Border.all(
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //     width: 60,
                                //     height: 60,
                                //     child: new CircleAvatar(
                                //       radius: 100.0,
                                //       // backgroundColor:MyTheme.getPrimaryColor(),
                                //       //backgroundImage: MeScreenState.fileAvatar!=null?
                                //       // FileImage(fileAvatar):
                                //       backgroundImage:
                                //           NetworkImage(item.readImageUrl),
                                //     ),
                                //   ),
                                //   title: Container(
                                //       alignment: Alignment.centerLeft,
                                //       child: Text(
                                //         item.meterNo + " ," + item.customerId,
                                //         style: TextStyle(
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.bold),
                                //       )),
                                //   subtitle: Column(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Container(
                                //         padding: EdgeInsets.only(top: 5),
                                //         child: Text(
                                //           getDate(item.readDate.toDate()),
                                //         ),
                                //       ),
                                //       Text(
                                //         "${item.consumerName} - ${item.mobile}",
                                //         style: TextStyle(
                                //             color: Colors.black,
                                //             fontWeight: FontWeight.w600),
                                //       ),
                                //       // Visibility(
                                //       //     visible: item.remark !=
                                //       //             null &&
                                //       //         item.remark.length >
                                //       //             0,
                                //       //     child: Container(
                                //       //       padding:
                                //       //           EdgeInsets.only(top: 5),
                                //       //       child: Text(item
                                //       //           .remark
                                //       //           .toString()),
                                //       //     )),
                                //     ],
                                //   ),
                                //   trailing: Container(
                                //       padding: EdgeInsets.only(right: 20),
                                //       child: Column(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: [
                                //           Wrap(
                                //             children: [
                                //               Text(
                                //                 "${NumberFormat('#,###,000').format(item.readUnit)}",
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontWeight:
                                //                         FontWeight.w600),
                                //               ),
                                //               Padding(
                                //                 padding:
                                //                     EdgeInsets.only(left: 10.0),
                                //                 child: Icon(
                                //                   Icons.arrow_forward_ios,
                                //                   size: 16,
                                //                   color: Colors.black,
                                //                 ),
                                //               )
                                //             ],
                                //           ),
                                //         ],
                                //       )),
                                //   dense: true,
                                // ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        // backgroundColor:MyTheme.getPrimaryColor(),
                                        //backgroundImage: MeScreenState.fileAvatar!=null?
                                        // FileImage(fileAvatar):
                                        backgroundImage:
                                            NetworkImage(item.readImageUrl),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            item.meterNo +
                                                " ," +
                                                item.customerId,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(bill.monthName +
                                                    " : " +
                                                    bill.unitsToPay.toString() +
                                                    " Unit"
                                                // bill.readUnit
                                                // NumberFormat('#,###,000').format(item.readUnit)
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //     padding: EdgeInsets.only(right: 20),
                                    //     child: Column(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         Wrap(
                                    //           children: [
                                    //             Text(
                                    //               "${NumberFormat('#,###,000').format(item.readUnit)}",
                                    //               style: TextStyle(
                                    //                   color: Colors.black,
                                    //                   fontWeight:
                                    //                       FontWeight.w600),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     )),
                                  ],
                                ),

                                Dash(
                                  direction: Axis.horizontal,
                                  length:
                                      MediaQuery.of(context).size.width * 0.85,
                                  dashLength: 2,
                                  /////// dashColor: sysData.mainColor
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        top: 5,
                                        bottom: 10,
                                        right: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          alignment: Alignment.center,
                                          child: Text(
                                            item.status +
                                                "    (" +
                                                item.monthName +
                                                ")",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    )),
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
