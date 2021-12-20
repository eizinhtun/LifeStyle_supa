// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/data_key_name.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_model.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/pages/me_page.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:upgrader/upgrader.dart';
import 'explore_page.dart';
import 'home_page.dart';
import 'wallet/wallet_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  FirebaseMessaging _messaging;
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'id', // id
    'title', // title
    description: 'description', // description
    importance: Importance.high,
    playSound: true,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   await Firebase.initializeApp();
  // }

  static MePage _mePage = MePage();
  static HomePage _homePage = HomePage();
  static Wallet _walletPage = Wallet();
  static ExplorePage _explorePage = ExplorePage();

  PageController controller = PageController();
  List<Widget> _list = [];
  int bottomSelectedIndex = 0;
  String link = "";

  @override
  void initState() {
    super.initState();
    getLink();
    _mePage = MePage(main: this);
    _list = <Widget>[
      Center(child: _homePage),
      Center(child: _walletPage),
      Center(child: _explorePage),
      Center(child: _mePage),
    ];
    // getData();
    if (!kIsWeb) {
      subscriptToMeters();
    }
  }

  getLink() async {
    link = await DatabaseHelper.getData(DataKeyValue.updateLink);
  }

  Future<void> subscriptToMeters() async {
    _messaging = FirebaseMessaging.instance;
    meterList = await getMeterList(context);

    meterList.forEach((m) async {
      await _messaging.subscribeToTopic('meter_${m.customerId}');
    });
  }

  Future<List<Meter>> getMeterList(BuildContext context) async {
    var meterRef = FirebaseFirestore.instance.collection(meterCollection);
    List<Meter> list = [];
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      try {
        await meterRef
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(userMeterCollection)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            list.add(Meter.fromJson(result.data()));
          });
        });
      } catch (e) {
        ShowMessageHandler.showErrMessage(
            context,
            Tran.of(context).text("fail"),
            Tran.of(context).text("get_meter_fail"));
      }
    }
    return list;
  }

  List<NotiModel> notiList = [];
  List<Meter> meterList = [];

  // getData() async {
  //   notiList = await context.read<NotiProvider>().getNotiList(context);

  //   context.read<NotiProvider>().updateNotiCount(context, SystemData.notiCount);
  //   // if (mounted) {
  //   //   setState(() {});
  //   // }
  // }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void refreshPage() {
    setState(() {});
  }

  Future<String> checkToken(String fcmtoken) async {
    String tokenStr = "";
    if (!kIsWeb) {
      if (fcmtoken == null || fcmtoken == "") {
        tokenStr = await _messaging.getToken();
        if (tokenStr == null || tokenStr == "") {
          tokenStr = await checkToken(tokenStr);
        } else {
          SystemData.fcmtoken = tokenStr;
        }
        return tokenStr;
      } else {
        return fcmtoken;
      }
    } else {
      return null;
    }
  }

  Future<void> bottomTapped(int index) async {
    // setState(() async {
    bottomSelectedIndex = index;
    controller.jumpToPage(index);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final cfg = AppcastConfiguration(url: link, supportedOS: ['android']);
    if (kIsWeb) {
      //running on web
    } else {
      if (Platform.isAndroid) {
        Upgrader().clearSavedSettings();
      }
    }
    return Scaffold(
      body: UpgradeAlert(
        showReleaseNotes: true,
        appcastConfig: cfg,
        debugAlwaysUpgrade: false,
        debugDisplayOnce: false,
        durationToAlertAgain: const Duration(minutes: 3),
        debugLogging: true,
        canDismissDialog: true,
        // minAppVersion: ,
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: PageView(
          children: _list,
          scrollDirection: Axis.horizontal,
          // reverse: true,
          // physics: BouncingScrollPhysics(),
          controller: controller,
          onPageChanged: (num) {
            setState(() {
              bottomSelectedIndex = num;
            });
          },
        ),
      ),
      bottomNavigationBar:
          // SizedBox(
          //   height: 91,
          //   child:
          BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              FontAwesomeIcons.home,
              // size: ,
            ),
            icon: Icon(FontAwesomeIcons.home),
            label: Tran.of(context).text("home"),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              FontAwesomeIcons.wallet,
            ),
            icon: Icon(FontAwesomeIcons.wallet),
            label: Tran.of(context).text("wallet"),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              FontAwesomeIcons.search,
            ),
            icon: Icon(FontAwesomeIcons.search),
            label: Tran.of(context).text("explore"),
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(FontAwesomeIcons.user),
              icon: Icon(FontAwesomeIcons.user),
              label: Tran.of(context).text("me")),
        ],
      ),
      // ),
    );
  }

  double iconSize = 20;
}


            // Container(
            //           height: titleHeight,
            //           child: ListTile(
            //             onTap: () {
            //               Navigator.of(context).push(MaterialPageRoute(
            //                   builder: (context) => NotificationListPage()));
            //               setState(() {});
            //             },
            //             leading: Container(
            //               width: leadingWidth,
            //               alignment: Alignment.centerLeft,
            //               child: Stack(
            //                 children: [
            //                   Icon(
            //                     Icons.notifications,
            //                     size: iconSize,
            //                     color: mainColor,
            //                   ),
            //                   (SystemData.notiCount != null &&
            //                           SystemData.notiCount > 0)
            //                       ? Container(
            //                           width: iconSize,
            //                           height: iconSize,
            //                           alignment: Alignment.topRight,
            //                           margin: const EdgeInsets.only(top: 5),
            //                           child: Container(
            //                             width: iconSize / 2,
            //                             height: iconSize / 2,
            //                             alignment: Alignment.center,
            //                             // padding: const EdgeInsets.all(2),
            //                             decoration: BoxDecoration(
            //                               shape: BoxShape.circle,
            //                               border: Border.all(
            //                                   color: Colors.white, width: 1),
            //                               color: Colors.red,
            //                             ),
            //                             child: Text(
            //                               getNotiCount(SystemData.notiCount),
            //                               style: const TextStyle(
            //                                 fontSize: 10,
            //                                 color: Colors.white,
            //                               ),
            //                             ),
            //                           ),
            //                         )
            //                       : Text(""),
            //                 ],
            //               ),
            //             ),
            //             title: Text(
            //               Tran.of(context).text("notification"),
            //               style: const TextStyle(fontWeight: FontWeight.bold),
            //             ),
            //             trailing: Icon(
            //               Icons.arrow_forward_ios,
            //               size: 15,
            //               color: Colors.black26,
            //             ),
            //           ),
            //         ),
                    
                    