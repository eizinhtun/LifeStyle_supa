// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:left_style/pages/home_page_detail.dart';
import 'package:left_style/pages/login.dart';
import 'package:left_style/pages/user_not_active.dart';
import 'package:left_style/pages/user_profile.dart';
import 'package:left_style/providers/firebase_crud_provider.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'datas/constants.dart';
import 'localization/LocalizationsDelegate.dart';
import 'providers/login_provider.dart';

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
   // ChangeNotifierProvider(create: (_) => FirebaseCRUDProvider()),
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

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
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
      ),
    );
  }
}
