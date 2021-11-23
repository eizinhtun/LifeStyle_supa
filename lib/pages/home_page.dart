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
import 'package:left_style/widgets/topup_widget.dart';
import 'package:left_style/widgets/withdrawal_widget.dart';
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
    // HomeItem(
    //   title: "Add Meter",
    //   iconData: Icons.qr_code,
    //   action: ActionButton.AddMeter,
    // ),
    HomeItem(
      title: "Top up",
      action: ActionButton.Topup,
      img: "assets/icon/cash_in.png",
      iconData:
          // FontAwesomeIcons.cash
          Icons.list,
    ),
    HomeItem(
      title: "My Meters",
      action: ActionButton.MeterList,
      iconData: Icons.list,
    ),
    HomeItem(
      action: ActionButton.Withdraw,
      title: "Withdraw",
      iconData: Icons.ac_unit,
      img: "assets/icon/cash_out.png",
    ),
    // HomeItem(
    //   action: ActionButton.ReadUnit,
    //   title: "Read Meter",
    //   iconData: Icons.file_upload,
    // ),
    HomeItem(
        title: "Meter Bills",
        iconData: Icons.receipt_long,
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
                  preferredSize: Size.fromHeight(20),
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
                                        height: 200,
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
                                          width: 8.0,
                                          height: 8.0,
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
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     print("Pressed");
                        //     var meterBillRef = FirebaseFirestore.instance
                        //         .collection(meterBillsCollection);
                        //     await meterBillRef
                        //         .doc("7324392739_11_21")
                        //         .set(meterbilljson);
                        //   },
                        //   child: Text(
                        //     "Add Meter Bill",
                        //     style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     print("Pressed");
                        //     String uid = FirebaseAuth.instance.currentUser.uid
                        //         .toString();
                        //     var meterRef = FirebaseFirestore.instance
                        //         .collection(meterCollection);
                        //     await meterRef
                        //         .doc(uid)
                        //         .collection(userMeterCollection)
                        //         .add(meterjson);
                        //   },
                        //   child: Text(
                        //     "Add Meter",
                        //     style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ),

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
            top: 30,
            left: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width - 30,
              alignment: Alignment.center,
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
                  img: datalist.elementAt(i).img,
                  onPress: (context) {
                    switch (datalist.elementAt(i).action) {
                      // case ActionButton.AddMeter:
                      //   addNewMeter(context);
                      //   break;
                      case ActionButton.MeterList:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MeterListPage(),
                            ));
                        break;
                      // case ActionButton.ReadUnit:
                      //   uploadUnit(context);
                      //   break;
                      case ActionButton.MeterBill:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyMeterBillListPage(),
                            ));
                        break;
                      case ActionButton.Topup:
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TopUpPage()));
                        break;
                      case ActionButton.Withdraw:
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WithdrawalPage()));
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
                      img: datalist.elementAt(i + 1).img,
                      onPress: (context) {
                        switch (datalist.elementAt(i + 1).action) {
                          // case ActionButton.AddMeter:
                          //   addNewMeter(context);
                          //   break;
                          case ActionButton.MeterList:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MeterListPage(),
                                ));
                            break;
                          // case ActionButton.ReadUnit:
                          //   uploadUnit(context);
                          //   break;
                          case ActionButton.MeterBill:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MyMeterBillListPage(),
                                ));
                            break;
                          case ActionButton.Topup:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TopUpPage()));
                            break;
                          case ActionButton.Withdraw:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WithdrawalPage()));
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
    ///String s = await _showAlertDialog(context);
    //if (s != null) {
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
    //}
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
  final String img;

  final Function(BuildContext context) onPressed;

  HomeItem({this.title, this.iconData, this.img, this.onPressed, this.action});
}

var meterbilljson = {
  "allowedUnit": 0,
  "ampere": "10/30",
  "applyDate": null,
  "avageUseUnit": 99,
  "billNeedModity": false,
  "binderId": 5,
  "block": null,
  "branchId": "1",
  "businessNo": "",
  "categoryId": 1,
  "categoryName": "ရိုးရိုး",
  "chargePerUnit": 35,
  "consumerName": "ဦးအိုက်နပ်",
  "consumerType": "P",
  "coverSeal": null,
  "creditAmount": 79040,
  "creditReason": null,
  "creditUnit": 0,
  "currencyType": "ks",
  "customerId": "7324392739",
  "dueDate": "2016-07-28T15:15:28.307",
  "excelFileName": null,
  "feederID": 3,
  "groupId": 2,
  "horsePower": 0,
  "horsePowerCost": 0,
  "houseNo": "အမှတ်-၂၀/၂၂၊ တက္ကသိုလ်ရိပ်သာလမ်း",
  "id": 2,
  "insertDate": "2016-07-28T15:15:28.307",
  "installPerson": null,
  "isShowDebt": true,
  "issueDate": null,
  "joinDate": "23-12-2019",
  "lastDate": "2016-07-28T15:15:28.307",
  "lastMonthRedUnit": null,
  "lastReadUnit": 13151,
  "latitude": "22.9534015",
  "layerAmount": null,
  "layerDescription": null,
  "layerRate": null,
  "ledgerId": "BH1",
  "ledgerPostFix": "01/03",
  "longitude": "97.7405598",
  "mainLedgerId": 1,
  "mainLedgerTitle": "2110",
  "maintainenceCost": 500,
  "manufacturerNo": "10/30",
  "meterNo": "YA-046496",
  "meterSerial": "",
  "mobile": "09123456789",
  "multiplier": "1",
  "noLayer": false,
  "noOfRoom": 1,
  "oldAccount": null,
  "outDemand": null,
  "percentage": 0,
  "poleNo": null,
  "rate": "1 ",
  "payDate": "2016-07-28T15:15:28.307",
  "readDate": "2016-07-28T15:15:28.307",
  "requiredMatchGPS": false,
  "street": "နယ်မြေ(၁)",
  "streetLightCost": null,
  "terminalSeal": null,
  "transformerID": 49,
  "tspEng": null,
  "tspMM": null,
  "twinLeftSeal": null,
  "twinRightSeal": null,
  "voltage": "230",
  "wattLoad": "",
  "meterBill": 150000
};

var meterjson = {
  "AllowedUnit": 0,
  "Ampere": "10/30",
  "ApplyDate": null,
  "AutoPay": false,
  "AvageUseUnit": 99,
  "BillNeedModity": false,
  "BinderId": 5,
  "Block": null,
  "BranchId": "1",
  "BusinessNo": "",
  "CategoryId": 1,
  "CategoryName": "ရိုးရိုး",
  "ChargePerUnit": 35,
  "ConsumerName": "ဦးအိုက်နပ်",
  "ConsumerType": "P",
  "CoverSeal": null,
  "CreditAmount": 79040,
  "CreditReason": null,
  "CreditUnit": 0,
  "CurrencyType": "ks",
  "CustomerId": "7324392739",
  "DueDate": "November 17, 2021 at 12:00:00 AM UTC+6:30",
  "ExcelFileName": null,
  "FeederID": 3,
  "GroupId": 2,
  "HorsePower": 0,
  "HorsePowerCost": 0,
  "HouseNo": "အမှတ်-၂၀/၂၂၊ တက္ကသိုလ်ရိပ်သာလမ်း",
  "Id": 2,
  "InsertDate": "November 17, 2021 at 12:00:00 AM UTC+6:30",
  "InstallPerson": null,
  "IsShowDebt": true,
  "IssueDate": null,
  "JoinDate": "November 17, 2021 at 12:00:00 AM UTC+6:30",
  "LastDate": "November 17, 2021 at 12:00:00 AM UTC+6:30",
  "LastMonthRedUnit": null,
  "LastReadUnit": 13151,
  "Latitude": "22.9534015",
  "LayerAmount": null,
  "LayerDescription": null,
  "LayerRate": null,
  "LedgerId": "BH1",
  "LedgerPostFix": "01/03",
  "Longitude": "97.7405598",
  "MainLedgerId": 1,
  "MainLedgerTitle": "2110",
  "MaintainenceCost": 500,
  "ManufacturerNo": "10/30",
  "MeterNo": "YA-046496",
  "MeterSerial": "",
  "Mobile": "09123456789",
  "Multiplier": "1",
  "NoLayer": false,
  "NoOfRoom": 1,
  "OldAccount": null,
  "OutDemand": null,
  "Percentage": 0,
  "PoleNo": null,
  "Rate": "1 ",
  "ReadDate": "November 18, 2021 at 12:00:00 AM UTC+6:30",
  "RequiredMatchGPS": false,
  "Street": "နယ်မြေ(၁)",
  "StreetLightCost": null,
  "TerminalSeal": null,
  "TransformerID": 49,
  "TspEng": null,
  "TspMM": null,
  "TwinLeftSeal": null,
  "TwinRightSeal": null,
  "Voltage": "230",
  "WattLoad": "",
  "meterBill": 150000,
  "meterName": "Home"
};
