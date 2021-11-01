// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/Meter.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'map_screen.dart';

class MeterSearchDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MeterSearchDetailPage(),
    );
  }
}

class MeterSearchDetailPage extends StatefulWidget {
  final Meter obj;

  const MeterSearchDetailPage({
    Key key,
    this.obj,
  }) : super(key: key);

  @override
  MeterSearchDetailPageState createState() => new MeterSearchDetailPageState();
}

class MeterSearchDetailPageState extends State<MeterSearchDetailPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isExist = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkExist();
  }

  Future<bool> checkExist() async {
    var value = await FirebaseFirestore.instance
        .collection(meterCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(userMeterCollection)
        .doc(widget.obj.customerId)
        .get();
    if (value.exists) {
      setState(() {
        isExist = true;
        _isLoading = false;
      });

      return true;
      // Meter meter = Meter.fromJson(value.data());
    } else {
      setState(() {
        isExist = false;
        _isLoading = false;
      });
      return false;
    }
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
        centerTitle: true,
        title: Text(Tran.of(context).text("meter_detail").toString()),
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
      body: Column(
        children: [
          new Divider(
            height: 1.0,
            color: Colors.grey.withOpacity(0.3),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    //padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.only(
                              top: 7, left: 5, right: 5, bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.only(
                                      top: 5.0,
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0),
                                  leading: Container(
                                    padding: EdgeInsets.all(0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    width: 60,
                                    height: 60,
                                    child: isExist
                                        ? Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 40,
                                          )
                                        : new CircleAvatar(
                                            radius: 100.0,
                                            // backgroundColor:MyTheme.getPrimaryColor(),
                                            //backgroundImage: MeScreenState.fileAvatar!=null?
                                            // FileImage(fileAvatar):
                                            /* backgroundImage: NetworkImage(
                                            "paymentLogoUrl")*/
                                            /* NetworkImage(

                                                  ),*/
                                          ),
                                    /*CachedNetworkImage(
                                            imageUrl: "https://firebasestorage.googleapis.com/v0/b/userthai2d3d.appspot.com/o/resources%2Fcbpay.png?alt=media",
                                            placeholder: (context, url) => SpinKitChasingDots(color: Colors.black26,),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),*/
                                  ),
                                  title: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.obj.meterNo,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          Formatter.getDate(
                                            widget.obj.insertDate.toDate(),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        widget.obj.customerId +
                                            " : " +
                                            widget.obj.categoryName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // Visibility(
                                      //     visible: items[index].remark !=
                                      //             null &&
                                      //         items[index].remark.length >
                                      //             0,
                                      //     child: Container(
                                      //       padding:
                                      //           EdgeInsets.only(top: 5),
                                      //       child: Text(items[index]
                                      //           .remark
                                      //           .toString()),
                                      //     )),
                                    ],
                                  ),
                                  trailing: Container(
                                      // padding: EdgeInsets.only(right: 20),
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        children: [
                                          Text(
                                            NumberFormat('#,###,000').format(
                                                    widget.obj.lastReadUnit) +
                                                " Unit",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          /* Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                              )*/
                                        ],
                                      ),
                                    ],
                                  )),
                                  dense: true,
                                ),
                                Dash(
                                  direction: Axis.horizontal,
                                  length:
                                      MediaQuery.of(context).size.width * 0.85,
                                  dashLength: 2,
                                  /////// dashColor: sysData.mainColor
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.obj.consumerName +
                                        " - " +
                                        (widget.obj.mobile == null
                                            ? ""
                                            : widget.obj.mobile),
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(top: 0, bottom: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${widget.obj.houseNo}",
                                          // + widget.obj.block + widget.obj.street
                                          maxLines: 3,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Visibility(
                                        visible: widget.obj.latitude != null &&
                                            widget.obj.longitude != null,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapScreen(
                                                            meter: widget.obj,
                                                          )));
                                            },
                                            icon: Icon(
                                              Icons.location_on,
                                              color: Colors.blue,
                                              size: 30,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Dash(
                                  direction: Axis.horizontal,
                                  length:
                                      MediaQuery.of(context).size.width * 0.80,
                                  dashLength: 2,
                                  /////// dashColor: sysData.mainColor
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Read Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Formatter.getDate(
                                            widget.obj.readDate.toDate()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Last Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Formatter.getDate(
                                            widget.obj.dueDate.toDate()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Due Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Formatter.getDate(
                                            widget.obj.dueDate.toDate()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Dash(
                                  direction: Axis.horizontal,
                                  length:
                                      MediaQuery.of(context).size.width * 0.8,
                                  dashLength: 2,
                                  /////// dashColor: sysData.mainColor
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Horse Power",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        NumberFormat('#,###,000')
                                            .format(widget.obj.horsePower),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Horse Power Cost",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        NumberFormat('#,###,000').format(
                                                widget.obj.horsePowerCost) +
                                            " Kyat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                Dash(
                                  direction: Axis.horizontal,
                                  length:
                                      MediaQuery.of(context).size.width * 0.8,
                                  dashLength: 2,
                                  /////// dashColor: sysData.mainColor
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Charge Per Unit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        NumberFormat('#,###,000').format(
                                                widget.obj.chargePerUnit) +
                                            " Kyat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Maintainence Cost",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        NumberFormat('#,###,000').format(
                                                widget.obj.maintainenceCost) +
                                            " Kyat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _isLoading
                            ? Positioned(
                                bottom: 10,
                                right: 10,
                                child: Center(
                                    child: SpinKitDoubleBounce(
                                  color: Colors.green,
                                )))
                            : Positioned(
                                bottom: 10,
                                right: 10,
                                child: isExist
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.white, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        child: new Text('Close',
                                            style: new TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black54)),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                      )
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red)))),

                                        // color: Colors.black12,
                                        child: new Text('Add',
                                            style: new TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                        onPressed: () async {
                                          bool isMeterExist =
                                              await checkExist();
                                          if (isMeterExist) {
                                            MessageHandler.showMessage(
                                                context,
                                                "",
                                                "This Meter is already added");
                                            return;
                                          }

                                          if (FirebaseAuth
                                                  .instance.currentUser?.uid !=
                                              null) {
                                            String uid = FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString();
                                            await FirebaseFirestore.instance
                                                .collection(meterCollection)
                                                .doc(uid)
                                                .collection(userMeterCollection)
                                                .doc(widget.obj.customerId)
                                                .set(widget.obj.toJson());

                                            Navigator.pop(context, true);
                                            MessageHandler.showMessage(
                                                context,
                                                "",
                                                "This Meter is successfully added");
                                          }
                                        },
                                      ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void showMessage(String text) {
  //   MessageHandler.showMessage(context, "", text);
  // }
}
