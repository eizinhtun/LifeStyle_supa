// @dart=2.9
// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/main_screen.dart';
import 'package:left_style/pages/setting.dart';
import 'package:left_style/pages/user_profile_edit.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import 'change_pin_phone_page.dart';
import 'help_page.dart';
import 'language_page.dart';
import 'meter_list.dart';

class MePage extends StatefulWidget {
  final MainScreenState main;
  const MePage({Key key, this.main}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  bool _isSigningOut = false;
  String url = "";
  @override
  void initState() {
    super.initState();
    // getData();
  }

  List<NotiModel> notiList = [];
  // getData() async {
  //   notiList = await context.read<NotiProvider>().getNotiList(context);
  //   if (notiList != null && notiList.length > 0) {
  //     SystemData.notiCount = notiList.where((e) => e.status == false).length;
  //   } else {
  //     SystemData.notiCount = 0;
  //   }
  //   context.read<NotiProvider>().updateNotiCount(context, SystemData.notiCount);
  //   setState(() {});
  // }

  // Route _routeToLogin() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = Offset(-1.0, 0.0);
  //       var end = Offset.zero;
  //       var curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  double titleHeight = 50;
  double leadingWidth = 50;
  double iconSize = 30;
  String initialName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(userCollection)
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (snapshot.hasData) {
              UserModel _user = UserModel.fromJson(snapshot.data.data());
              if (_user.fullName != null && _user.fullName == "") {
                initialName = _user.fullName.substring(0, 1).toUpperCase();
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListView(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditUserProfilePage(
                              user: _user,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  UserInfoScreenPhoto(
                                    name: initialName,
                                    imageurl: _user.photoUrl,
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "${_user.fullName}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              Tran.of(context)
                                                  .text("balance")
                                                  .replaceAll("@amount",
                                                      " ${_user.showBalance ? Formatter.balanceFormat(_user.balance) : Formatter.balanceFormat(_user.balance)}")
                                                  .replaceAll(
                                                      "@balanceKs",
                                                      Tran.of(context)
                                                          .text("ks")),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.qr_code,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () async {
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => EditUserProfilePage(
                                        user: _user,
                                      )));
                          if (result != null && result == true) {
                            setState(() {});
                          }
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.person,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("myAccount"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () {
                          // FirebaseAuth.instance.
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangePinPhonePage()));
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.lock,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("changePin"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MeterListPage()));
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.list,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("meterList"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () async {
                          bool result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => LanguagePage()));
                          widget.main.refreshPage();
                          setState(() {});
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.language,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("language"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingPage()));
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.settings,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("setting"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HelpPage()));
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.help,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("needHelp"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () async {},
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.update,
                            size: iconSize,
                            color: mainColor,
                          ),
                        ),
                        title: Text(
                          Tran.of(context).text("app_version") + " " + version,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.0,
                              color: mainColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text(
                            Tran.of(context).text("logout"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          onPressed: () {
                            Widget continueButton = TextButton(
                              child: Text(
                                Tran.of(context).text("confirm"),
                              ),
                              onPressed: () async {
                                // setState(() {
                                //   _isSigningOut = true;
                                // });
                                await context
                                    .read<LoginProvider>()
                                    .logOut(context);
                                Navigator.pop(context);
                                // setState(() {
                                //   _isSigningOut = false;
                                // });
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => LoginPage()));
                              },
                            );
                            Widget cancelButton = TextButton(
                              child: Text(
                                Tran.of(context).text("cancel"),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                // setState(() {});
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => super.widget));
                              },
                            );
                            AlertDialog alert = AlertDialog(
                              title: Text(
                                Tran.of(context).text("logout_confirm"),
                                style: const TextStyle(fontSize: 20),
                              ),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  String getNotiCount(int count) {
    if (count > 99)
      return "99+";
    else if (count == null || count == "")
      return "";
    else
      return count.toString();
  }

  // showLogoutConfirmDialog(BuildContext context) {
  //   Widget continueButton = TextButton(
  //     child: Text("Confirm"),
  //     onPressed: () async {
  //       setState(() {
  //         _isSigningOut = true;
  //       });
  //       await context.read<LoginProvider>().logOut(context);
  //       setState(() {
  //         _isSigningOut = false;
  //       });
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => LoginPage()));
  //     },
  //   );
  //   Widget cancelButton = TextButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       setState(() {});
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => super.widget));
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     title: Text(
  //       "Are you sure logout?",
  //       style: const TextStyle(fontSize: 20),
  //     ),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

}
