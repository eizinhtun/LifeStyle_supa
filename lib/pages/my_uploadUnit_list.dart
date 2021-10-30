// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/my_read_unit.dart';
import 'package:left_style/pages/upload_my_read.dart';
import 'package:flutter_dash/flutter_dash.dart';

class MyUploadUnitList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My uploaded unit',
      home: new MyUploadUnitListPage(),
    );
  }
}

class MyUploadUnitListPage extends StatefulWidget {
  const MyUploadUnitListPage({Key key}) : super(key: key);

  @override
  MyUploadUnitListPageState createState() => new MyUploadUnitListPageState();
}

class MyUploadUnitListPageState extends State<MyUploadUnitListPage>
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
        title: Text(Tran.of(context).text("my_uploaded_unit").toString()),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection(userUploadUnitCollection)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(userReadUnitCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data.docs.map((doc) {
                MyReadUnit item = MyReadUnit.fromJson(doc.data());
                return Card(
                  margin: EdgeInsets.only(top: 7, left: 5, right: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new UploadMyReadScreen(
                                        customerId: item.customerId,
                                        monthName: item.monthName,
                                      )));
                        },
                        contentPadding: EdgeInsets.only(
                            top: 5.0, left: 0.0, right: 0.0, bottom: 0.0),
                        leading: Container(
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
                                CachedNetworkImageProvider(item.readImageUrl),
                            // NetworkImage(item.readImageUrl),
                          ),
                        ),
                        title: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.meterNo + " ," + item.customerId,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(item.readDate
                                  .toDate()
                                  .toString() //yyy-MM-ddTHH:mm:ss
                                  .toString()),
                            ),
                            Text(
                              item.consumerName + " - " + item.mobile,
                              style: TextStyle(
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
                            //           EdgeInsets.only(top: 5),
                            //       child: Text(item
                            //           .remark
                            //           .toString()),
                            //     )),
                          ],
                        ),
                        trailing: Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      NumberFormat('#,###,000')
                                          .format(item.readUnit),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
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
                          padding: EdgeInsets.only(
                              left: 20, top: 5, bottom: 10, right: 20),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                alignment: Alignment.center,
                                child: Text(
                                  item.status + "    (" + item.monthName + ")",
                                  style: TextStyle(
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

  // @override
  // void showError(String text) {
  //   _scaffoldKey.currentState.showSnackBar(new SnackBar(
  //       backgroundColor: Colors.red,
  //       content: new Text(Tran.of(context).text(text))));
  // }

  // @override
  // void showMessage(String text) {
  //   MessageHandler.showMessage(context, "", text);
  // }
}
