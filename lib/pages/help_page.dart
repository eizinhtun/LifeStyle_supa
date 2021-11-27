// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/localization/translate.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Tran.of(context).text("help")),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}
