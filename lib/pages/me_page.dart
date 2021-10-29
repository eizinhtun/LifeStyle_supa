// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/language_page.dart';
import 'package:left_style/pages/setting.dart';
import 'package:left_style/pages/user_profile_page.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import 'change_password.dart';
import 'help.dart';
import 'login.dart';
import 'meter_list.dart';
import 'notification_list.dart';

class MePage extends StatefulWidget {
  const MePage({Key key}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  UserModel user = UserModel();
  bool _isSigningOut = false;
  String url = "";

  Route _routeToLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String fullName;
  String photoUrl;
  String address;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<UserModel> getUser() async {
    user = await context.read<LoginProvider>().getUser(context);
    return user;
  }

  double titleHeight = 50;
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
                    InkWell(
                      onTap: () {
                        fullName = user.fullName.toString();
                        photoUrl = user.photoUrl.toString();
                        address = user.address.toString();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditUserProfilePage(
                                  user: user,
                                )));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // CircleAvatar(
                                  //   radius: 40,
                                  //   backgroundImage: AssetImage(
                                  //       "assets/image/user-photo.png"),
                                  // ),
                                  UserInfoScreenPhoto(
                                    name: user.fullName
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    imageurl: user.photoUrl,
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    width: 20,
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
                                            "${user.fullName}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "Balance : ${user.balance.toString()} Ks",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.qr_code,
                            )
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
                        onTap: () {
                          fullName = user.fullName.toString();
                          photoUrl = user.photoUrl.toString();
                          address = user.address.toString();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditUserProfilePage(
                                    user: user,
                                  )));
                        },
                        leading: Icon(
                          Icons.person,
                          color: mainColor,
                        ),
                        title: Text(
                          "My Account",
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangePasswordPage()));
                        },
                        leading: Icon(
                          Icons.password,
                          color: mainColor,
                        ),
                        title: Text(
                          "Change Password",
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
                        },
                        leading: Container(
                          width: 50,
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: mainColor,
                              ),
                              (SystemData.notiCount != null &&
                                      SystemData.notiCount > 0)
                                  ? Positioned(
                                      top: 0,
                                      left: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.pink[100],
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              getNotiCount(
                                                  SystemData.notiCount),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // child: Text("2"),
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
                          "Notifications",
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
                        leading: Icon(
                          Icons.list,
                          color: mainColor,
                        ),
                        title: Text(
                          "Meter List",
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
                              builder: (context) => LanguagePage()));
                        },
                        leading: Icon(
                          Icons.language,
                          color: mainColor,
                        ),
                        title: Text(
                          "Select Language",
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
                        leading: Icon(
                          Icons.settings,
                          color: mainColor,
                        ),
                        title: Text(
                          "Setting",
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
                        leading: Icon(
                          Icons.help,
                          color: mainColor,
                        ),
                        title: Text(
                          "Help",
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
                            "Log Out",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          onPressed: () {
                            Widget continueButton = TextButton(
                              child: Text("Confirm"),
                              onPressed: () async {
                                setState(() {
                                  _isSigningOut = true;
                                });
                                await context
                                    .read<LoginProvider>()
                                    .logOut(context);
                                setState(() {
                                  _isSigningOut = false;
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              },
                            );
                            Widget cancelButton = TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                setState(() {});
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => super.widget));
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

  showLogoutConfirmDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () async {
        setState(() {
          _isSigningOut = true;
        });
        await context.read<LoginProvider>().logOut(context);
        setState(() {
          _isSigningOut = false;
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        setState(() {});
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => super.widget));
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
  }
}
