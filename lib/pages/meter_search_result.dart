// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_model.dart';
import 'package:left_style/models/meter_page_obj.dart';
import 'package:left_style/pages/meter_search_detail.dart';
import 'package:left_style/providers/meter_presenter.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_dash/flutter_dash.dart';

class MeterSearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MeterSearchResultPage(),
    );
  }
}

class MeterSearchResultPage extends StatefulWidget {
  final String searchKey;
  final String apiUrl;
  const MeterSearchResultPage({Key key, this.apiUrl, this.searchKey})
      : super(key: key);

  @override
  MeterSearchResultPageState createState() => MeterSearchResultPageState();
}

class MeterSearchResultPageState extends State<MeterSearchResultPage>
    with SingleTickerProviderStateMixin
    implements MeterContract {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // int _selectedIndex = 0;
  // bool _isSearch = false;
  bool _onFirstLoading = false;
  int pageIndex = 1;
  int pageSize = 20;
  MeterPageObj _page;
  TextEditingController _controllerSearch;
  List<Meter> items = [];
  MeterPresenter _presenter;

  String apiUrl = "";

  @override
  void initState() {
    super.initState();

    _presenter = MeterPresenter(this, context);
    _controllerSearch = TextEditingController();
    apiUrl = widget.apiUrl;
    if (widget.apiUrl != null && widget.searchKey != null) {
      _controllerSearch.text = widget.searchKey;

      _onFirstLoad();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    this.pageIndex = 1;
    _presenter.loadData(
        action: "onRefresh", apiUrl: apiUrl, searchKey: _controllerSearch.text);
  }

  void _onMoreLoading() async {
    if (items.length < _page.rowCount) {
      this.pageIndex++;
      _presenter.loadData(
        action: "onLoadMore",
        apiUrl: apiUrl,
        searchKey: _controllerSearch.text,
      );
    }
  }

  _onFirstLoad() async {
    _onFirstLoading = true;

    if (items != null) {
      items.clear();
    }

    this.pageIndex = 1;
    setState(() {});
    _presenter.loadData(
      action: "onFirstLoad",
      apiUrl: apiUrl,
      searchKey: _controllerSearch.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Tran.of(context).text("meter_rearch").toString()),
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
      body: _onFirstLoading
          ? Center(
              child: SpinKitChasingDots(
                color: Colors.pink,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      //  searchKey=value;
                      setState(() {
                        _onFirstLoad();
                      });
                    },
                    controller: _controllerSearch,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black12, width: 0.8),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),

                        //labelText: "Search",
                        hintText: Tran.of(context).text("search"),
                        prefixIcon: Icon(Icons.search),
                        contentPadding: const EdgeInsets.all(0.0),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 0.0),
                            gapPadding: 0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)))),
                  ),
                ),
                /* Divider(
                  height: 1.0,
                  color: Colors.grey.withOpacity(0.3),
                ),*/
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          //padding: const EdgeInsets.all(8.0),
                          child: _onFirstLoading
                              ? Center(
                                  child: SpinKitChasingDots(
                                    ////// color: sysData.mainColor,
                                    size: 50.0,
                                  ),
                                )
                              : SmartRefresher(
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  header: WaterDropHeader(
                                      /////// waterDropColor: sysData.mainColor,
                                      ),
                                  footer: CustomFooter(
                                    builder: (BuildContext context,
                                        LoadStatus mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = Text(
                                          Tran.of(context).text("loadMore"),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        );
                                      } else if (mode == LoadStatus.loading) {
                                        body = CupertinoActivityIndicator();
                                      } else if (mode == LoadStatus.failed) {
                                        body = Text(
                                            Tran.of(context).text("retryLoad"));
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
                                        body = Text(Tran.of(context)
                                            .text("relaseLoad"));
                                      } else {
                                        body = Text(Tran.of(context)
                                            .text("noMoreData"));
                                      }
                                      if (_page != null &&
                                          items.length >= _page.rowCount) {
                                        body = Text(
                                          Tran.of(context).text("noMoreData"),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        );
                                      }
                                      return Container(
                                        height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  onLoading: _onMoreLoading,
                                  child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) => Card(
                                      margin: const EdgeInsets.only(
                                          top: 7, left: 5, right: 5, bottom: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      elevation: 2,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () async {
                                              var result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MeterSearchDetailPage(
                                                              obj: items[
                                                                  index])));
                                              if (result != null && result) {
                                                Navigator.of(context).pop(true);
                                              }
                                            },
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 0.0,
                                                    left: 0.0,
                                                    right: 0.0,
                                                    bottom: 0.0),
                                            leading: Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              width: 60,
                                              height: 60,
                                              child: CircleAvatar(
                                                radius: 100.0,
                                                // backgroundColor:MyTheme.getPrimaryColor(),
                                                //backgroundImage: MeScreenState.fileAvatar!=null?
                                                // FileImage(fileAvatar):
                                                /*backgroundImage: NetworkImage(
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
                                                  items[index].meterNo,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Text(
                                                      items[index].insertDate

                                                      // Formatter.getDate(
                                                      //     items[index]
                                                      //         .insertDate
                                                      //         .toDate()
                                                      //         ),
                                                      ),
                                                ),
                                                Text(
                                                  items[index].customerId +
                                                      " : " +
                                                      items[index].categoryName,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Wrap(
                                                      children: [
                                                        Text(
                                                          NumberFormat(
                                                                      '#,###,000')
                                                                  .format(items[
                                                                          index]
                                                                      .lastReadUnit) +
                                                              " " +
                                                              Tran.of(context)
                                                                  .text("unit"),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
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
                                            length: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            dashLength: 2,
                                            /////// dashColor: sysData.mainColor
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  top: 5,
                                                  bottom: 10,
                                                  right: 20),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5, bottom: 5),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      items[index]
                                                              .consumerName +
                                                          " - " +
                                                          items[index].houseNo,
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    // itemExtent: 100.0,
                                  ),
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

  @override
  void onDeleteSuccess(bool result) {
    if (result) {
      _onFirstLoad();
    }
  }

  @override
  void onFirstLoadSuccess(MeterPageObj page) {
    _page = page;
    items = items == null ? [] : items;
    items.clear();
    items.addAll(page.results);
    setState(() {
      _onFirstLoading = false;
    });
  }

  @override
  void onLoadMoreSuccess(MeterPageObj page) {
    if (mounted)
      setState(() {
        _page = page;
        items.addAll(page.results);
      });
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess(MeterPageObj page) {
    if (mounted) {
      items.clear();
      _page = page;
      items.addAll(page.results);
      setState(() {});
      _refreshController.refreshCompleted();
    }
  }

  @override
  void showError(String text) {
    if (mounted) {
      setState(() {
        _onFirstLoading = false;
      });

      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //     backgroundColor: Colors.red,
      //     content: Text(Tran.of(context).text(text))));

      ScaffoldMessenger.maybeOf(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(Tran.of(context).text(text))));
    }
  }

  @override
  void showMessage(String text) {
    ShowMessageHandler.showSnackbar(text, context, 3);
  }
}
