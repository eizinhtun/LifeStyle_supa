// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/providers/language_provider.dart';
import 'package:provider/provider.dart';

class LanguagePageTest extends StatefulWidget {
  const LanguagePageTest({Key key}) : super(key: key);

  @override
  LanguagePageTestState createState() => new LanguagePageTestState();
}

class LanguagePageTestState extends State<LanguagePageTest>{
double height = 50;
String lang = "en";
bool isSelected = false;

@override
void initState() {
  super.initState();
  getLang();
}
void getLang() async {
  lang = await DatabaseHelper.getLanguage();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(Tran.of(context).text("languagePage")),
    ),
    body: Container(
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5,top: 5),
            height: height,
            child: ListTile(
              onTap: () async {
                await DatabaseHelper.setLanguage(context, "my");
                Navigator.pop(context);
              },
              title: Container(
                //alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Image.asset("assets/language_icon/my_flag.png"),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text("မြန်မာ"),
                    ),
                  ],
                ),
              ),

            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
          ),
          // Container(
          //   height: height,
          //   child: ListTile(
          //     onTap: () async {
          //       await DatabaseHelper.setLanguage(context, "en");
          //       Navigator.pop(context);
          //
          //     },
          //     title: Container(
          //       //alignment: Alignment.center,
          //       width: MediaQuery.of(context).size.width,
          //       padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
          //       child: Row(
          //         children: [
          //           SizedBox(
          //               width: 50,
          //               height: 50,
          //               child: Image.asset("assets/language_icon/en_flag.png")),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 10.0),
          //             child: Text("English"),
          //           ),
          //         ],
          //       ),
          //     ),
          //
          //   ),
          // ),
          // Divider(
          //   thickness: 1,
          //   height: 1,
          // ),
          // Container(
          //   height: height,
          //   child: ListTile(
          //     onTap: () async {
          //       await DatabaseHelper.setLanguage(context, "zh");
          //       Navigator.pop(context);
          //
          //     },
          //     title: Container(
          //       //alignment: Alignment.center,
          //       width: MediaQuery.of(context).size.width,
          //       padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
          //       child: Row(
          //         children: [
          //           SizedBox(
          //               width: 50,
          //               height: 50,
          //               child: Image.asset("assets/language_icon/zh_flag.png")),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 10.0),
          //             child: Text("中文"),
          //           ),
          //         ],
          //       ),
          //     ),
          //
          //   ),
          // ),
          // Divider(
          //   thickness: 1,
          //   height: 1,
          // ),
        ],
      ),
    ),
  );
}
}