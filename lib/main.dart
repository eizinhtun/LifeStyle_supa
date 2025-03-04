// @dart=2.9
import 'dart:async';
import 'dart:io';
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
import 'package:left_style/models/system_config.dart';
import 'package:left_style/pages/content_notification_detail_page.dart';
import 'package:left_style/pages/login_page.dart';
import 'package:left_style/pages/main_screen.dart';
import 'package:left_style/pages/my_meterBill_detail.dart';
import 'package:left_style/pages/pop_up_ads.dart';
import 'package:left_style/pages/upload_my_read.dart';
import 'package:left_style/pages/user_not_active.dart';
import 'package:left_style/pages/user_profile.dart';
import 'package:left_style/providers/intro_provider.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart' as supa;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'datas/constants.dart';
import 'datas/data_key_name.dart';
import 'localization/localizations_delegate.dart';
import 'localization/translate.dart';
import 'pages/wallet/wallet_detail_success_page.dart';
import 'providers/hotline_provider.dart';
import 'providers/login_provider.dart';

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
  await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );

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
  // runApp(MyAppUpdate1());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => HotlineProvider()),
    ChangeNotifierProvider(create: (_) => IntroProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static final navKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

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

  SystemConfig systemConfig = SystemConfig();
  bool isLoading = false;
  final client = supa.SupabaseClient(supabaseUrl, supabaseKey);
  supa.GotrueSubscription supaSubscription = supa.GotrueSubscription();

  @override
  void initState() {
    super.initState();
    // client.auth.update();
    getAppUpdateLink();
    if (!kIsWeb) {
      registerNotification(context);
      subscriptToPublicChannel();
    }

    getSystemConfig();
  }

  Future<void> getAppUpdateLink() async {
    String link = "";
    var appUpdateLinkRef = FirebaseFirestore.instance.collection(appUpdateLink);
    try {
      await appUpdateLinkRef.get().then((value) {
        value.docs.forEach((result) {
          link = result.data()['url'];
        });

        DatabaseHelper.setData(link, DataKeyValue.updateLink);
      });
    } catch (e) {}
  }

  Future<void> getSystemConfig() async {
    var systemConfigRef =
        FirebaseFirestore.instance.collection(systemConfigCollection);
    try {
      await systemConfigRef.limit(1).get().then((value) {
        value.docs.forEach((result) async {
          systemConfig = SystemConfig.fromJson(result.data());
        });
      });

      DatabaseHelper.setSystemConfigData(context, systemConfig);
    } catch (e) {}
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

  void _showError(dynamic exception) {
    ShowMessageHandler.showMessage(
      MyApp.navKey.currentState.context,
      "Error",
      exception.toString(),
    );
    // MyApp.navKey.currentState.showSnackBar(SnackBar(
    //   backgroundColor: Colors.black38,
    //   content: Text(
    //     exception.toString(),
    //     style: TextStyle(
    //       fontSize: 15,
    //       color: Colors.white,
    //       fontFamily: "Quicksand",
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   duration: Duration(seconds: 3),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      //running on web
    } else {
      if (Platform.isAndroid) {
        Upgrader().clearSavedSettings();
      }
    }

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
        // home: ,
        initialRoute: '/intros',
        routes: {
          '/': (context) {
            // return StreamBuilder<User>(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.active) {
            //       User user = snapshot.data;
            //       if (user == null) {
            //         return LoginPage();
            //         // setState(() {});
            //       }

            //       return StreamBuilder<DocumentSnapshot>(
            //           stream: FirebaseFirestore.instance
            //               .collection(userCollection)
            //               .doc(FirebaseAuth.instance.currentUser.uid)
            //               .snapshots(),
            //           builder: (context, snapshot) {
            //             if (snapshot.connectionState ==
            //                 ConnectionState.active) {
            //               // && snapshot.data.exists
            //               if (snapshot.hasData && snapshot.data.exists) {
            //                 //
            //                 if (snapshot.data["isActive"]) {
            //                   return MainScreen();
            //                   // return _bottomNav(context);

            //                 } else {
            //                   return UserNotActiveScreen();
            //                 }
            //               } else
            //                 return UserProfileScreen();
            //             }
            //             return Center(
            //               child: CircularProgressIndicator(),
            //             );
            //           });
            //     } else {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // );

            // return client.auth.onAuthStateChange((event, session) {
            //   if (event == supa.AuthChangeEvent.signedIn) {
            //     return MainScreen();
            //   } else if (event == supa.AuthChangeEvent.signedOut) {
            //     return LoginPage();
            //   }
            // });

            return StreamBuilder<AuthChangeEvent>(
              stream: SupabaseAuth.instance.onAuthChange,
              builder: (context, AsyncSnapshot<AuthChangeEvent> snapshot) {
                print(
                    'snap shot auth state changed to ${snapshot.data.toString()}');
                if (snapshot.data == AuthChangeEvent.signedIn) {
                  return MainScreen();
                } else {
                  // (snapshot.data == AuthChangeEvent.signedOut)
                  return LoginPage();
                }
              },
            );
          },
          '/intros': (context) => PopupAdsPage(),
          // '/intros': (context) => IntroScreenPage(),
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

    // return ScreenUtilInit(
    //   designSize: Size(360, 690),
    //   builder: () => MaterialApp(
    //     key: key,
    //     navigatorKey: MyApp.navKey,
    //     debugShowCheckedModeBanner: false,
    //     title: 'Unifine',
    //     theme: ThemeData(
    //       primarySwatch: colorCustom,
    //       fontFamily: 'NotoSansMyanmar',
    //     ),
    //     initialRoute: '/intros',
    //     routes: {
    //       '/': (context) {
    //         return isLoading
    //             ? Center(
    //                 child: SpinKitCircle(
    //                   color: Colors.blueGrey.shade900,
    //                   size: 50.0,
    //                 ),
    //               )
    //             : (_updateInfo?.updateAvailability != null &&
    //                     _updateInfo?.updateAvailability ==
    //                         UpdateAvailability.updateAvailable)
    //                 ? Container(
    //                     // decoration: BoxDecoration(
    //                     //   image: DecorationImage(image: AssetImage("assets/images/bg3.jpg"),fit: BoxFit.cover)
    //                     // ),
    //                     child: AlertDialog(
    //                       backgroundColor: Colors.blueGrey.shade900,
    //                       title: Text(
    //                         "New Update Available! Please Update",
    //                         style: TextStyle(
    //                             fontFamily: "Quicksand",
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white),
    //                       ),
    //                       actions: [
    //                         TextButton(
    //                             onPressed: (_updateInfo?.updateAvailability !=
    //                                         null &&
    //                                     _updateInfo?.updateAvailability ==
    //                                         UpdateAvailability
    //                                             .updateAvailable)
    //                                 ? () {
    //                                     InAppUpdate.performImmediateUpdate()
    //                                         .catchError((e) => _showError(e));
    //                                   }
    //                                 : null,
    //                             child: Text(
    //                               "Update",
    //                               style: TextStyle(
    //                                   fontFamily: "Quicksand",
    //                                   fontWeight: FontWeight.bold,
    //                                   color: Colors.white),
    //                             ))
    //                       ],
    //                     ),
    //                   )
    //                 : StreamBuilder<User>(
    //                     stream: FirebaseAuth.instance.authStateChanges(),
    //                     builder: (context, snapshot) {
    //                       if (snapshot.connectionState ==
    //                           ConnectionState.active) {
    //                         User user = snapshot.data;
    //                         if (user == null) {
    //                           return LoginPage();
    //                           // setState(() {});
    //                         }

    //                         return StreamBuilder<DocumentSnapshot>(
    //                             stream: FirebaseFirestore.instance
    //                                 .collection(userCollection)
    //                                 .doc(
    //                                     FirebaseAuth.instance.currentUser.uid)
    //                                 .snapshots(),
    //                             builder: (context, snapshot) {
    //                               if (snapshot.connectionState ==
    //                                   ConnectionState.active) {
    //                                 // && snapshot.data.exists
    //                                 if (snapshot.hasData &&
    //                                     snapshot.data.exists) {
    //                                   //
    //                                   if (snapshot.data["isActive"]) {
    //                                     return MainScreen();
    //                                     // return _bottomNav(context);

    //                                   } else {
    //                                     return UserNotActiveScreen();
    //                                   }
    //                                 } else
    //                                   return UserProfileScreen();
    //                               }
    //                               return Center(
    //                                 child: CircularProgressIndicator(),
    //                               );
    //                             });
    //                       } else {
    //                         return Center(
    //                           child: CircularProgressIndicator(),
    //                         );
    //                       }
    //                     },
    //                   );
    //       },
    //       '/intros': (context) => PopupAdsPage(),
    //       // '/intros': (context) => IntroScreenPage(),
    //     },
    //     supportedLocales: [
    //       const Locale('zh', 'CN'),
    //       const Locale('en', 'US'),
    //       const Locale('my', 'MM'),
    //     ],
    //     localizationsDelegates: [
    //       const MyLocalizationsDelegate(),
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate
    //     ],
    //   ),
    // );
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

      // await MyApp.navKey.currentState.push(
      //   MaterialPageRoute(
      //     builder: (_) =>
      //         NotificationDetailPage(noti: _notification, status: "false"),
      //   ),
      // );
      // if (SystemData.isLoggedIn) {
      //   setState(() {
      //     SystemData.notiCount = SystemData.notiCount + 1;
      //     context
      //         .read<NotiProvider>()
      //         .updateNotiCount(context, SystemData.notiCount);
      //   });
      // }
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
      // if (SystemData.isLoggedIn) {
      //   SystemData.notiCount = SystemData.notiCount + 1;
      //   context
      //       .read<NotiProvider>()
      //       .updateNotiCount(context, SystemData.notiCount);
      // }
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

      // if (SystemData.isLoggedIn) {
      //   setState(() {
      //     SystemData.notiCount = SystemData.notiCount + 1;
      //     context
      //         .read<NotiProvider>()
      //         .updateNotiCount(context, SystemData.notiCount);
      //   });
      // }
    });
  }

  Future<void> _showAlertDialog(BuildContext context, NotiModel _notification) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
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
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _notification.title,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: null,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 4, 0),
                            child: Icon(
                              Icons.warning,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: _notification.body,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
