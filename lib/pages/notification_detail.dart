// // @dart=2.9
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/foundation.dart';
// import 'package:left_style/models/noti_model.dart';
// import 'package:provider/provider.dart';

// class NotificationDetailPage extends StatefulWidget {
//   NotificationDetailPage({Key key, @required this.items, @required this.status})
//       : super(key: key);
//   NotiModel items;
//   String status;

//   @override
//   _NotificationDetailPage createState() => new _NotificationDetailPage();
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class _NotificationDetailPage extends State<NotificationDetailPage> {
//   String forTime = "PM";
//   String result = "2D";
//   String status = "transcation";
//   String status1 = "success1";
//   String type = "topup1";

//   bool loading = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //sysData.notiCount = 0;
//     widget.status == "false"
//         ? ""
//         : context.read<BetProvider>().getNotiById(context, widget.items.id);
//     //context.read<BetProvider>().notiCount(context,sysData.notiCount);
//     if (!kIsWeb) {
//       markAsRead();
//     }
//   }

//   markAsRead() async {
//     if (widget.items != null && widget.items.messageId != null) {
//       await flutterLocalNotificationsPlugin
//           .cancelAll(); //cancel(0,tag:widget.items.guid);
//     }
//   }

//   String notiStr(String str, String bill, String transactionNo) {
//     str = str.replaceAll('@kyat', bill);
//     str = str.replaceAll('@tracNo', transactionNo);
//     print("NOTI:$str");
//     return str;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Center(
//           child: Container(
//               margin: EdgeInsets.only(right: 40),
//               child: Text(Tran.of(context).text("helloword").toString())),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF001950),
//               Color(0xFF04205a),
//               Color(0xFF0b2b6a),
//               Color(0xFF0b2b6a),
//               Color(0xFF2253a2),
//               Color(0xFF2253a2)
//             ],
//           )),
//         ),
//       ),
//       body: //widget.notification==null?Center(child: SpinKitChasingDots(color: sysData.mainColor,),):
//           SingleChildScrollView(
//         child: Container(
//           color: Colors.grey[100],
//           child: Column(
//             children: [
//               Visibility(
//                 visible:
//                     widget.items.type != null && widget.items.type == "TOPUP",
//                 child: Stack(fit: StackFit.loose, children: <Widget>[
//                   new Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       new Container(
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         width: MediaQuery.of(context).size.width,
//                         //height: 300,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           color: Colors.white,
//                           elevation: 2,
//                           margin: EdgeInsets.only(
//                               left: 7, right: 7, bottom: 5, top: 100),
//                           child: Container(
//                             margin: EdgeInsets.only(
//                                 left: 20, right: 20, top: 40, bottom: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: widget.items.state == "APPROVED"
//                                       ? RichText(
//                                           text: new TextSpan(
//                                             // text: sysData.language=="my"?(Tran.of(context).text("topup_noti_title1")+
//                                             //     (widget.items.transactionNo!=null && widget.items.transactionNo!=""?widget.items.transactionNo:widget.items.accountNo).toString()+
//                                             //     Tran.of(context).text("and")+widget.items.bill+
//                                             //     Tran.of(context).text("noti_topup_success_dec3")):
//                                             // (Tran.of(context).text("noti_topup_success_dec1")+widget.items.bill+
//                                             //     Tran.of(context).text("noti_topup_dec2") + Tran.of(context).text("topup_noti_title1")+
//                                             //     (widget.items.transactionNo!=null && widget.items.transactionNo!=""?widget.items.transactionNo:widget.items.accountNo).toString())
//                                             // ,

//                                             text: notiStr(
//                                                 Tran.of(context)
//                                                     .text("top_up_success"),
//                                                 widget.items.bill.toString(),
//                                                 (widget.items.transactionNo !=
//                                                                 null &&
//                                                             widget.items.transactionNo !=
//                                                                 ""
//                                                         ? widget
//                                                             .items.transactionNo
//                                                         : widget
//                                                             .items.accountNo)
//                                                     .toString()),
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         )
//                                       : RichText(
//                                           text: new TextSpan(
//                                             // text: sysData.language == "my"
//                                             //     ? (Tran.of(context).text("topup_noti_title1") +
//                                             //         (widget.items.transactionNo != null && widget.items.transactionNo != "" ? widget.items.transactionNo : widget.items.accountNo)
//                                             //             .toString() +
//                                             //         Tran.of(context)
//                                             //             .text("and") +
//                                             //         widget.items.bill
//                                             //             .toString() +
//                                             //         Tran.of(context).text(
//                                             //             "noti_topup_denied_dec3"))
//                                             //     : (Tran.of(context).text("noti_topup_denied_dec1") +
//                                             //         widget.items.bill
//                                             //             .toString() +
//                                             //         Tran.of(context).text(
//                                             //             "noti_topup_dec2") +
//                                             //         Tran.of(context).text(
//                                             //             "topup_noti_title1") +
//                                             //         (widget.items.transactionNo != null &&
//                                             //                     widget.items.transactionNo != ""
//                                             //                 ? widget.items.transactionNo
//                                             //                 : widget.items.accountNo)
//                                             //             .toString()
//                                             //             .toString()),

//                                             text: notiStr(
//                                                 Tran.of(context)
//                                                     .text("top_up_denied"),
//                                                 widget.items.bill.toString(),
//                                                 (widget.items.transactionNo !=
//                                                                 null &&
//                                                             widget.items.transactionNo !=
//                                                                 ""
//                                                         ? widget
//                                                             .items.transactionNo
//                                                         : widget
//                                                             .items.accountNo)
//                                                     .toString()),
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                 ),
//                                 Container(
//                                   height: 1.0,
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                                   color: Colors.black,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text:
//                                           Tran.of(context).text("topup_time") +
//                                               " ",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                           text: (widget.items.requestDate !=
//                                                       null
//                                                   ? getDate(widget
//                                                           .items.requestDate)
//                                                       .toString()
//                                                   : "") +
//                                               " " +
//                                               (widget.items.requestDate != null
//                                                   ? getTime(widget
//                                                           .items.requestDate)
//                                                       .toString()
//                                                   : ""),
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               color: sysData.mainColor,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 65,
//                     left: MediaQuery.of(context).size.width * 0.42,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.asset(
//                           "assets/topupnoti.jpg",
//                           width: 60.0,
//                           height: 60.0,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               Visibility(
//                 visible: widget.items.type == "WITHDRAW",
//                 child: Stack(fit: StackFit.loose, children: <Widget>[
//                   new Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       new Container(
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         width: MediaQuery.of(context).size.width,
//                         //height: 300,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           color: Colors.white,
//                           elevation: 2,
//                           margin: EdgeInsets.only(
//                               left: 7, right: 7, bottom: 5, top: 100),
//                           child: Container(
//                             margin: EdgeInsets.only(
//                                 left: 20, right: 20, top: 40, bottom: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: widget.items.state == "APPROVED"
//                                       ? RichText(
//                                           text: new TextSpan(
//                                             // text: sysData.language == "my"
//                                             //     ? (Tran.of(context).text("noti_withdrawal_dec2") +
//                                             //         ((widget.items.accountNo != null &&
//                                             //                 widget.items.accountNo.length >
//                                             //                     5)
//                                             //             ? (widget
//                                             //                     .items.accountNo
//                                             //                     .replaceAll(
//                                             //                         "+959", "09")
//                                             //                     .substring(0, 5)
//                                             //                     .toString() +
//                                             //                 "*** ***")
//                                             //             : widget.items.accountNo
//                                             //                 .toString()) +
//                                             //         Tran.of(context)
//                                             //             .text("and") +
//                                             //         widget.items.bill
//                                             //             .toString() +
//                                             //         Tran.of(context).text(
//                                             //             "noti_withdrawal_success_dec3"))
//                                             //     : (Tran.of(context)
//                                             //             .text("noti_withdrawal_success_dec1") +
//                                             //         widget.items.bill.toString() +
//                                             //         Tran.of(context).text("noti_topup_dec2") +
//                                             //         Tran.of(context).text("noti_withdrawal_dec2") +
//                                             //         ((widget.items.accountNo != null && widget.items.accountNo.length > 5) ? (widget.items.accountNo.replaceAll("+959", "09").substring(0, 5).toString() + "*** ***") : widget.items.accountNo.toString())),

//                                             text: notiStr(
//                                                 Tran.of(context)
//                                                     .text("withdrawal_success"),
//                                                 widget.items.bill.toString(),
//                                                 ((widget.items.accountNo !=
//                                                             null &&
//                                                         widget.items.accountNo
//                                                                 .length >
//                                                             5)
//                                                     ? (widget.items.accountNo
//                                                             .replaceAll(
//                                                                 "+959", "09")
//                                                             .substring(0, 5)
//                                                             .toString() +
//                                                         "*** ***")
//                                                     : widget.items.accountNo
//                                                         .toString())),
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         )
//                                       : RichText(
//                                           text: new TextSpan(
//                                             // text: sysData.language == "my"
//                                             //     ? (Tran.of(context).text("noti_withdrawal_dec2") +
//                                             //         ((widget.items.accountNo != null &&
//                                             //                 widget.items.accountNo.length >
//                                             //                     5)
//                                             //             ? (widget
//                                             //                     .items.accountNo
//                                             //                     .replaceAll(
//                                             //                         "+959", "09")
//                                             //                     .substring(0, 5)
//                                             //                     .toString() +
//                                             //                 "*** ***")
//                                             //             : widget.items.accountNo
//                                             //                 .toString()) +
//                                             //         Tran.of(context)
//                                             //             .text("and") +
//                                             //         widget.items.bill
//                                             //             .toString() +
//                                             //         Tran.of(context).text(
//                                             //             "noti_withdrawal_denied_dec3"))
//                                             //     : (Tran.of(context)
//                                             //             .text("notification_withdrawal_denied") +
//                                             //         widget.items.bill.toString() +
//                                             //         Tran.of(context).text("noti_topup_dec2") +
//                                             //         Tran.of(context).text("noti_withdrawal_dec2") +
//                                             //         ((widget.items.accountNo != null && widget.items.accountNo.length > 5) ? (widget.items.accountNo.replaceAll("+959", "09").substring(0, 5).toString() + "*** ***") : widget.items.accountNo.toString())),
//                                             text: notiStr(
//                                                 Tran.of(context)
//                                                     .text("withdrawal_denied"),
//                                                 widget.items.bill.toString(),
//                                                 ((widget.items.accountNo !=
//                                                             null &&
//                                                         widget.items.accountNo
//                                                                 .length >
//                                                             5)
//                                                     ? (widget.items.accountNo
//                                                             .replaceAll(
//                                                                 "+959", "09")
//                                                             .substring(0, 5)
//                                                             .toString() +
//                                                         "*** ***")
//                                                     : widget.items.accountNo
//                                                         .toString())),
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                 ),
//                                 Container(
//                                   height: 1.0,
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                                   color: Colors.black,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text: Tran.of(context)
//                                           .text("withdrawal_time"),
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                           text: (widget.items.requestDate !=
//                                                       null
//                                                   ? getDate(widget
//                                                           .items.requestDate)
//                                                       .toString()
//                                                   : "") +
//                                               " " +
//                                               (widget.items.requestDate != null
//                                                   ? getTime(widget
//                                                           .items.requestDate)
//                                                       .toString()
//                                                   : ""),
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               color: sysData.mainColor,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 65,
//                     left: MediaQuery.of(context).size.width * 0.42,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.asset(
//                           "assets/withdrawalnoti.jpg",
//                           width: 60.0,
//                           height: 60.0,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               Visibility(
//                 visible: widget.items.type == "2D Results",
//                 child: Stack(fit: StackFit.loose, children: <Widget>[
//                   new Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       new Container(
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         width: MediaQuery.of(context).size.width,
//                         //height: 300,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           color: Colors.white,
//                           elevation: 2,
//                           margin: EdgeInsets.only(
//                               left: 7, right: 7, bottom: 5, top: 100),
//                           child: Container(
//                             margin: EdgeInsets.only(
//                                 left: 20, right: 20, top: 40, bottom: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text: widget.items.fortime == "AM"
//                                           ? Tran.of(context)
//                                               .text("twod_morning")
//                                           : Tran.of(context)
//                                               .text("twod_evening"),
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                             text: " " +
//                                                 widget.items.number.toString(),
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: sysData.mainColor,
//                                                 fontWeight: FontWeight.bold)),
//                                         new TextSpan(
//                                             text: Tran.of(context)
//                                                 .text("towd_is"),
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w600)),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 1.0,
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                                   color: Colors.black,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text: Tran.of(context).text("noti_date") +
//                                           "  " +
//                                           (widget.items.currentdate != null
//                                               ? getDate(
//                                                       widget.items.currentdate)
//                                                   .toString()
//                                               : ""),
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                             text: widget.items.fortime == "AM"
//                                                 ? " 12:01 PM"
//                                                 : " 4:30 PM",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: sysData.mainColor,
//                                                 fontWeight: FontWeight.bold)),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 65,
//                     left: MediaQuery.of(context).size.width * 0.42,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.asset(
//                           widget.items.fortime == "AM"
//                               ? 'assets/2D_morning.jpg'
//                               : 'assets/2D_evening.jpg',
//                           width: 60.0,
//                           height: 60.0,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               Visibility(
//                 visible: widget.items.type == "3D Results",
//                 child: Stack(fit: StackFit.loose, children: <Widget>[
//                   new Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       new Container(
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         width: MediaQuery.of(context).size.width,
//                         //height: 300,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           color: Colors.white,
//                           elevation: 2,
//                           margin: EdgeInsets.only(
//                               left: 7, right: 7, bottom: 5, top: 100),
//                           child: Container(
//                             margin: EdgeInsets.only(
//                                 left: 20, right: 20, top: 40, bottom: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text: Tran.of(context)
//                                           .text("threed_result"),
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                             text: " " +
//                                                 widget.items.number.toString(),
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: sysData.mainColor,
//                                                 fontWeight: FontWeight.bold)),
//                                         new TextSpan(
//                                             text: Tran.of(context)
//                                                 .text("towd_is"),
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w600)),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 1.0,
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                                   color: Colors.black,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text: Tran.of(context).text("noti_date") +
//                                           "  " +
//                                           (widget.items.currentdate != null
//                                               ? getDate(
//                                                       widget.items.currentdate)
//                                                   .toString()
//                                               : ""),
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                             text: " 3:30 PM",
//                                             //(widget.items.currentdate!=null?getTime(widget.items.currentdate).toString():""),
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: sysData.mainColor,
//                                                 fontWeight: FontWeight.bold)),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 65,
//                     left: MediaQuery.of(context).size.width * 0.42,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.asset(
//                           'assets/3D.jpg',
//                           width: 60.0,
//                           height: 60.0,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               Visibility(
//                 visible:
//                     widget.items.type == "All" || widget.items.type == "Others",
//                 child: Stack(fit: StackFit.loose, children: <Widget>[
//                   new Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       new Container(
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         width: MediaQuery.of(context).size.width,
//                         //height: 350,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           color: Colors.white,
//                           elevation: 2,
//                           margin: EdgeInsets.only(
//                               left: 7, right: 7, bottom: 5, top: 100),
//                           child: Container(
//                             margin: EdgeInsets.only(
//                                 left: 20, right: 20, top: 30, bottom: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                                   child: Text(
//                                     widget.items.title != null
//                                         ? widget.items.title
//                                         : "",
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color: sysData.mainColor,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.only(top: 10),
//                                   child: Text(
//                                     widget.items.body != null
//                                         ? widget.items.body
//                                         : "",
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 1.0,
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                                   color: Colors.black,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: RichText(
//                                     text: new TextSpan(
//                                       text: Tran.of(context).text("noti_date") +
//                                           " ",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                       children: <TextSpan>[
//                                         new TextSpan(
//                                           text: (widget.items.currentdate !=
//                                                       null
//                                                   ? getDate(widget
//                                                           .items.currentdate)
//                                                       .toString()
//                                                   : "") +
//                                               " " +
//                                               (widget.items.currentdate != null
//                                                   ? getTime(widget
//                                                           .items.currentdate)
//                                                       .toString()
//                                                   : ""),
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               color: sysData.mainColor,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 65,
//                     left: MediaQuery.of(context).size.width * 0.42,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.asset(
//                           'assets/icon.png',
//                           width: 60.0,
//                           height: 60.0,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               Visibility(
//                 visible: widget.items.type == "WINNER",
//                 child: Column(
//                   children: [
//                     Stack(fit: StackFit.loose, children: <Widget>[
//                       new Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           new Container(
//                             padding: EdgeInsets.only(left: 10, right: 10),
//                             width: MediaQuery.of(context).size.width,
//                             height: 400,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15)),
//                               color: Colors.white,
//                               elevation: 2,
//                               margin: EdgeInsets.only(
//                                   left: 7, right: 7, bottom: 5, top: 100),
//                               child: Container(
//                                 margin: EdgeInsets.only(
//                                   left: 20,
//                                   right: 20,
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding:
//                                           EdgeInsets.only(top: 10, bottom: 10),
//                                       child: Text(
//                                         sysData.name != null
//                                             ? sysData.name
//                                             : "",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     Text(
//                                       widget.items.category != null
//                                           ? widget.items.category == "2D"
//                                               ? Tran.of(context)
//                                                   .text("noti_winner_title2D")
//                                               : Tran.of(context)
//                                                   .text("noti_winner_title3D")
//                                           : "",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.only(top: 10, bottom: 0),
//                                       child: Text(
//                                         widget.items.balance != null
//                                             ? (NumberFormat('###,###,###')
//                                                     .format(
//                                                         widget.items.balance)
//                                                     .toString() +
//                                                 " KS")
//                                             : "",
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             color: sysData.mainColor,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.all(20),
//                                       child: new Divider(
//                                         height: 0.0,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.only(left: 20, right: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 Tran.of(context)
//                                                     .text("bet_time"),
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                               ),
//                                               Text(
//                                                 Tran.of(context)
//                                                     .text("noti_winner_number"),
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                               ),
//                                               Text(
//                                                 Tran.of(context)
//                                                     .text("bet_amount"),
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                               ),
//                                               Text(
//                                                 Tran.of(context).text("odds"),
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: Colors.black,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                               )
//                                             ],
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child: Text(
//                                                   ":  " +
//                                                       (widget.items.requestDate !=
//                                                               null
//                                                           ? getDate(widget.items
//                                                                   .requestDate)
//                                                               .toString()
//                                                           : widget.items
//                                                                       .currentdate !=
//                                                                   null
//                                                               ? getDate(widget
//                                                                       .items
//                                                                       .currentdate)
//                                                                   .toString()
//                                                               : "") +
//                                                       " " +
//                                                       (widget.items
//                                                                   .requestDate !=
//                                                               null
//                                                           ? getTime(widget.items
//                                                                   .requestDate)
//                                                               .toString()
//                                                           : widget.items
//                                                                       .currentdate !=
//                                                                   null
//                                                               ? getTime(widget
//                                                                       .items
//                                                                       .currentdate)
//                                                                   .toString()
//                                                               : ""),
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 child: Text(
//                                                   ":  " +
//                                                       (widget.items.number !=
//                                                               null
//                                                           ? widget.items.number
//                                                               .toString()
//                                                           : ""),
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 child: Text(
//                                                   ":  " +
//                                                       (widget.items.amount !=
//                                                               null
//                                                           ? NumberFormat(
//                                                                       '###,###,###')
//                                                                   .format(widget
//                                                                       .items
//                                                                       .amount)
//                                                                   .toString() +
//                                                               Tran.of(context)
//                                                                   .text("ks")
//                                                           : ""),
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 child: Text(
//                                                   ":  " +
//                                                       (widget.items.odd != null
//                                                           ? widget.items.odd
//                                                               .toString()
//                                                           : ""),
//                                                   style: TextStyle(
//                                                       fontSize: 13,
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         top: 65,
//                         left: MediaQuery.of(context).size.width * 0.42,
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10.0),
//                             child: Image.asset(
//                               'assets/winnoti1.jpg',
//                               width: 60.0,
//                               height: 60.0,
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//                     Stack(fit: StackFit.loose, children: <Widget>[
//                       new Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           new Container(
//                             padding: EdgeInsets.only(left: 10, right: 10),
//                             width: MediaQuery.of(context).size.width,
//                             height: 200,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15)),
//                               color: Colors.white,
//                               elevation: 2,
//                               margin: EdgeInsets.only(
//                                   left: 7,
//                                   right: 7,
//                                   bottom: 5,
//                                   top: MediaQuery.of(context).size.height *
//                                       0.07),
//                               child: Container(
//                                 margin: EdgeInsets.only(
//                                   left: 20,
//                                   right: 20,
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       sysData.name != null ? sysData.name : "",
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.only(top: 5, bottom: 5),
//                                       child: Text(
//                                         Tran.of(context)
//                                             .text("noti_winner_desc1"),
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                     Text(
//                                       Tran.of(context)
//                                           .text("noti_winner_desc2"),
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         child: Container(
//                           alignment: Alignment.center,
//                           padding: EdgeInsets.only(
//                               top: MediaQuery.of(context).size.height * 0.04),
//                           child:
//                               new Stack(fit: StackFit.loose, children: <Widget>[
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10.0),
//                               child: Image.asset(
//                                 'assets/prize.png',
//                                 width: 50.0,
//                                 height: 50.0,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ),
//                     ]),
//                   ],
//                 ),
//               ),
//               //widget.notification.image==null?Container(child: Text(""),):
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   getTime(date) {
//     DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss").parse(date);
//     var dateFormat = DateFormat("h:mm a");
//     var result = dateFormat.format(tempDate);
//     return result;
//   }

//   getDate(date) {
//     DateTime tempDate1 = DateFormat("yyyy-MM-ddThh:mm:ss").parse(date);
//     var dateFormat1 =
//         DateFormat("dd/MM/yyyy"); // you can change the format here
//     var result = dateFormat1.format(tempDate1);
//     return result;
//   }

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
