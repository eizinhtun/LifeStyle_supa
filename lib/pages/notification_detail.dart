// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:provider/provider.dart';

class NotificationDetailPage extends StatefulWidget {
  NotificationDetailPage({Key key, @required this.noti, @required this.status})
      : super(key: key);
  final NotiModel noti;
  final String status;

  @override
  _NotificationDetailPage createState() => _NotificationDetailPage();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class _NotificationDetailPage extends State<NotificationDetailPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    //sysData.notiCount = 0;
    widget.status == "false"
        ? ""
        : context
            .read<NotiProvider>()
            .getNotiById(context, widget.noti.messageId.toString());
    //context.read<BetProvider>().notiCount(context,sysData.notiCount);
    if (!kIsWeb) {
      markAsRead();
    }
  }

  markAsRead() async {
    if (widget.noti != null && widget.noti.messageId != null) {
      await flutterLocalNotificationsPlugin
          .cancelAll(); //cancel(0,tag:widget.noti.guid);
    }
  }

  String notiStr(String str, String bill, String transactionNo) {
    str = str.replaceAll('@kyat', bill);
    str = str.replaceAll('@tracNo', transactionNo);
    print("NOTI:$str");
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Notification Detail"),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: mainColor
              //     gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color(0xFF001950),
              //     Color(0xFF04205a),
              //     Color(0xFF0b2b6a),
              //     Color(0xFF0b2b6a),
              //     Color(0xFF2253a2),
              //     Color(0xFF2253a2)
              //   ],
              // ),
              ),
        ),
      ),
      body: //widget.notification==null?Center(child: SpinKitChasingDots(color: sysData.mainColor,),):
          SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              Visibility(
                visible: true,
                // visible:
                //     widget.noti.type != null && widget.noti.type == "welcome",
                child: Stack(fit: StackFit.loose, children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: MediaQuery.of(context).size.width,
                        //height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.white,
                          elevation: 2,
                          margin: EdgeInsets.only(
                              left: 7, right: 7, bottom: 5, top: 100),
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 40, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    child: RichText(
                                      text: TextSpan(
                                        text: widget.noti.body,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  height: 1.0,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
                                  color: Colors.black,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Created Date : ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: (widget.noti.currentdate != null
                                              ? getTime(widget.noti.currentdate
                                                      .toDate())
                                                  .toString()
                                              : ""),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: mainColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 65,
                    left: MediaQuery.of(context).size.width * 0.42,
                    child: Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          "assets/icon/icon.png",
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTime(DateTime date) {
    var dateFormat = DateFormat("h:mm a");
    var result = dateFormat.format(date);
    return result;
  }
}
