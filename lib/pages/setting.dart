// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/localization/translate.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Tran.of(context).text("setting")),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}
