// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'notification_detail.dart';

class NotificationListPage extends StatefulWidget {
  NotificationListPage({
    Key key,
  }) : super(key: key);

  @override
  _NotificationListPage createState() => _NotificationListPage();
}

class _NotificationListPage extends State<NotificationListPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<NotiModel> items;
  int notiCount;

  @override
  void initState() {
    super.initState();
    //SystemData.notiCount = 0;
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pullRefresh() async {
    getData();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  getData() async {
    await Future.delayed(Duration(milliseconds: 100));
    items = await context.read<NotiProvider>().getNotiList(context);
    // if (items != null && items.length > 0) {
    //   SystemData.notiCount = items.where((e) => e.status == "0").length;
    // } else {
    //   SystemData.notiCount = 0;
    // }
    // notiCount = await context
    //     .read<NotiProvider>()
    //     .notiCount(context, SystemData.notiCount);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   child: Text(
          //     "Notifications",
          //     style: TextStyle(
          //         color: Colors.grey[400],
          //         fontSize: 15,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          // Divider(
          //   height: 1.0,
          //   color: Colors.grey.withOpacity(0.3),
          // ),
          Expanded(
            //padding: const EdgeInsets.all(8.0),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              controller: _refreshController,
              header: WaterDropHeader(
                waterDropColor: Colors.grey[300],
              ),
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => Card(
                    color: items[index].status == "0"
                        ? Color(0xFFafe3f0)
                        : Color(0xFFffffff),
                    margin: EdgeInsets.only(top: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 0.3,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                if (items[index].status == "0") {
                                  items[index].status = '1';
                                  SystemData.notiCount--;
                                  context
                                      .read<NotiProvider>()
                                      .notiCount(context, SystemData.notiCount);
                                }
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotificationDetailPage(
                                          noti: items[index], status: "true"),
                                ),
                              );
                            },
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Container(
                                //     alignment: Alignment.topLeft,
                                //     padding: EdgeInsets.only(right: 10),
                                //     child: Icon(Icons.remove_circle_outline,color: Colors.red,)
                                // ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child:
                                      // items[index].imageUrl != null ||
                                      //         items[index].imageUrl != ""
                                      //     ? Image.network(
                                      //         items[index].imageUrl,
                                      //         width: 60.0,
                                      //         height: 60.0,
                                      //         fit: BoxFit.fill,
                                      //       )
                                      //     :
                                      Image.asset(
                                    'assets/icon/icon.png',
                                    width: 60.0,
                                    height: 60.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: items[index].title != null &&
                                              items[index].title.length > 20
                                          ? Text(
                                              items[index]
                                                  .title
                                                  .substring(0, 20),
                                              textAlign: TextAlign.start,
                                            )
                                          : Text(
                                              items[index].title,
                                              textAlign: TextAlign.start,
                                            )),
                                  Container(
                                      padding: EdgeInsets.only(top: 8.0),
                                      alignment: Alignment.centerLeft,
                                      child: items[index].body != null &&
                                              items[index].body.length > 20
                                          ? Text(
                                              items[index]
                                                  .body
                                                  .substring(0, 20),
                                              textAlign: TextAlign.start,
                                            )
                                          : Text(
                                              items[index].body,
                                              textAlign: TextAlign.start,
                                            )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: items[index].currentdate != null
                                        ? Text(
                                            timeago.format(
                                                DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        int.parse(items[index]
                                                            .currentdate)),
                                                // DateTime.parse(

                                                //     items[index]
                                                //         .currentdate),
                                                locale: "en",
                                                // SystemData.language,
                                                allowFromNow: true),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          )
                                        : Text(""),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.brown[900],
                            ),
                          ),
                        ),
                      ],
                    )),
                // itemExtent: 100.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
