import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:left_style/pages/firebase_verify_pin_page.dart';
import 'package:left_style/pages/home_screen.dart';
import 'package:left_style/pages/login.dart';
import 'package:left_style/pages/otp_auto_fill.dart';
import 'package:left_style/pages/verify_pin_page.dart';
import 'package:left_style/pages/phone_number_page.dart';
import 'package:left_style/pages/sign_in_screen.dart';
import 'package:left_style/pages/upload_images.dart';
import 'package:left_style/splash.dart';

import 'Test/auth_login.dart';
import 'package:left_style/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'datas/constants.dart';
import 'localization/LocalizationsDelegate.dart';

void main() async {
  //firebase messaging
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
  runApp(MyApp());
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash());
        } else {
          return MaterialApp(
              title: 'Unifine',
              theme: ThemeData(
                primarySwatch: colorCustom,
              ),
              //home: MyHomePage(title: 'EPC Home Page'),
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

              home: LoginPage()
              // FirebaseVerifyPinPage(),
              // OTPFill()
              //home: SignInScreen(),
              //home: AuthLogin(),
              // PhoneNumberPage(),
              //home: UploadImageFirebase(),
              );

//           if (FirebaseAuth.instance.currentUser?.uid == null) {
// // not logged
//             // Loading is done, return the app:
//             return MaterialApp(
//                 title: 'Unifine',
//                 theme: ThemeData(
//                   primarySwatch: colorCustom,
//                 ),
//                 //home: MyHomePage(title: 'EPC Home Page'),
//                 supportedLocales: [
//                   ///////const Locale('', ''),
//                   const Locale('zh', 'CN'),
//                   const Locale('en', 'US'),
//                   const Locale('my', 'MM'),
//                 ],
//                 localizationsDelegates: [
//                   const MyLocalizationsDelegate(),
//                   GlobalMaterialLocalizations.delegate,
//                   GlobalWidgetsLocalizations.delegate
//                 ],
//                 //     home:  FutureBuilder<User>(
//                 //   future:FirebaseAuth.instance.currentUser(),
//                 //   //  FirebaseAuth!.instance!.currentUser(),
//                 //   builder: (BuildContext context, AsyncSnapshot<User> snapshot){
//                 //              if (snapshot.hasData){
//                 //                  User user = snapshot.data; // this is your user instance
//                 //                  /// is because there is user already logged
//                 //                  return MainScreen();
//                 //               }
//                 //                /// other way there is no user logged.
//                 //                return LoginScreen();
//                 //    }
//                 // );

//                 home: LoginPage()
//                 // FirebaseVerifyPinPage(),
//                 // OTPFill()
//                 //home: SignInScreen(),
//                 //home: AuthLogin(),
//                 // PhoneNumberPage(),
//                 //home: UploadImageFirebase(),
//                 );
//           } else {
//             return MaterialApp(
//                 title: 'Unifine',
//                 theme: ThemeData(
//                   primarySwatch: colorCustom,
//                 ),
//                 //home: MyHomePage(title: 'EPC Home Page'),
//                 supportedLocales: [
//                   ///////const Locale('', ''),
//                   const Locale('zh', 'CN'),
//                   const Locale('en', 'US'),
//                   const Locale('my', 'MM'),
//                 ],
//                 localizationsDelegates: [
//                   const MyLocalizationsDelegate(),
//                   GlobalMaterialLocalizations.delegate,
//                   GlobalWidgetsLocalizations.delegate
//                 ],
//                 //     home:  FutureBuilder<User>(
//                 //   future:FirebaseAuth.instance.currentUser(),
//                 //   //  FirebaseAuth!.instance!.currentUser(),
//                 //   builder: (BuildContext context, AsyncSnapshot<User> snapshot){
//                 //              if (snapshot.hasData){
//                 //                  User user = snapshot.data; // this is your user instance
//                 //                  /// is because there is user already logged
//                 //                  return MainScreen();
//                 //               }
//                 //                /// other way there is no user logged.
//                 //                return LoginScreen();
//                 //    }
//                 // );

//                 home: HomeScreen()
//                 // FirebaseVerifyPinPage(),
//                 // OTPFill()
//                 //home: SignInScreen(),
//                 //home: AuthLogin(),
//                 // PhoneNumberPage(),
//                 //home: UploadImageFirebase(),
//                 );

//           }
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    messaging.getToken().then((token) {
      print(token);
    });
    //messaging.subscribeToTopic('pyae');
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            ElevatedButton(
                onPressed: () {
                  createUser();
                },
                child: Text("store")),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void createUser() async {
    FirebaseFirestore.instance.collection(userCollection).doc('p1').set({
      'title': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });
  }
}
