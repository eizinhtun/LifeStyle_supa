// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page_detail_design.dart';
import 'login.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser?.uid != null
        // ? HomePage()
        //? HomePageDetail()
        ? BottomNavBar()
        : LoginPage();
  }
}
