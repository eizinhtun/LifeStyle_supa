// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'wallet/wallet_detail_success_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'my_meterBill_detail.dart';
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
  int notiCount;

  List<NotiModel> totalList = [];
  List<NotiModel> notiList = [];
  List<String> docList = [];
  final db = FirebaseFirestore.instance;
  int i = 1;
  int showlist = 10;
  int start;
  int end;

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

  getData() async {
    totalList = await context.read<NotiProvider>().getNotiList(context);

    notiCount = context
        .read<NotiProvider>()
        .updateNotiCount(context, SystemData.notiCount);
    setState(() {});
    _onRefresh();
  }

  void _onRefresh() async {
    notiList.clear();
    await Future.delayed(Duration(milliseconds: 100));
    showlist = 10;
    if (totalList.length < showlist) showlist = totalList.length;
    notiList = totalList.sublist(0, showlist);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    start = showlist;
    showlist = showlist + 10; //start +showlist;
    end = totalList.length;
    if (notiList.length < end) {
      if (showlist > end) {
        notiList..addAll(totalList.sublist(start, end));
      } else {
        notiList..addAll(totalList.sublist(start, showlist));
      }
    }

    _refreshController.loadComplete();

    if (mounted) setState(() {});
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
            height: 10,
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
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  if (notiList.length == end) {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: notiList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        if (!notiList[index].status) {
                          notiList[index].status = true;
                          --SystemData.notiCount;
                        }
                      });
                      await context
                          .read<NotiProvider>()
                          .changeNotiStatus(context, notiList[index].messageId)
                          .then((value) {
                        switch (notiList[index].type) {
                          case NotiType.topup:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WalletDetailSuccessPage(
                                  docId: notiList[index].id,
                                ),
                              ),
                            );
                            break;
                          case NotiType.withdraw:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WalletDetailSuccessPage(
                                  docId: notiList[index].id,
                                ),
                              ),
                            );
                            break;
                          case NotiType.meterbill:
                            // String tempId = "7324392739";

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MeterBillDetailPage(
                                  docId: notiList[index].id,
                                ),
                              ),
                            );
                            break;

                          default:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NotificationDetailPage(
                                        noti: notiList[index], status: "true"),
                              ),
                            );
                            break;
                        }
                      });
                    },
                    child: Card(
                      color: !notiList[index].status
                          ? Color(0xFFafe3f0)
                          : Color(0xFFffffff),
                      margin: EdgeInsets.only(top: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      elevation: 0.3,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: notiList[index].imageUrl != null &&
                                      notiList[index].imageUrl != ""
                                  ? CachedNetworkImage(
                                      imageUrl: notiList[index].imageUrl,
                                      width: 60.0,
                                      height: 60.0,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Image.asset(
                                      'assets/icon/icon.png',
                                      width: 60.0,
                                      height: 60.0,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        notiList[index].title,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 8.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          notiList[index].body,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: notiList[index].currentdate != null
                                          ? Text(
                                              timeago.format(
                                                  notiList[index]
                                                      .currentdate
                                                      .toDate(),
                                                  // DateTime.parse(

                                                  //     notiList[index]
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
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        // child: ListTile(
                        //   onTap: () {
                        //     setState(() {
                        //       if (!notiList[index].status) {
                        //         notiList[index].status = true;
                        //         SystemData.notiCount--;
                        //         context.read<NotiProvider>().updateNotiCount(
                        //             context, SystemData.notiCount);
                        //       }
                        //     });
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             NotificationDetailPage(
                        //                 noti: notiList[index],
                        //                 status: "true"),
                        //       ),
                        //     );
                        //   },
                        //   leading: ClipRRect(
                        //     borderRadius: BorderRadius.circular(8.0),
                        //     child: notiList[index].imageUrl != null &&
                        //             notiList[index].imageUrl != ""
                        //         ? Image.network(
                        //             notiList[index].imageUrl,
                        //             width: 60.0,
                        //             height: 60.0,
                        //             fit: BoxFit.fill,
                        //           )
                        //         : Image.asset(
                        //             'assets/icon/icon.png',
                        //             width: 60.0,
                        //             height: 60.0,
                        //             fit: BoxFit.fill,
                        //           ),
                        //   ),
                        //   title: Container(
                        //     // height: double.infinity,
                        //     padding: EdgeInsets.only(
                        //       left: 8.0,
                        //     ),
                        //     child: Center(
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Container(
                        //             alignment: Alignment.centerLeft,
                        //             child: Text(
                        //               notiList[index].title,
                        //               textAlign: TextAlign.start,
                        //               overflow: TextOverflow.ellipsis,
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //           Container(
                        //               padding: EdgeInsets.only(top: 8.0),
                        //               alignment: Alignment.centerLeft,
                        //               child: Text(
                        //                 notiList[index].body,
                        //                 textAlign: TextAlign.start,
                        //                 overflow: TextOverflow.ellipsis,
                        //               )),
                        //           Container(
                        //             alignment: Alignment.centerLeft,
                        //             padding: EdgeInsets.only(top: 8.0),
                        //             child: notiList[index].currentdate != null
                        //                 ? Text(
                        //                     timeago.format(
                        //                         DateTime
                        //                             .fromMicrosecondsSinceEpoch(
                        //                                 int.parse(notiList[
                        //                                         index]
                        //                                     .currentdate)),
                        //                         // DateTime.parse(

                        //                         //     notiList[index]
                        //                         //         .currentdate),
                        //                         locale: "en",
                        //                         // SystemData.language,
                        //                         allowFromNow: true),
                        //                     style: TextStyle(
                        //                         color: Colors.grey,
                        //                         fontSize: 13),
                        //                   )
                        //                 : Text(""),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        //   trailing: Icon(
                        //     Icons.arrow_forward_ios,
                        //     color: Colors.brown[900],
                        //   ),
                        // ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
