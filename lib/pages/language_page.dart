// @dart=2.9

import 'package:flutter/material.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/providers/language_provider.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  double height = 50;
  String lang = "en";

  @override
  void initState() {
    getLang();
    super.initState();
  }

  void getLang() async {
    lang = await DatabaseHelper.getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Language"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView(
          children: [
            Container(
              height: height,
              child: ListTile(
                onTap: () async {
                  await context
                      .read<LanguageProvider>()
                      .changeLang(context, "my")
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                title: Text(
                  "မြန်မာ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
            Container(
              height: height,
              child: ListTile(
                onTap: () async {
                  await context
                      .read<LanguageProvider>()
                      .changeLang(context, "en")
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                title: Text(
                  "English",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
            Container(
              height: height,
              child: ListTile(
                onTap: () async {
                  await context
                      .read<LanguageProvider>()
                      .changeLang(context, "zh")
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                title: Text(
                  "中文",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
