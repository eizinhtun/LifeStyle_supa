// @dart=2.9
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/intro_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:provider/provider.dart';

class PopupAdsPage extends StatefulWidget {
  PopupAdsPage({Key key}) : super(key: key);

  @override
  BetConfirmPageState createState() => BetConfirmPageState();
}

class BetConfirmPageState extends State<PopupAdsPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CarouselController carouselController = CarouselController();
  List<IntroModel> adsItem = [];
  int duration = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  getPromotionIntroModel() async {
    adsItem = await context.read<LoginProvider>().getIntroList(context);
  }

  Future<List<IntroModel>> getPromotion() async {
    var introRef = FirebaseFirestore.instance.collection(introCollection);
    List<IntroModel> list = [];
    await introRef.get().then((value) {
      value.docs.forEach((result) {
        if (result.data()['isActive']) {
          list.add(IntroModel.fromJson(result.data()));
        }
      });
    });

    adsItem = list;
    return list;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _launchURL(String _url) async => await canLaunch(_url)
  //     ? await launch(_url)
  //     : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(children: [
          FutureBuilder(
              future: getPromotion(),

              // StreamBuilder<QuerySnapshot>(
              //     stream: FirebaseFirestore.instance
              //         .collection(introCollection)
              //         .snapshots(),
              builder: (context, AsyncSnapshot<List<IntroModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                        padding: const EdgeInsets.only(top: 35),
                        color: Colors.transparent,
                        // Theme.of(context).primaryColor,
                        alignment: Alignment.center,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                        )),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      child: Stack(
                        children: [
                          Countdown(
                            duration: Duration(microseconds: 0),
                            onFinish: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (Route<dynamic> route) => false);
                            },
                            builder: (BuildContext ctx, Duration remaining) {
                              return Container();
                            },
                          ),
                          SpinKitFadingCircle(
                            color: Colors.white,
                          )
                        ],
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(0),
                        color: Colors.white,
                        // Theme.of(context).primaryColor,
                        alignment: Alignment.center,
                        child: CarouselSlider(
                          carouselController: carouselController,
                          options: CarouselOptions(
                            aspectRatio: MediaQuery.of(context).size.height /
                                MediaQuery.of(context).size.width,
                            reverse: true,
                            enableInfiniteScroll:
                                // snapshot.data.length < 2 ? false :
                                true,
                            height: MediaQuery.of(context).size.height,
                            autoPlay:
                                // snapshot.data.length < 2 ? false :
                                true,
                            autoPlayInterval: const Duration(seconds: 4),
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              if (mounted) {
                                setState(() {
                                  currentIndex = index;
                                });
                              }
                            },
                          ),
                          items: snapshot.data.map(
                            (item) {
                              return CachedNetworkImage(
                                httpHeaders: <String, String>{
                                  "Access-Control-Allow-Origin": "*",
                                },
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                imageUrl: item.imgUrl,
                                placeholder: (context, url) =>
                                    SpinKitFadingCircle(
                                  color: Colors.white,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: snapshot.data.length > 0
                            ? DotsIndicator(
                                dotsCount: snapshot.data.length,
                                position: currentIndex.toDouble(),
                                onTap: (position) {
                                  setState(() {
                                    currentIndex = position.toInt();
                                  });
                                },
                                decorator: DotsDecorator(
                                  size: const Size.square(9.0),
                                  activeSize: const Size(18.0, 9.0),
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Stack(
                      children: [
                        Countdown(
                          duration: Duration(milliseconds: 0),
                          onFinish: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                          builder: (BuildContext ctx, Duration remaining) {
                            return Container();
                          },
                        ),
                        SpinKitFadingCircle(
                          color: Colors.white,
                        )
                      ],
                    ),
                  );
                }
              }),
          Positioned(
            top: 0,
            right: 10,
            child: SafeArea(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      left: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      top: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      right: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      bottom: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                    ),
                    // border: Border(bottom: ),
                    // color: Theme.of(context).primaryColor,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: !SystemData.introAutoSkip
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 0,
                              ),
                              child: Text(
                                Tran.of(context).text("skip"),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    // Colors.white,

                                    fontSize: 17),
                              ),
                            ),
                            Countdown(
                              duration:
                                  Duration(seconds: SystemData.introDisplaySec),
                              onFinish: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                              },
                              builder: (BuildContext ctx, Duration remaining) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 5, right: 20, bottom: 5),
                                  child: Text('${remaining.inSeconds}',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          // Colors.white,
                                          fontSize: 17)),
                                );
                              },
                            ),
                          ],
                        )
                      : Countdown(
                          duration:
                              Duration(seconds: SystemData.introDisplaySec),
                          onFinish: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                          builder: (BuildContext ctx, Duration remaining) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              child: Text('${remaining.inSeconds}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      // Colors.white,
                                      fontSize: 17)),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return false;
  }
}
