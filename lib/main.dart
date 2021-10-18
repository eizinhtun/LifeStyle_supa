// @dart=2.9

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:left_style/pages/home_page_detail.dart';
import 'package:left_style/pages/init_screen.dart';
import 'package:left_style/pages/login.dart';
import 'package:left_style/pages/user_not_active.dart';
import 'package:left_style/pages/user_profile.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'datas/constants.dart';
import 'datas/database_helper.dart';
import 'datas/system_data.dart';
import 'localization/LocalizationsDelegate.dart';
import 'models/noti_model.dart';
import 'pages/noti_screen.dart';
import 'providers/login_provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'id', // id
  'title', // title
  description: 'description', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   //firebase push notification
//   AwesomeNotifications().createNotificationFromJsonData(message.data);
// }

void main() async {
  //statusbar hide
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  //firebase messaging
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: Color(0xFF9D50DD),
  //       ledColor: Colors.white)
  // ]);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: "3105247143054675", //<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }

  // runApp(MyApp());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
    ChangeNotifierProvider(create: (_) => NotiProvider()),
  ], child: MyApp()));
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _messaging;

  @override
  void initState() {
    if (!kIsWeb) {
      registerNotification();
    }
    super.initState();
  }

  void registerNotification() async {
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
      onMessageOpenedApp();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      //print('User granted permission');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await checkForInitialMessage();
      await onMessage();
      onMessageOpenedApp();
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
        flutterLocalNotificationsPlugin.show(
            initialMessage.hashCode,
            initialMessage.notification.title,
            initialMessage.notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  playSound: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  enableVibration: true,
                  autoCancel: true
                  //sound: RawResourceAndroidNotificationSound('noti')
                  ),
            ));
      }

      NotiModel _notification = NotiModel(
        id: int.parse(initialMessage.data['id']),
        sound: initialMessage.data['sound'].toString(),
        createdDateTimeStr:
            initialMessage.data['created_date_time_Str'].toString(),
        body: initialMessage.data['body'].toString(),
        type: initialMessage.data['type'].toString(),
        title: initialMessage.data['title'].toString(),
        clickAction: initialMessage.data["click_action"].toString(),
        accountNo: initialMessage.data['account_no'].toString(),
        bodyValue: initialMessage.data['body_value'].toString(),
        content: initialMessage.data['content'].toString(),
        number: initialMessage.data['number'].toString(),
        balance: int.parse(initialMessage.data['balance']),
        imageUrl: initialMessage.data['imageUrl'].toString(),
        refid: int.parse(initialMessage.data['refid']),
        state: initialMessage.data['state'].toString(),
        requestDateStr: initialMessage.data['request_date_Str'].toString(),
        amount: int.parse(initialMessage.data['amount']),
        bill: initialMessage.data['bill'].toString(),
        phoneno: initialMessage.data['phoneno'].toString(),
        currentDateStr: initialMessage.data['current_date_Str'].toString(),
        fortime: initialMessage.data['fortime'].toString(),
        userId: int.parse(initialMessage.data['user_id']),
        requestDate: initialMessage.data['request_date'].toString(),
        currentdate: initialMessage.data['currentdate'].toString(),
        time: initialMessage.data['time'].toString(),
        createdDate: initialMessage.data['created_date'].toString(),
        category: initialMessage.data['category'].toString(),
        transactionNo: initialMessage.data['transaction_no'].toString(),
        status: initialMessage.data['status'].toString(),
        odd: int.parse(initialMessage.data['odd']),
        guid: initialMessage.data['guid'].toString(),
        messageId: initialMessage.data['message_id'].toString(),
      );

      // await Navigator.push(
      //     context,
      //     new MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           NotificationDetailPage(
      //               items: _notification, status: "false"), //
      //     ));

      setState(() {
        SystemData.notiCount = SystemData.notiCount + 1;
      });
    }
  }

  onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.data);
      setState(() {
        SystemData.notiCount = SystemData.notiCount + 1;
        //context.read<BetProvider>().notiCount(context,SystemData.notiCount);
      });
    });
  }

  onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

      AndroidNotification android = message.notification?.android;
      if (message != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification.title,
            message.notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  playSound: true,
                  sound: RawResourceAndroidNotificationSound('noti'),
                  importance: Importance.high,
                  enableVibration: true,
                  autoCancel: true),
            ));
      }

      NotiModel _notification = NotiModel(
        id: int.parse(message.data['id']),
        sound: message.data['sound'].toString(),
        createdDateTimeStr: message.data['created_date_time_Str'].toString(),
        body: message.data['body'].toString(),
        type: message.data['type'].toString(),
        title: message.data['title'].toString(),
        clickAction: message.data["click_action"].toString(),
        accountNo: message.data['account_no'].toString(),
        bodyValue: message.data['body_value'].toString(),
        content: message.data['content'].toString(),
        number: message.data['number'].toString(),
        balance: int.parse(message.data['balance']),
        imageUrl: message.data['imageUrl'].toString(),
        refid: int.parse(message.data['refid']),
        state: message.data['state'].toString(),
        requestDateStr: message.data['request_date_Str'].toString(),
        amount: int.parse(message.data['amount']),
        bill: message.data['bill'].toString(),
        phoneno: message.data['phoneno'].toString(),
        currentDateStr: message.data['current_date_Str'].toString(),
        fortime: message.data['fortime'].toString(),
        userId: int.parse(message.data['user_id']),
        requestDate: message.data['request_date'].toString(),
        currentdate: message.data['currentdate'].toString(),
        time: message.data['time'].toString(),
        createdDate: message.data['created_date'].toString(),
        category: message.data['category'].toString(),
        transactionNo: message.data['transaction_no'].toString(),
        status: message.data['status'].toString(),
        odd: int.parse(message.data['odd']),
        guid: message.data['guid'].toString(),
        messageId: message.data['message_id'].toString(),
      );

      // await Navigator.push(
      //     context,
      //     new MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           //new NotificationDetailPage(items:NotiModel.fromJson(message.data)),//
      //           new NotificationDetailPage(
      //               items: _notification, status: "false"), //
      //       //new NotificationListsPage()
      //     ));
      setState(() {
        SystemData.notiCount = SystemData.notiCount + 1;
      });
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

  // void firebaseCloudMessaging_Listeners() {
  //   if (Platform.isIOS) iOS_Permission();

  //   _messaging.getToken().then((token) {
  //     print(token);
  //   });

  //   _messaging.(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }

  // void iOS_Permission() {
  //   _messaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _messaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFfa2e73, color);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unifine',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;

            if (user == null) {
              return LoginPage();
            }
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(userCollection)
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data.exists) {
                      print(snapshot.data["isActive"]);
                      if (snapshot.data["isActive"]) {
                        return HomePageDetail();
                      } else {
                        return UserNotActiveScreen();
                      }
                    } else
                      return UserProfileScreen();
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // initialRoute: '/',
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   '/': (context) =>
      //       // NotiScreen(),
      //       InitScreen(),
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   '/login': (context) {
      //     return LoginPage();
      //   },
      // },

      supportedLocales: [
        ///////const Locale('', ''),
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
        const Locale('my', 'MM'),
      ],
      localizationsDelegates: [
        const MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      //     home:  FutureBuilder<User>(
      //   future:FirebaseAuth.instance.currentUser(),
      //   //  FirebaseAuth!.instance!.currentUser(),
      //   builder: (BuildContext context, AsyncSnapshot<User> snapshot){
      //              if (snapshot.hasData){
      //                  User user = snapshot.data; // this is your user instance
      //                  /// is because there is user already logged
      //                  return MainScreen();
      //               }
      //                /// other way there is no user logged.
      //                return LoginScreen();
      //    }
      // );

      // RegisterVerifyPinPage(),
      // OTPFill()
      //home: SignInScreen(),
      //home: AuthLogin(),
      // PhoneNumberPage(),
      //home: UploadImageFirebase(),
    );
  }
}
