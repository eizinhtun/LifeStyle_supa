// @dart=2.9
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/pages/content_notification_detail_page.dart';
import 'package:left_style/pages/login_page.dart';
import 'package:left_style/pages/main_screen.dart';
import 'package:left_style/pages/my_meterBill_detail.dart';
import 'package:left_style/pages/pop_up_ads.dart';
import 'package:left_style/pages/upload_my_read.dart';
import 'package:left_style/pages/user_not_active.dart';
import 'package:left_style/pages/user_profile.dart';
import 'package:left_style/providers/language_provider.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/providers/meter_provider.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'datas/constants.dart';
import 'localization/localizations_delegate.dart';
import 'localization/translate.dart';
import 'pages/notification_detail.dart';
import 'pages/wallet/wallet_detail_success_page.dart';
import 'providers/login_provider.dart';
import 'providers/meter_bill_provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'id',
  'title',
  description: 'description',
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _messageHandler(RemoteMessage message) async {}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

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

  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: "894777384749453", //<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
    ),
    ChangeNotifierProvider(create: (_) => WalletProvider()),
    ChangeNotifierProvider(create: (_) => MeterProvider()),
    ChangeNotifierProvider(create: (_) => MeterBillProvider()),
    ChangeNotifierProvider(create: (_) => NotiProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

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
  void initState() {
    super.initState();
    if (!kIsWeb) {
      registerNotification(context);
      subscriptToPublicChannel();
    }
  }

  Future<void> subscriptToPublicChannel() async {
    _messaging = FirebaseMessaging.instance;
    var subscriptionRef =
        FirebaseFirestore.instance.collection(subscriptionCollection);
    try {
      await subscriptionRef.get().then((value) {
        value.docs.forEach((result) async {
          await _messaging.subscribeToTopic(result.data()['channel_id']);
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFfa2e73, color);

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        key: key,
        navigatorKey: MyApp.navKey,
        debugShowCheckedModeBanner: false,
        title: 'Unifine',
        theme: ThemeData(
          primarySwatch: colorCustom,
          fontFamily: 'NotoSansMyanmar',
        ),
        initialRoute: '/ads',
        routes: {
          '/': (context) {
            return StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User user = snapshot.data;
                  if (user == null) {
                    return LoginPage();
                    // setState(() {});
                  }

                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(userCollection)
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          // && snapshot.data.exists
                          if (snapshot.hasData && snapshot.data.exists) {
                            //
                            if (snapshot.data["isActive"]) {
                              return MainScreen();
                              // return _bottomNav(context);

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
            );
          },
          '/ads': (context) => PopupIntroModelPage(),
        },
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
          const Locale('my', 'MM'),
        ],
        localizationsDelegates: [
          const MyLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }

  FirebaseMessaging _messaging;

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

  void registerNotification(BuildContext context) async {
    _messaging = FirebaseMessaging.instance;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const IOSInitializationSettings initializationSettingsIos =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIos,
            macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.subscribeToTopic('fcmtesting');

    var datatoken = await DatabaseHelper.getData("fcmToken");

    if (datatoken != "" && datatoken != null) {
      _messaging.getToken().then((token) async {
        String data = await checkToken(token);
        if (data != null && data != "") {
          context.read<LoginProvider>().updateFCMtoken(context, data);
        }
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
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      checkForInitialMessage();
      onMessage();
      onMessageOpenedApp(context);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await checkForInitialMessage();
      await onMessage();
      onMessageOpenedApp(context);
    } else {}
  }

  checkForInitialMessage() async {
    var backgroundNotificationStatus =
        await DatabaseHelper.getData(SystemData.backgroundNotiStatus);

    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null &&
        (backgroundNotificationStatus == null ||
            backgroundNotificationStatus == "")) {
      print(
          'Message title: ${initialMessage.notification?.title}, body: ${initialMessage.notification?.body}, data: ${initialMessage.data}');

      NotiModel _notification = NotiModel(
        id: initialMessage.data['id'],
        title: initialMessage.data['title'].toString(),
        body: initialMessage.data['body'].toString(),

        imageUrl: initialMessage.data['imageUrl'].toString(),
        type: initialMessage.data['type'].toString(),
        amount: int.parse(initialMessage.data['amount']),

        clickAction: initialMessage.data["click_action"].toString(),
        status: initialMessage.data['status'],
        createdDate: initialMessage.data['created_date'],

        messageId: initialMessage.notification.hashCode.toString(),
        transactionNo: initialMessage.data['transaction_no'],

        content: initialMessage.data['content'].toString(),

        // currentdate: initialMessage.data['currentdate'],
        // userId: int.parse(initialMessage.data['userId']),
        // sound: initialMessage.data['sound'].toString(),
        // createdDateTimeStr:
        //     initialMessage.data['created_date_time_Str'].toString(),
        // accountNo: initialMessage.data['account_no'].toString(),
        // bodyValue: initialMessage.data['body_value'].toString(),
        // number: initialMessage.data['number'].toString(),
        // balance: int.parse(initialMessage.data['balance']),
        // refid: int.parse(initialMessage.data['refid']),
        // state: initialMessage.data['state'].toString(),
        // requestDateStr: initialMessage.data['request_date_Str'].toString(),
        // bill: initialMessage.data['bill'].toString(),
        // phoneno: initialMessage.data['phoneno'].toString(),
        // currentDateStr: initialMessage.data['current_date_Str'].toString(),
        // fortime: initialMessage.data['fortime'].toString(),
        // requestDate: initialMessage.data['request_date'].toString(),
        // time: initialMessage.data['time'].toString(),
        // category: initialMessage.data['category'].toString(),
        // transactionNo: initialMessage.data['transaction_no'].toString(),
        // odd: int.parse(initialMessage.data['odd']),
        // guid: initialMessage.data['guid'].toString(),
      );

      await MyApp.navKey.currentState.push(
        MaterialPageRoute(
          builder: (_) =>
              NotificationDetailPage(noti: _notification, status: "false"),
        ),
      );
      if (SystemData.isLoggedIn) {
        setState(() {
          SystemData.notiCount = SystemData.notiCount + 1;
          context
              .read<NotiProvider>()
              .updateNotiCount(context, SystemData.notiCount);
        });
      }
    }
  }

  onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

      var androidPlatformChannel = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelShowBadge: true,
        channelDescription: channel.description,
        color: Color.fromARGB(255, 0, 0, 0),
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('noti'),
        playSound: true,
        priority: Priority.high,
      );

      var platform =
          NotificationDetails(android: androidPlatformChannel, iOS: null);

      await flutterLocalNotificationsPlugin.show(
          0,
          message.data['title'].toString(),
          message.data['body'].toString(),
          platform,
          payload: message.data['body'].toString());

      Timer(Duration(seconds: 4), () {
        flutterLocalNotificationsPlugin.cancel(0);
      });

      NotiModel _notification = NotiModel(
        id: message.data['id'].toString(),
        title: message.data['title'].toString(),
        body: message.data['body'].toString(),

        imageUrl: message.data['imageUrl'].toString(),
        type: message.data['type'].toString(),

        clickAction: message.data["click_action"].toString(),
        status: message.data['status'] ?? false,
        createdDate: message.data['created_date'],

        messageId: message.notification.hashCode.toString(),
        transactionNo: message.data['transaction_no'].toString(),

        content: message.data['content'].toString(),
        // amount: (message.data['amount'] == null || message.data['amount'] == "")
        //     ? 0
        //     : int.parse(message.data['amount']),
        // currentdate: message.data['currentdate'],
        // userId: int.parse(message.data['userId']),
        // sound: message.data['sound'].toString(),
        // createdDateTimeStr:
        //     message.data['created_date_time_Str'].toString(),
        // accountNo: message.data['account_no'].toString(),
        // bodyValue: message.data['body_value'].toString(),
        // number: message.data['number'].toString(),
        // balance: int.parse(message.data['balance']),
        // refid: int.parse(message.data['refid']),
        // state: message.data['state'].toString(),
        // requestDateStr: message.data['request_date_Str'].toString(),
        // bill: message.data['bill'].toString(),
        // phoneno: message.data['phoneno'].toString(),
        // currentDateStr: message.data['current_date_Str'].toString(),
        // fortime: message.data['fortime'].toString(),
        // requestDate: message.data['request_date'].toString(),
        // time: message.data['time'].toString(),
        // category: message.data['category'].toString(),
        // transactionNo: message.data['transaction_no'].toString(),
        // odd: int.parse(message.data['odd']),
        // guid: message.data['guid'].toString(),
      );

      final context = MyApp.navKey.currentState.overlay.context;
      _showAlertDialog(context, _notification);
      if (SystemData.isLoggedIn) {
        SystemData.notiCount = SystemData.notiCount + 1;
        context
            .read<NotiProvider>()
            .updateNotiCount(context, SystemData.notiCount);
      }
    });
  }

  onMessageOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

      NotiModel _notification = NotiModel(
        id: message.data['id'].toString(),
        title: message.data['title'].toString(),
        body: message.data['body'].toString(),

        imageUrl: message.data['imageUrl'].toString(),
        type: message.data['type'].toString(),

        clickAction: message.data["click_action"].toString(),
        status: message.data['status'] ?? false,
        createdDate: message.data['created_date'],

        messageId: message.notification.hashCode.toString(),
        transactionNo: message.data['transaction_no'].toString(),

        content: message.data['content'].toString(),

        // amount: (message.data['amount'] == null || message.data['amount'] == "")
        //     ? 0
        //     : int.parse(message.data['amount']),
        // currentdate: message.data['currentdate'],

        // userId: int.parse(message.data['userId']),
        // sound: message.data['sound'].toString(),
        // createdDateTimeStr:
        //     message.data['created_date_time_Str'].toString(),
        // accountNo: message.data['account_no'].toString(),
        // bodyValue: message.data['body_value'].toString(),
        // number: message.data['number'].toString(),
        // balance: int.parse(message.data['balance']),
        // refid: int.parse(message.data['refid']),
        // state: message.data['state'].toString(),
        // requestDateStr: message.data['request_date_Str'].toString(),
        // bill: message.data['bill'].toString(),
        // phoneno: message.data['phoneno'].toString(),
        // currentDateStr: message.data['current_date_Str'].toString(),
        // fortime: message.data['fortime'].toString(),
        // requestDate: message.data['request_date'].toString(),
        // time: message.data['time'].toString(),
        // category: message.data['category'].toString(),
        // transactionNo: message.data['transaction_no'].toString(),
        // odd: int.parse(message.data['odd']),
        // guid: message.data['guid'].toString(),
      );

      switch (_notification.type) {
        case NotiType.topup:
          await MyApp.navKey.currentState.push(
            MaterialPageRoute(
              builder: (_) => WalletDetailSuccessPage(
                docId: _notification.id,
              ),
            ),
          );
          break;
        case NotiType.withdraw:
          await MyApp.navKey.currentState.push(
            MaterialPageRoute(
              builder: (_) => WalletDetailSuccessPage(
                docId: _notification.id,
              ),
            ),
          );
          break;
        case NotiType.meterbill:
          // String tempId = "7324392739";

          await MyApp.navKey.currentState.push(
            MaterialPageRoute(
              builder: (_) => MeterBillDetailPage(
                docId: _notification.id,
              ),
            ),
          );
          break;
        case NotiType.readMeter:
          // String tempId = "7324392739";

          await MyApp.navKey.currentState.push(
            MaterialPageRoute(
                builder: (_) => UploadMyReadScreen(
                      customerId: _notification.id,
                    )),
          );
          break;

        case NotiType.content:
          await MyApp.navKey.currentState.push(
            MaterialPageRoute(
              builder: (_) => ContentNotificationDetailPage(
                  noti: _notification, status: "true"),
            ),
          );
          break;
        // default:
        //   await MyApp.navKey.currentState.push(
        //     MaterialPageRoute(
        //       builder: (_) => ),
        //     ),
        //   );
        //   break;
      }

      if (SystemData.isLoggedIn) {
        setState(() {
          SystemData.notiCount = SystemData.notiCount + 1;
          context
              .read<NotiProvider>()
              .updateNotiCount(context, SystemData.notiCount);
        });
      }
    });
  }

  Future<void> _showAlertDialog(BuildContext context, NotiModel _notification) {
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
                child: Text(
                  Tran.of(context).text("close"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  return null;
                },
              ),
              SizedBox(
                width: 20,
              ),
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
                child: Text(
                  Tran.of(context).text("go_to_detail"),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  switch (_notification.type) {
                    case NotiType.topup:
                      await MyApp.navKey.currentState.push(
                        MaterialPageRoute(
                          builder: (_) => WalletDetailSuccessPage(
                            docId: _notification.id,
                          ),
                        ),
                      );
                      break;
                    case NotiType.withdraw:
                      await MyApp.navKey.currentState.push(
                        MaterialPageRoute(
                          builder: (_) => WalletDetailSuccessPage(
                            docId: _notification.id,
                          ),
                        ),
                      );
                      break;
                    case NotiType.meterbill:
                      // String tempId = "7324392739";

                      await MyApp.navKey.currentState.push(
                        MaterialPageRoute(
                          builder: (_) => MeterBillDetailPage(
                            docId: _notification.id,
                          ),
                        ),
                      );
                      break;
                    case NotiType.readMeter:
                      await MyApp.navKey.currentState.push(
                        MaterialPageRoute(
                            builder: (_) => UploadMyReadScreen(
                                  customerId: _notification.id,
                                )),
                      );
                      break;

                    case NotiType.content:
                      await MyApp.navKey.currentState.push(
                        MaterialPageRoute(
                          builder: (_) => ContentNotificationDetailPage(
                              noti: _notification, status: "true"),
                        ),
                      );
                      break;

                    // default:
                    //   await MyApp.navKey.currentState.push(
                    //     MaterialPageRoute(
                    //       builder: (_) =>,
                    //     ),
                    //   );
                    //   break;
                  }
                },
              ),
            ],
            title: Center(
              child: Text(
                // "Confirm",
                Tran.of(context).text("confirm"),
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.details,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  Tran.of(context).text("q_go_to_detail"),
                ),
              ],
            ));
      },
    );
  }
}
