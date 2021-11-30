// @dart=2.9

import 'package:flutter/material.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/translate.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double height = 50;
  String lang = "en";
  String systemLang = "";
  bool _selectedMy = false;
  bool _selectedEn = false;
  bool _selectedZh = false;

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
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Tran.of(context).text("select_language"),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView(
          children: [
            Column(
              children: [
                InkWell(
                  child: Container(
                    //alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                                "assets/language_icon/my_flag.png")),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("မြန်မာ"),
                        ),
                        Spacer(),
                        (SystemData.language == "my" || _selectedMy)
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : Text(""),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await DatabaseHelper.setLanguage(context, "my");
                    setState(() {
                      _selectedMy = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                ),
                InkWell(
                  child: Container(
                    //alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                                "assets/language_icon/en_flag.png")),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("English"),
                        ),
                        Spacer(),
                        (SystemData.language == "en" || _selectedMy)
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : Text(""),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await DatabaseHelper.setLanguage(context, "en");
                    setState(() {
                      _selectedEn = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                ),
                InkWell(
                  child: Container(
                    //alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                                "assets/language_icon/zh_flag.png")),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("中文"),
                        ),
                        Spacer(),
                        (SystemData.language == "zh" || _selectedMy)
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : Text(""),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await DatabaseHelper.setLanguage(context, "zh");
                    setState(() {
                      _selectedZh = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                ),
              ],
            ),
            // Container(
            //   height: height,
            //   child: ListTile(
            //     onTap: () async {
            //       await DatabaseHelper.setLanguage(context, "my");
            //       setState(() {
            //         _selectedMy=true;
            //       });
            //       Navigator.pop(context);
            //
            //     },
            //     title: Text(
            //       "မြန်မာ",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     trailing: (SystemData.language == "my" || _selectedMy)?Icon(Icons.check,color: Colors.green,):null,
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
            //       await DatabaseHelper.setLanguage(context, "en");
            //       setState(() {
            //         _selectedEn=true;
            //       });
            //       Navigator.pop(context);
            //     },
            //     title: Text(
            //       "English",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     trailing:(SystemData.language == "en" || _selectedEn)?Icon(Icons.check,color: Colors.green,):null,
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
            //       setState(() {
            //         _selectedZh=true;
            //       });
            //       Navigator.pop(context);
            //     },
            //     title: Text(
            //       "中文",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     trailing: (SystemData.language == "zh" || _selectedZh)?Icon(Icons.check,color: Colors.green,):null,
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
