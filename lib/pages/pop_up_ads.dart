// @dart=2.9
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/intro_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:provider/provider.dart';

class PopupIntroModelPage extends StatefulWidget {
  PopupIntroModelPage({Key key}) : super(key: key);

  @override
  BetConfirmPageState createState() => BetConfirmPageState();
}

class BetConfirmPageState extends State<PopupIntroModelPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<IntroModel> adsItem = [];

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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
            future: getPromotion(),
            builder: (context, AsyncSnapshot<List<IntroModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 35),
                      color: Theme.of(context).primaryColor,
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
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(0),
                      color: Colors.white,
                      // Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data.length,
                        options: CarouselOptions(
                          aspectRatio: MediaQuery.of(context).size.height /
                              MediaQuery.of(context).size.width,
                          enableInfiniteScroll:
                              snapshot.data.length < 2 ? false : true,
                          height: MediaQuery.of(context).size.height,
                          autoPlay: snapshot.data.length < 2 ? false : true,
                          autoPlayInterval: const Duration(seconds: 8),
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                        ),
                        itemBuilder: (context, index, realIdx) {
                          return CachedNetworkImage(
                            httpHeaders: <String, String>{
                              "Access-Control-Allow-Origin": "*",
                            },
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            imageUrl: snapshot.data[index].imgUrl,
                            placeholder: (context, url) => SpinKitFadingCircle(
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          );
                        },
                      ),
                    ),
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
                              color: Colors.white.withOpacity(0.1),
                            ),
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 0,
                                    ),
                                    child: Text(
                                      Tran.of(context).text("skip"),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          // Colors.white,

                                          fontSize: 17),
                                    )),
                                Countdown(
                                  duration: Duration(seconds: 10),
                                  onFinish: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/',
                                            (Route<dynamic> route) => false);
                                  },
                                  builder:
                                      (BuildContext ctx, Duration remaining) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          left: 5,
                                          right: 20,
                                          bottom: 5),
                                      child: Text('${remaining.inSeconds}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              // Colors.white,
                                              fontSize: 17)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return false;
  }
}
