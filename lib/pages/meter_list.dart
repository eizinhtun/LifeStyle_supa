// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_model.dart';
import 'package:left_style/pages/meter_edit_page.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:barcode_scan_fix/barcode_scan.dart' as bar;
import 'meter_city_page.dart';
import 'meter_search_result.dart';

import 'package:left_style/utils/show_message_handler.dart';

class MeterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Meters',
      home: MeterListPage(),
    );
  }
}

class MeterListPage extends StatefulWidget {
  static const String route = '/meterlist';
  const MeterListPage({Key key}) : super(key: key);

  @override
  MeterListPageState createState() => MeterListPageState();
}

class MeterListPageState extends State<MeterListPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;
  String meterBarcode = "";

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Tran.of(context).text("my_meters").toString()),
        actions: [
          IconButton(
            onPressed: () async {
              await addNewMeter(context);
            },
            icon: Icon(
              // Icons.add,
              Icons.add_circle_outline,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection(meterCollection)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(userMeterCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data.docs.map((doc) {
                Meter item = Meter.fromJson(doc.data());
                return Card(
                  margin: const EdgeInsets.only(
                      top: 0, left: 5, right: 5, bottom: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MeterEditPage(obj: item)));
                        },
                        contentPadding: const EdgeInsets.only(
                            top: 5.0, left: 0.0, right: 0.0, bottom: 0.0),
                        leading: Container(
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 40,
                              color: Colors.green,
                            )

                            /*CircleAvatar(
                              radius: 100.0,
                              // backgroundColor:MyTheme.getPrimaryColor(),
                              //backgroundImage: MeScreenState.fileAvatar!=null?
                              // FileImage(fileAvatar):
                              */ /*backgroundImage: NetworkImage(
                                          "paymentLogoUrl")*/ /*
                              */ /* NetworkImage(

                    ),*/ /*
                            ),
                            */
                            ),
                        title: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (item.meterName != null && item.meterName != "")
                                  ? "${item.meterNo} (${item.meterName})"
                                  : "${item.meterNo}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(item.insertDate),
                            ),

                            Text(
                              item.customerId + " : " + item.categoryName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            // Visibility(
                            //     visible: item.remark !=
                            //             null &&
                            //         item.remark.length >
                            //             0,
                            //     child: Container(
                            //       padding:
                            //           const EdgeInsets.only(top: 5),
                            //       child: Text(item
                            //           .remark
                            //           .toString()),
                            //     )),
                          ],
                        ),
                        // trailing: Container(
                        //     padding: const EdgeInsets.only(right: 20),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Wrap(
                        //           children: [
                        //             Text(
                        //               NumberFormat('#,###,000')
                        //                       .format(item.lastReadUnit) +
                        //                   " Unit",
                        //               style: const TextStyle(
                        //                   color: Colors.black,
                        //                   fontWeight: FontWeight.w600),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.only(left: 10.0),
                        //               child: Icon(
                        //                 Icons.arrow_forward_ios,
                        //                 size: 16,
                        //                 color: Colors.black,
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ],
                        //     )),

                        dense: true,
                      ),
                      Dash(
                        direction: Axis.horizontal,
                        length: MediaQuery.of(context).size.width * 0.85,
                        dashLength: 2,
                        /////// dashColor: sysData.mainColor
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, bottom: 10, right: 20),
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.consumerName + " - " + item.houseNo,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              }).toList(),
            );
        },
      ),
    );
  }

  Future<void> addNewMeter(BuildContext context) async {
    var apiUrl = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MeterCityPage()));

    if (apiUrl != null) {
      var typeResult = await _showAlertDialog(context);
      if (typeResult != null && typeResult == "QR") {
        try {
          String meterBarcode = await bar.BarcodeScanner.scan();

          setState(() => this.meterBarcode = meterBarcode);

          if (meterBarcode != null) {
            var returnResult =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MeterSearchResultPage(
                          searchKey: meterBarcode,
                          apiUrl: apiUrl,
                        )));
            if (returnResult != null && returnResult) {
              ShowMessageHandler.showMessage(
                context,
                Tran.of(context).text("success_added"),
                Tran.of(context).text("meter_added"),
              );
            }
          }
        } on PlatformException catch (e) {
          if (e.code == bar.BarcodeScanner.CameraAccessDenied) {
            setState(() {
              this.meterBarcode = Tran.of(context).text("user_not_grant");
            });
          } else {
            setState(() => this.meterBarcode =
                '${Tran.of(context).text("unknown_str")}: $e');
          }
        } on FormatException {
          setState(() => this.meterBarcode =
              'null (User returned using the "back"-button before scanning anything. Result)');
        } catch (e) {
          setState(() => this.meterBarcode =
              '${Tran.of(context).text("unknown_str")}: $e');
        }
        // try {
        //   String codeSanner = await BarcodeScanner.scan().then((value) {
        //     if (value != null) {
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => MeterSearchResultPage(
        //                 searchKey: value,
        //                 apiUrl: apiUrl,
        //               )));
        //     }
        //   }).catchError((error) {}); //barcode scanner

        // } catch (ex) {
        //
        // }
      } else if (typeResult != null && typeResult == "Key") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MeterSearchResultPage(
                  searchKey: null,
                  apiUrl: apiUrl,
                )));
      }
    }
  }

  Future<String> _showAlertDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.black12,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(Tran.of(context).text("readMeterSearchClose")),
                onPressed: () {
                  Navigator.of(context).pop();
                  return null;
                },
              ),
            ],
            title: Center(
                child: Text(Tran.of(context).text("readMeterSearchTitle"))),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.qr_code,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop("QR");
                    // String codeSanner =
                    //     await BarcodeScanner.scan().then((value) {
                    //   if (value != null) {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             UploadMyReadScreen(customerId: value)));
                    //   }
                    // }).catchError((error) {});
                    // return "QR";
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("Key");
                    return "Key";
                  },
                ),
              ],
            ));
      },
    );
  }
}
