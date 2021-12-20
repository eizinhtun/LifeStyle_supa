// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/hotline_model.dart';
import 'package:left_style/providers/hotline_provider.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<HotlineModel> items = [];

  refresh() {
    context.read<HotlineProvider>().getHotlineServices(context);

    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _launchURL(String _url, BuildContext context) async =>
      await canLaunch(_url)
          ? await launch(_url)
          : throw ShowMessageHandler.showError(
              context, "Tip", "Could not launch " + _url);

  @override
  Widget build(BuildContext context) {
    items = context.watch<HotlineProvider>().items;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Tran.of(context).text("help").toString()),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Tran.of(context).text("serviceTime1"),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Text(
                //     Tran.of(context).text("serviceTime2"),
                //     style: TextStyle(color: Theme.of(context).primaryColor),
                //   ),
                // ),
              ],
            ),
          ),
          Flexible(
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  waterDropColor: Colors.blue,
                ),
                controller: _refreshController,
                onRefresh: refresh,
                child: context.watch<HotlineProvider>().isloading
                    ? Center(
                        child: SpinKitChasingDots(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Container(
                        color: Color(0xFFe1dfe2),
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: (items != null && items.length > 0)
                            ? GroupedListView<HotlineModel, String>(
                                elements: items,
                                groupBy: (element) => element.title,
                                groupComparator: (value1, value2) =>
                                    value2.compareTo(value1),
                                itemComparator: (item1, item2) =>
                                    item1.title.compareTo(item2.title),
                                order: GroupedListOrder.ASC,
                                // useStickyGroupSeparators: true,
                                groupSeparatorBuilder: (String value) => Card(
                                  margin: EdgeInsets.only(
                                      bottom: 0, right: 10, left: 10, top: 15),
                                  elevation: 0,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.only(topLeft: Radius.circular(3.0),topRight: Radius.circular(3.0),),
                                  // ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        //print(value);
                                      },
                                      child: Text(
                                        Tran.of(context).text(value),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                itemBuilder: (c, element) {
                                  return Card(
                                    margin: EdgeInsets.only(
                                        top: 0, bottom: 0, right: 10, left: 10),
                                    //elevation: 0,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onLongPress: () {
                                                ShowMessageHandler.copy(
                                                    context, element.phoneNo);
                                              },
                                              child: Text(element.phoneNo)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      "tel:" + element.phoneNo,
                                                      context);
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10, left: 10),
                                                    height: 35,
                                                    //width: 60,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                          "assets/phonebutton.png"),
                                                    )),
                                              ),
                                              Visibility(
                                                visible: element.messangerId !=
                                                        null &&
                                                    element.messangerId != "",
                                                child: IconButton(
                                                    onPressed: () {
                                                      _launchURL(
                                                          element.messangerId,
                                                          context); //"https://m.me/103914151886669/");
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .facebookMessenger,
                                                      color: Colors.blue,
                                                    )),
                                              ),
                                              Visibility(
                                                visible:
                                                    element.viber != null &&
                                                        element.viber != "",
                                                child: InkWell(
                                                  onTap: () {
                                                    // if(!kIsWeb){
                                                    //   _launchURL( 'viber://chat?number=' +element.viber);
                                                    // }else{
                                                    //   //html.window.open('viber://chat?number=' +element.viber,'');
                                                    //   ShowMessageHandler.ShowError(context, "Tip","Could not launch Viber");
                                                    // }
                                                    _launchURL(
                                                        'viber://chat?number=' +
                                                            element.viber,
                                                        context);

                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 10),
                                                      height: 35,
                                                      //width: 60,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                            "assets/viberbutton.png"),
                                                      )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Column(
                                children: [
                                  Card(
                                    margin: EdgeInsets.only(
                                        bottom: 0,
                                        right: 10,
                                        left: 10,
                                        top: 15),
                                    elevation: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Text(
                                        Tran.of(context)
                                            .text("service_transaction"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    margin: EdgeInsets.only(
                                        bottom: 0,
                                        right: 10,
                                        left: 10,
                                        top: 15),
                                    elevation: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Text(
                                        Tran.of(context).text("service_agent"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    margin: EdgeInsets.only(
                                        bottom: 0,
                                        right: 10,
                                        left: 10,
                                        top: 15),
                                    elevation: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Text(
                                        Tran.of(context).text("service_error"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      )),
          ),
        ],
      ),
    );
  }
}
