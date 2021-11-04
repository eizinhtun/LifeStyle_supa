// @dart=2.9
import 'package:barcode_scan_fix/barcode_scan.dart' as bar;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/Ads.dart';
import 'package:left_style/pages/my_meterBill_list.dart';
import 'package:left_style/pages/upload_my_read.dart';
import 'package:left_style/widgets/home_item.dart';
import 'package:left_style/widgets/show_balance.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ads_detail.dart';
import 'meter_city.dart';
import 'meter_list.dart';
import 'meter_search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // List<Ads> adsItems = [
  //   Ads(
  //     id: 1,
  //     type: "linkurl",
  //     linkUrl: "https://wallpapercave.com/wuba-monster-hunt-wallpapers",
  //     imageUrl:
  //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROj6_j9-LkJKMmgmLD2HPu9xzJ6T3vl3ep2g&usqp=CAU",
  //   ),
  //   Ads(
  //     id: 2,
  //     type: "linkurl",
  //     linkUrl: "https://wallpapercave.com/wuba-monster-hunt-wallpapers",
  //     imageUrl:
  //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT594hEdQIZpnbf6fAesGSi7E2FPP2oK-Gf2yEU_1zYOkMtRYSpnqAgqjqNXKitM7qOMNA&usqp=CAU",
  //   ),
  //   Ads(
  //     id: 3,
  //     type: "linkurl",
  //     linkUrl: "https://wallpapercave.com/wuba-monster-hunt-wallpapers",
  //     imageUrl:
  //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT594hEdQIZpnbf6fAesGSi7E2FPP2oK-Gf2yEU_1zYOkMtRYSpnqAgqjqNXKitM7qOMNA&usqp=CAU",
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
  }

  Future<String> _showAlertDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            actionsPadding: EdgeInsets.fromLTRB(4, 4, 4, 4),
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
                new IconButton(
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
                new IconButton(
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

  bool show = false;
  Color iconColor = Colors.black87;

  List<HomeItem> datalist = [
    HomeItem(
      title: "Add Meter",
      iconData: Icons.qr_code,
      action: ActionButton.AddMeter,
    ),
    HomeItem(
      title: "Meter List",
      action: ActionButton.MeterList,
      iconData: Icons.list,
    ),
    HomeItem(
      action: ActionButton.ReadUnit,
      title: "Read Meter",
      iconData: Icons.file_upload,
    ),
    HomeItem(
        title: "Meter Bills",
        iconData: Icons.history,
        action: ActionButton.MeterBill),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Color(0xfffa2e73),
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 0.0,
                stretchTriggerOffset: 70.0,
                shape: ContinuousRectangleBorder(
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(80),
                    //   bottomRight: Radius.circular(80),
                    // ),
                    ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Container(),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(adsCollection)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else
                              return Column(
                                children: [
                                  CarouselSlider(
                                    items: snapshot.data.docs.map((doc) {
                                      Ads item = Ads.fromJson(doc.data());
                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (item.linkUrl != null &&
                                                item.linkUrl.length > 1 &&
                                                item.type
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "linkurl") {
                                              _launchURL(item.linkUrl);
                                            } else if (item.type
                                                    .toString()
                                                    .toLowerCase() ==
                                                "content") {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        AdsDetailPage(
                                                            id: item.id
                                                                .toString()),
                                                  ));
                                            }
                                            setState(() {});
                                          },
                                          child: Center(
                                            child: Card(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              elevation: 1,
                                              child: OptimizedCacheImage(
                                                fit: BoxFit.fitWidth,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                imageUrl: item.imageUrl,
                                                placeholder: (context, url) =>
                                                    SpinKitChasingDots(
                                                  color: Colors.blue,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        aspectRatio: 1.0,
                                        viewportFraction: 1,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: snapshot.data.docs
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return GestureDetector(
                                        onTap: () => _controller
                                            .animateToPage(entry.key),
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black)
                                                  .withOpacity(
                                                      _current == entry.key
                                                          ? 0.9
                                                          : 0.4)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: getWidgets(context),
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
            top: 60,
            left: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width - 30,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ShowBalance(
                              color: Colors.white,
                              showIconColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(
                  //   height: 20,
                  // ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection(adsCollection).snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) {
                  //       return Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     } else
                  //       return Column(
                  //         children: [
                  //           CarouselSlider(
                  //             items: snapshot.data.docs.map((doc) {
                  //               Ads item =Ads.fromJson(doc.data());
                  //              return Padding(
                  //                 padding: EdgeInsets.all(8.0),
                  //                  child: InkWell(
                  //                    onTap: () {
                  //                      if (item.linkUrl != null &&
                  //                          item.linkUrl.length > 1 &&
                  //                          item.type.toString().toLowerCase() == "linkurl") {
                  //                        _launchURL(item.linkUrl);
                  //                      }
                  //                      else if (item.type.toString().toLowerCase() == "content") {
                  //                        Navigator.push(
                  //                            context,
                  //                            new MaterialPageRoute(
                  //                              builder: (BuildContext context) =>
                  //                                  AdsDetailPage(
                  //                                      id: item.id.toString()),
                  //                            ));
                  //                      }
                  //                      setState(() {});
                  //                    },
                  //                    child: Center(
                  //                      child: Card(
                  //                        margin: EdgeInsets.symmetric(
                  //                            horizontal: 5, vertical: 5),
                  //                        shape: RoundedRectangleBorder(
                  //                          borderRadius:
                  //                          BorderRadius.circular(5.0),
                  //                        ),
                  //                        elevation: 1,
                  //                        child: OptimizedCacheImage(
                  //                          fit: BoxFit.fitWidth,
                  //                          width: MediaQuery.of(context).size.width,
                  //                          height: MediaQuery.of(context).size.height,
                  //                          imageUrl: item.imageUrl,
                  //                          placeholder: (context, url) =>
                  //                              SpinKitChasingDots(
                  //                                color: Colors.blue,
                  //                              ),
                  //                          errorWidget: (context, url, error) =>
                  //                              Icon(Icons.error),
                  //                        ),
                  //                      ),
                  //                    ),
                  //                  ),
                  //              );
                  //             }).toList(),
                  //             carouselController: _controller,
                  //             options: CarouselOptions(
                  //                 autoPlay: true,
                  //                 enlargeCenterPage: true,
                  //                 aspectRatio: 1.0,
                  //                 viewportFraction: 1,
                  //                 onPageChanged: (index, reason) {
                  //                   setState(() {
                  //                     _current = index;
                  //                   });
                  //                 }),
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: snapshot.data.docs.asMap().entries.map((entry) {
                  //               return GestureDetector(
                  //                 onTap: () => _controller.animateToPage(entry.key),
                  //                 child: Container(
                  //                   width: 12.0,
                  //                   height: 12.0,
                  //                   margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  //                   decoration: BoxDecoration(
                  //                       shape: BoxShape.circle,
                  //                       color: (Theme.of(context).brightness == Brightness.dark
                  //                           ? Colors.white
                  //                           : Colors.black)
                  //                           .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ],
                  //       );
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // // Container(
                  // //     margin: EdgeInsets.only(top: 10),
                  // //     color: Colors.black.withOpacity(0.05),
                  // //     child: Column(
                  // //       children: [
                  // //         CarouselSlider.builder(
                  // //           itemCount: adsItems.length,
                  // //           options: CarouselOptions(
                  // //             autoPlay: true,
                  // //             autoPlayInterval: const Duration(seconds: 8),
                  // //             viewportFraction: 1,
                  // //             aspectRatio: 2.0,
                  // //             enlargeCenterPage: true,
                  // //           ),
                  // //           itemBuilder: (context, index, realIdx) {
                  // //             return Container(
                  // //               height: 800,
                  // //               child: InkWell(
                  // //                 onTap: () {
                  // //                   if (adsItems[index].linkUrl != null &&
                  // //                       adsItems[index].linkUrl.length > 1 &&
                  // //                       adsItems[index]
                  // //                               .type
                  // //                               .toString()
                  // //                               .toLowerCase() ==
                  // //                           "linkurl") {
                  // //                     _launchURL(adsItems[index].linkUrl);
                  // //                   } else if (adsItems[index]
                  // //                           .type
                  // //                           .toString()
                  // //                           .toLowerCase() ==
                  // //                       "content") {
                  // //                     Navigator.push(
                  // //                         context,
                  // //                         new MaterialPageRoute(
                  // //                           builder: (BuildContext context) =>
                  // //                               AdsDetailPage(
                  // //                                   id: adsItems[index]
                  // //                                       .id
                  // //                                       .toString()),
                  // //                         ));
                  // //                   }
                  // //                   setState(() {});
                  // //                 },
                  // //                 child: Center(
                  // //                   child: Card(
                  // //                     margin: EdgeInsets.symmetric(
                  // //                         horizontal: 5, vertical: 5),
                  // //                     shape: RoundedRectangleBorder(
                  // //                       borderRadius:
                  // //                           BorderRadius.circular(5.0),
                  // //                     ),
                  // //                     elevation: 3,
                  // //                     child: OptimizedCacheImage(
                  // //                       fit: BoxFit.fill,
                  // //                       width: 1000,
                  // //                       height: 700,
                  // //                       imageUrl: adsItems[index].imageUrl,
                  // //                       placeholder: (context, url) =>
                  // //                           SpinKitChasingDots(
                  // //                         color: Colors.blue,
                  // //                       ),
                  // //                       errorWidget: (context, url, error) =>
                  // //                           Icon(Icons.error),
                  // //                     ),
                  // //                   ),
                  // //                   //   Image.network( adsItems[index].imageUrl,
                  // //                   //   fit: BoxFit.fill,
                  // //                   //     width: 1000,
                  // //                   //
                  // //                   // ),
                  // //
                  // //                   /*Image.network(imgList[index],
                  // //                     fit: BoxFit.cover, width: 1000)*/
                  // //                 ),
                  // //               ),
                  // //             );
                  // //           },
                  // //         ),
                  // //       ],
                  // //     )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // // ElevatedButton(
                  // //   onPressed: () async {
                  // //     print("Pressed");
                  // //     var meterRef = FirebaseFirestore.instance
                  // //         .collection(meterCollection);
                  //
                  // //     if (FirebaseAuth.instance.currentUser?.uid != null) {
                  // //       String uid =
                  // //           FirebaseAuth.instance.currentUser.uid.toString();
                  //
                  // //       await meterRef
                  // //           .doc(uid)
                  // //           .collection(userMeterCollection)
                  // //           .doc("7324392739")
                  // //           .set(jsonString);
                  // //     }
                  // //   },
                  // //   child: Text(
                  // //     "Add",
                  // //     style: TextStyle(
                  // //         color: Colors.white, fontWeight: FontWeight.bold),
                  // //   ),
                  // // ),
                  // Container(
                  //   padding: EdgeInsets.all(8),
                  //   child: Column(
                  //     children: getWidgets(context),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  List<Widget> getWidgets(BuildContext context) {
    List<Widget> list = [];

    for (var i = 0; i < datalist.length - 1; i += 2) {
      list.add(
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeItemWidget(
                  context: context,
                  title: datalist.elementAt(i).title,
                  iconData: datalist.elementAt(i).iconData,
                  onPress: (context) {
                    switch (datalist.elementAt(i).action) {
                      case ActionButton.AddMeter:
                        addNewMeter(context);
                        break;
                      case ActionButton.MeterList:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MeterListPage(),
                            ));
                        break;
                      case ActionButton.ReadUnit:
                        uploadUnit(context);
                        break;
                      case ActionButton.MeterBill:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyMeterBillListPage(),
                            ));
                        break;
                    }
                  }
                  // =>
                  //     pressAction(datalist.elementAt(i).title, context),
                  ),
              (i + 1) < datalist.length
                  ? HomeItemWidget(
                      context: context,
                      title: datalist.elementAt(i + 1).title,
                      iconData: datalist.elementAt(i + 1).iconData,
                      onPress: (context) {
                        switch (datalist.elementAt(i + 1).action) {
                          case ActionButton.AddMeter:
                            addNewMeter(context);
                            break;
                          case ActionButton.MeterList:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MeterListPage(),
                                ));
                            break;
                          case ActionButton.ReadUnit:
                            uploadUnit(context);
                            break;
                          case ActionButton.MeterBill:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MyMeterBillListPage(),
                                ));
                            break;
                        }
                      }
                      // =>
                      //     pressAction(datalist.elementAt(i + 1).title, context),
                      )
                  : Container(
                      color: Colors.red,
                    ),
            ],
          ),
        ),
      );
    }
    return list;
  }

  /*void pressAction(String action, BuildContext context) {
    switch (action) {
      case ActionButton.AddMeter:
        addNewMeter(context);
        break;
      case ActionButton.MeterList:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MeterListPage(),
            ));
        break;
      case ActionButton.ReadUnit:
        uploadUnit(context);
        break;
      case ActionButton.MeterBill:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MeterListPage(),
            ));
        break;
    }
  }*/

  String barcode = "";
  String meterBarcode = "";
  Future<void> uploadUnit(BuildContext context) async {
    String s = await _showAlertDialog(context);
    if (s != null) {
      try {
        String barcode = await bar.BarcodeScanner.scan();
        setState(() => this.barcode = barcode);

        if (barcode != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UploadMyReadScreen(customerId: barcode)));
        }
      } on PlatformException catch (e) {
        if (e.code == bar.BarcodeScanner.CameraAccessDenied) {
          setState(() {
            this.barcode = 'The user did not grant the camera permission!';
          });
        } else {
          setState(() => this.barcode = 'Unknown error: $e');
        }
      } on FormatException {
        setState(() => this.barcode =
            'null (User returned using the "back"-button before scanning anything. Result)');
      } catch (e) {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
    // String codeSanner = await BarcodeScanner.scan().then((value) {
    //   if (value != null) {
    //     Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => UploadMyReadScreen(customerId: value)));
    //   }
    // }).catchError((error) {});
  }

  Future<void> addNewMeter(BuildContext context) async {
    var apiUrl = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MeterCityPage()));

    if (apiUrl != null) {
      var typeResult = await _showAlertDialog(context);
      if (typeResult != null && typeResult == "QR") {
        try {
          String meterBarcode = await bar.BarcodeScanner.scan();
          print(meterBarcode);
          setState(() => this.meterBarcode = meterBarcode);

          if (meterBarcode != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UploadMyReadScreen(customerId: meterBarcode)));
          }
          if (meterBarcode != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MeterSearchResultPage(
                      searchKey: meterBarcode,
                      apiUrl: apiUrl,
                    )));
          }
        } on PlatformException catch (e) {
          if (e.code == bar.BarcodeScanner.CameraAccessDenied) {
            setState(() {
              this.meterBarcode =
                  'The user did not grant the camera permission!';
            });
          } else {
            setState(() => this.meterBarcode = 'Unknown error: $e');
          }
        } on FormatException {
          setState(() => this.meterBarcode =
              'null (User returned using the "back"-button before scanning anything. Result)');
        } catch (e) {
          setState(() => this.meterBarcode = 'Unknown error: $e');
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
        //   print("cancel scan");
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
}

class HomeItem {
  final String title;
  final IconData iconData;
  final String action;

  final Function(BuildContext context) onPressed;

  HomeItem({this.title, this.iconData, this.onPressed, this.action});
}
