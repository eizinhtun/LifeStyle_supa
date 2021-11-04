// @dart=2.9
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/setting.dart';
import 'package:left_style/pages/text_from_image.dart';
import 'package:left_style/pages/user_profile_edit.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import 'change_pin_phone.dart';
import 'help.dart';
import 'language_page_test.dart';
import 'meter_list.dart';
import 'notification_list.dart';

class MePage extends StatefulWidget {
  const MePage({Key key}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final db = FirebaseFirestore.instance;
  UserModel user = UserModel();
  bool _isSigningOut = false;
  String url = "";
  @override
  void initState() {
    super.initState();
    getUser();
    getData();
  }

  List<NotiModel> notiList = [];
  getData() async {
    notiList = await context.read<NotiProvider>().getNotiList(context);
    if (notiList != null && notiList.length > 0) {
      SystemData.notiCount = notiList.where((e) => e.status == false).length;
    } else {
      SystemData.notiCount = 0;
    }
    context.read<NotiProvider>().updateNotiCount(context, SystemData.notiCount);
    setState(() {});
  }

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

  String fullName;
  String photoUrl;
  String address;

  Future<UserModel> getUser() async {
    user = await context.read<LoginProvider>().getUser(context);
    return user;
  }

  double titleHeight = 50;
  double leadingWidth = 50;
  double iconSize = 30;
  @override
  Widget build(BuildContext context) {
    print("_isSigningOut : $_isSigningOut");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else {
              user = snapshot.data;
              print(snapshot.data);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListView(
                  children: [
                    StreamBuilder(
                      stream: db
                          .collection(userCollection)
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          UserModel _user =
                              UserModel.fromJson(snapshot.data.data());
                          return InkWell(
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        UserInfoScreenPhoto(
                                          name: _user.fullName
                                              .substring(0, 1)
                                              .toUpperCase(),
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
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                          );
                        } else {
                          return Text("No data found");
                        }
                      },
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     fullName = user.fullName.toString();
                    //     photoUrl = user.photoUrl.toString();
                    //     address = user.address.toString();
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => EditUserProfilePage(
                    //           user: user,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   child: Container(
                    //     padding:
                    //         EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Flexible(
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: <Widget>[
                    //               // CircleAvatar(
                    //               //   radius: 40,
                    //               //   backgroundImage: AssetImage(
                    //               //       "assets/image/user-photo.png"),
                    //               // ),
                    //               UserInfoScreenPhoto(
                    //                 name: user.fullName
                    //                     .substring(0, 1)
                    //                     .toUpperCase(),
                    //                 imageurl: user.photoUrl,
                    //                 width: 80,
                    //                 height: 80,
                    //               ),
                    //               SizedBox(
                    //                 width: 20,
                    //               ),
                    //               Container(
                    //                 child: Expanded(
                    //                   child: Column(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       SizedBox(
                    //                         height: 20,
                    //                       ),
                    //                       Text(
                    //                         "${user.fullName}",
                    //                         style: TextStyle(
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                       Text(
                    //                           "Balance : ${user.balance.toString()} Ks",
                    //                           style: TextStyle(
                    //                               fontSize: 16,
                    //                               fontWeight: FontWeight.bold)),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(right: 8.0),
                    //           child: Icon(
                    //             Icons.qr_code,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Divider(
                      thickness: 0.5,
                      height: 1,
                    ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () async {
                          fullName = user.fullName.toString();
                          photoUrl = user.photoUrl.toString();
                          address = user.address.toString();
                          var result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => EditUserProfilePage(
                                        user: user,
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          // FirebaseAuth.instance.
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TextFromImage()));
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
                          "Text From Image",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                              builder: (context) => NotificationListPage()));
                          setState(() {});
                        },
                        leading: Container(
                          width: leadingWidth,
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                size: iconSize,
                                color: mainColor,
                              ),
                              (SystemData.notiCount != null &&
                                      SystemData.notiCount > 0)
                                  ? Container(
                                      width: iconSize,
                                      height: iconSize,
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: iconSize / 2,
                                        height: iconSize / 2,
                                        alignment: Alignment.center,
                                        // padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          color: Colors.red,
                                        ),
                                        child: Text(
                                          getNotiCount(SystemData.notiCount),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(""),
                            ],
                          ),
                        ),
                        // leading: Icon(
                        //   Icons.notifications,
                        //   color: mainColor,
                        // ),
                        title: Text(
                          Tran.of(context).text("notification"),
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    // Container(
                    //   height: titleHeight,
                    //   child: ListTile(
                    //     onTap: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => LanguagePage()));
                    //     },
                    //     leading: Container(
                    //       width: leadingWidth,
                    //       alignment: Alignment.centerLeft,
                    //       child: Icon(
                    //         Icons.language,
                    //         size: iconSize,
                    //         color: mainColor,
                    //       ),
                    //     ),
                    //     title: Text(
                    //       Tran.of(context).text("languagePage"),
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: titleHeight,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LanguagePageTest()));
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
                          Tran.of(context).text("languagePage"),
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          onPressed: () {
                            Widget continueButton = TextButton(
                              child: Text("Confirm"),
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
                              child: Text("Cancel"),
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
                                "Are you sure logout?",
                                style: TextStyle(fontSize: 20),
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
          },
        ),
      ),
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
  //       style: TextStyle(fontSize: 20),
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
