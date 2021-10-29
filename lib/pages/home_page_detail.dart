// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/pages/me_page.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:left_style/widgets/wallet.dart';

import 'package:provider/provider.dart';

import 'home_page.dart';
import 'notification_detail.dart';

class HomePageDetail extends StatefulWidget {
  const HomePageDetail({Key key}) : super(key: key);

  @override
  _HomePageDetailState createState() => _HomePageDetailState();
}

class _HomePageDetailState extends State<HomePageDetail> {
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
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      registerNotification(context);
    }
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void registerNotification(BuildContext context) async {
    _messaging = FirebaseMessaging.instance;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const IOSInitializationSettings initializationSettingsIos =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIos);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (!kIsWeb) {
      //await _messaging.subscribeToTopic('devTesting');
      await _messaging.subscribeToTopic('fcmtesting');
    }

    var datatoken = await DatabaseHelper.getData("fcmToken");

    if (datatoken != "" && datatoken != null) {
      _messaging.getToken().then((token) async {
        String data = await checkToken(token);
        if (data != null && data != "") {
          context.read<LoginProvider>().updateFCMtoken(context, data);
        }
        //print(token); // Print the Token in Console
      });
    } else {
      SystemData.fcmtoken = "";
    }

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      checkForInitialMessage();
      onMessage();
      onMessageOpenedApp(context);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      //print('User granted permission');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await checkForInitialMessage();
      await onMessage();
      onMessageOpenedApp(context);
    } else {
      //print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      //print(
      //'Message title: ${initialMessage.notification?.title}, body: ${initialMessage.notification?.body}, data: ${initialMessage.data}');

      //MessageHandel.ShowError(context, "", initialMessage.messageId);
      AndroidNotification android = initialMessage.notification?.android;
      if (initialMessage != null && android != null) {
        // flutterLocalNotificationsPlugin.show(
        //     initialMessage.hashCode,
        //     initialMessage.notification.title,
        //     initialMessage.notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(channel.id, channel.name,
        //           channelDescription: channel.description,
        //           playSound: true,
        //           importance: Importance.max,
        //           priority: Priority.high,
        //           enableVibration: true,
        //           autoCancel: true
        //           //sound: RawResourceAndroidNotificationSound('noti')
        //           ),
        //     ));
      }

      NotiModel _notification = NotiModel(
        // id: int.parse(initialMessage.data['id']),
        // userId: int.parse(initialMessage.data['userId']),
        title: initialMessage.data['title'].toString(),
        body: initialMessage.data['body'].toString(),
        imageUrl: initialMessage.data['imageUrl'].toString(),
        type: initialMessage.data['type'].toString(),
        status: initialMessage.data['status'].toString(),
        currentdate: initialMessage.data['currentdate'].toString(),
        // sound: initialMessage.data['sound'].toString(),
        // createdDateTimeStr:
        //     initialMessage.data['created_date_time_Str'].toString(),
        // clickAction: initialMessage.data["click_action"].toString(),
        // accountNo: initialMessage.data['account_no'].toString(),
        // bodyValue: initialMessage.data['body_value'].toString(),
        // content: initialMessage.data['content'].toString(),
        // number: initialMessage.data['number'].toString(),
        // balance: int.parse(initialMessage.data['balance']),
        // refid: int.parse(initialMessage.data['refid']),
        // state: initialMessage.data['state'].toString(),
        // requestDateStr: initialMessage.data['request_date_Str'].toString(),
        // amount: int.parse(initialMessage.data['amount']),
        // bill: initialMessage.data['bill'].toString(),
        // phoneno: initialMessage.data['phoneno'].toString(),
        // currentDateStr: initialMessage.data['current_date_Str'].toString(),
        // fortime: initialMessage.data['fortime'].toString(),
        // requestDate: initialMessage.data['request_date'].toString(),
        // time: initialMessage.data['time'].toString(),
        // createdDate: initialMessage.data['created_date'].toString(),
        // category: initialMessage.data['category'].toString(),
        // transactionNo: initialMessage.data['transaction_no'].toString(),
        // odd: int.parse(initialMessage.data['odd']),
        // guid: initialMessage.data['guid'].toString(),
        // messageId: initialMessage.notification.hashCode.toString(),
      );
      // await context.read<NotiProvider>().addNotiToStore(_notification);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           // NotificationListPage()
      //           NotificationDetailPage(noti: _notification, status: "false"), //
      //     ));
      SystemData.notiCount = SystemData.notiCount + 1;
      // setState(() {
      //   SystemData.notiCount = SystemData.notiCount + 1;
      // });
    }
  }

  onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.data);
      // NotiModel _notification = NotiModel(
      // id: int.parse(message.data['id']),
      // userId: int.parse(message.data['userId']),
      // messageId: message.notification.hashCode.toString(),
      // title: message.data['title'].toString(),
      // body: message.data['body'].toString(),
      // imageUrl: message.data['imageUrl'].toString(),
      // type: message.data['type'].toString(),
      // status: message.data['status'].toString(),
      // currentdate: message.data['currentdate'].toString(),
      // sound: message.data['sound'].toString(),
      // createdDateTimeStr:
      //     message.data['created_date_time_Str'].toString(),
      // clickAction: message.data["click_action"].toString(),
      // accountNo: message.data['account_no'].toString(),
      // bodyValue: message.data['body_value'].toString(),
      // content: message.data['content'].toString(),
      // number: message.data['number'].toString(),
      // balance: int.parse(message.data['balance']),
      // refid: int.parse(message.data['refid']),
      // state: message.data['state'].toString(),
      // requestDateStr: message.data['request_date_Str'].toString(),
      // amount: int.parse(message.data['amount']),
      // bill: message.data['bill'].toString(),
      // phoneno: message.data['phoneno'].toString(),
      // currentDateStr: message.data['current_date_Str'].toString(),
      // fortime: message.data['fortime'].toString(),
      // requestDate: message.data['request_date'].toString(),
      // time: message.data['time'].toString(),
      // createdDate: message.data['created_date'].toString(),
      // category: message.data['category'].toString(),
      // transactionNo: message.data['transaction_no'].toString(),
      // odd: int.parse(message.data['odd']),
      // guid: message.data['guid'].toString(),
      // messageId: message.notification.hashCode.toString(),
      // );
      // NotiModel _notification = NotiModel(
      //   // id: int.parse(initialMessage.data['id']),
      //   // userId: int.parse(initialMessage.data['userId']),
      //   title: message.data['title'].toString(),
      //   body: message.data['body'].toString(),
      //   imageUrl: message.data['imageUrl'].toString(),
      //   type: message.data['type'].toString(),
      //   status: message.data['status'].toString(),
      //   currentdate: message.data['currentdate'].toString(),
      //   // sound: initialMessage.data['sound'].toString(),
      //   // createdDateTimeStr:
      //   //     initialMessage.data['created_date_time_Str'].toString(),
      //   // clickAction: initialMessage.data["click_action"].toString(),
      //   // accountNo: initialMessage.data['account_no'].toString(),
      //   // bodyValue: initialMessage.data['body_value'].toString(),
      //   // content: initialMessage.data['content'].toString(),
      //   // number: initialMessage.data['number'].toString(),
      //   // balance: int.parse(initialMessage.data['balance']),
      //   // refid: int.parse(initialMessage.data['refid']),
      //   // state: initialMessage.data['state'].toString(),
      //   // requestDateStr: initialMessage.data['request_date_Str'].toString(),
      //   // amount: int.parse(initialMessage.data['amount']),
      //   // bill: initialMessage.data['bill'].toString(),
      //   // phoneno: initialMessage.data['phoneno'].toString(),
      //   // currentDateStr: initialMessage.data['current_date_Str'].toString(),
      //   // fortime: initialMessage.data['fortime'].toString(),
      //   // requestDate: initialMessage.data['request_date'].toString(),
      //   // time: initialMessage.data['time'].toString(),
      //   // createdDate: initialMessage.data['created_date'].toString(),
      //   // category: initialMessage.data['category'].toString(),
      //   // transactionNo: initialMessage.data['transaction_no'].toString(),
      //   // odd: int.parse(initialMessage.data['odd']),
      //   // guid: initialMessage.data['guid'].toString(),
      //   messageId: message.notification.hashCode.toString(),
      // );

      // await context.read<NotiProvider>().addNotiToStore(_notification);
      SystemData.notiCount = SystemData.notiCount + 1;
      // setState(() {
      //   SystemData.notiCount = SystemData.notiCount + 1;
      //   //context.read<BetProvider>().notiCount(context,SystemData.notiCount);
      // });
    });
  }

  onMessageOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

      AndroidNotification android = message.notification?.android;
      if (message != null && android != null) {
        // flutterLocalNotificationsPlugin.show(
        //     message.hashCode,
        //     message.notification.title,
        //     message.notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(channel.id, channel.name,
        //           channelDescription: channel.description,
        //           playSound: true,
        //           sound: RawResourceAndroidNotificationSound('noti'),
        //           importance: Importance.high,
        //           enableVibration: true,
        //           autoCancel: true),
        //     ));
      }

      // NotiModel _notification = NotiModel(
      //   id: int.parse(message.data['id']),
      //   sound: message.data['sound'].toString(),
      //   createdDateTimeStr: message.data['created_date_time_Str'].toString(),
      //   body: message.data['body'].toString(),
      //   type: message.data['type'].toString(),
      //   title: message.data['title'].toString(),
      //   clickAction: message.data["click_action"].toString(),
      //   accountNo: message.data['account_no'].toString(),
      //   bodyValue: message.data['body_value'].toString(),
      //   content: message.data['content'].toString(),
      //   number: message.data['number'].toString(),
      //   balance: int.parse(message.data['balance']),
      //   imageUrl: message.data['imageUrl'].toString(),
      //   refid: int.parse(message.data['refid']),
      //   state: message.data['state'].toString(),
      //   requestDateStr: message.data['request_date_Str'].toString(),
      //   amount: int.parse(message.data['amount']),
      //   bill: message.data['bill'].toString(),
      //   phoneno: message.data['phoneno'].toString(),
      //   currentDateStr: message.data['current_date_Str'].toString(),
      //   fortime: message.data['fortime'].toString(),
      //   userId: int.parse(message.data['userId']),
      //   requestDate: message.data['request_date'].toString(),
      //   currentdate: message.data['currentdate'].toString(),
      //   time: message.data['time'].toString(),
      //   createdDate: message.data['created_date'].toString(),
      //   category: message.data['category'].toString(),
      //   transactionNo: message.data['transaction_no'].toString(),
      //   status: message.data['status'].toString(),
      //   odd: int.parse(message.data['odd']),
      //   guid: message.data['guid'].toString(),
      //   messageId:message.notification.hashCode.toString(),
      // );
      // NotiModel _notification = NotiModel(
      //   // id: int.parse(message.data['id']),
      //   // userId: int.parse(message.data['userId']),
      //   title: message.data['title'].toString(),
      //   body: message.data['body'].toString(),
      //   imageUrl: message.data['imageUrl'].toString(),
      //   type: message.data['type'].toString(),
      //   status: message.data['status'].toString(),
      //   currentdate: message.data['currentdate'].toString(),
      //   // sound: message.data['sound'].toString(),
      //   // createdDateTimeStr:
      //   //     message.data['created_date_time_Str'].toString(),
      //   // clickAction: message.data["click_action"].toString(),
      //   // accountNo: message.data['account_no'].toString(),
      //   // bodyValue: message.data['body_value'].toString(),
      //   // content: message.data['content'].toString(),
      //   // number: message.data['number'].toString(),
      //   // balance: int.parse(message.data['balance']),
      //   // refid: int.parse(message.data['refid']),
      //   // state: message.data['state'].toString(),
      //   // requestDateStr: message.data['request_date_Str'].toString(),
      //   // amount: int.parse(message.data['amount']),
      //   // bill: message.data['bill'].toString(),
      //   // phoneno: message.data['phoneno'].toString(),
      //   // currentDateStr: message.data['current_date_Str'].toString(),
      //   // fortime: message.data['fortime'].toString(),
      //   // requestDate: message.data['request_date'].toString(),
      //   // time: message.data['time'].toString(),
      //   // createdDate: message.data['created_date'].toString(),
      //   // category: message.data['category'].toString(),
      //   // transactionNo: message.data['transaction_no'].toString(),
      //   // odd: int.parse(message.data['odd']),
      //   // guid: message.data['guid'].toString(),
      // messageId: message.notification.hashCode.toString(),
      // );

      NotiModel _notification = NotiModel(
          // id: int.parse(message.data['id']),
          // userId: int.parse(message.data['userId']),
          title: message.notification.title,
          // title: message.data['title'].toString(),
          body: message.notification.body,
          imageUrl: message.notification.android.imageUrl,
          type: message.messageType,
          status: "true",
          messageId: message.notification.hashCode.toString()
          // message.data['message_id'].toString(),
// currentdate:DateTime. message.sentTime.
//  content:message.sentTime,

          // imageUrl: message.data['imageUrl'].toString(),
          // type: message.data['type'].toString(),
          // status: message.data['status'].toString(),
          // currentdate: message.data['currentdate'].toString(),
          );

      print(_notification);
      await context.read<NotiProvider>().addNotiToStore(_notification);
      // Navigator.pushNamed(context, routeName)
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NotificationDetailPage(
                  noti: _notification, status: "true"), //
            ));
      });

      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => NotificationListPage(), //
      //   ),
      // );

      SystemData.notiCount = SystemData.notiCount + 1;
      // setState(() {
      //   SystemData.notiCount = SystemData.notiCount + 1;
      // });
    });
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

  static MePage _mePage = MePage();
  static HomePage _homePage = HomePage();
  static Wallet _walletPage = Wallet();

  PageController controller = PageController();
  List<Widget> _list = <Widget>[

    Center(child: _homePage),
    Center(child: _walletPage),
    Center(child: _mePage),
  ];
  int bottomSelectedIndex = 0;

  Future<void> bottomTapped(int index) async {
    setState(() {
      bottomSelectedIndex = index;
      controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
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
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(FontAwesomeIcons.home),
              icon: Icon(FontAwesomeIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.wallet,
              ),
              icon: Icon(FontAwesomeIcons.wallet),
              label: "Wallet",
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(FontAwesomeIcons.user),
                icon: Icon(FontAwesomeIcons.user),
                label: "Me"),
          ],
        ),
      ),
    );
  }
}
