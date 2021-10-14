// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/pages/login.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:left_style/widgets/wallet.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class UserInfoScreen extends StatefulWidget {
  // UserInfoScreen({Key key, User user})
  //     : _user = user,
  //       super(key: key);
  //
  // User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  User _user;
  bool _isSigningOut = false;
  String url = "";

  Route _routeToSignInScreen() {
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

  @override
  void initState() {
    url = _user.photoURL.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Colors.black),
                    backgroundColor: Colors.blue,
                    pinned: true,
                    snap: false,
                    floating: false,
                    expandedHeight: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.vertical(
                        bottom: new Radius.elliptical(200, 56.0),
                      ),
                    ),
                    // shape: ContinuousRectangleBorder(
                    //     borderRadius: BorderRadius.only(
                    //         bottomLeft: Radius.circular(500), bottomRight: Radius.circular(500)
                    //     )),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(),
                    ),
                    actions: [
                      _isSigningOut
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              tooltip: 'Sign Out',
                              onPressed: () async {
                                setState(() {
                                  _isSigningOut = true;
                                });
                                await context
                                    .read<LoginProvider>()
                                    .logOut(context);
                                // await Authentication.signOut(context: context);
                                setState(() {
                                  _isSigningOut = false;
                                });
                                Navigator.of(context)
                                    .pushReplacement(_routeToSignInScreen());
                              },
                            ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height,
                        ),
                        child: Container(
                            child: Column(
                          children: [
                            SizedBox(height: 80.0),
                            Text(
                              _user.displayName,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            // Text(
                            //   ' ${_user.email!}',
                            //   style: TextStyle(
                            //     color: CustomColors.firebaseOrange,
                            //     fontSize: 16,
                            //     letterSpacing: 0.5,
                            //   ),
                            // ),
                            SizedBox(height: 24.0),
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.only(
                                              left: 100,
                                              right: 100,
                                              top: 10,
                                              bottom: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.blue,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  url = await Authentication
                                      .uploadphotofilecamera();

                                  setState(() {});
                                },
                                child: Text("Take a Photo")),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.only(
                                              left: 76,
                                              right: 76,
                                              top: 10,
                                              bottom: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.blue,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  url = await Authentication.uploadphotofile();
                                  //url=await Authentication.updatePhoto();
                                  setState(() {});
                                },
                                child: Text("Choose From Album")),
                            //text wallet page
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Wallet()));
                                },
                                child: Text("Wallet")),
                          ],
                        ))),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 70),
                  height: 120,
                  width: 120,
                  child: url != null
                      ? UserInfoScreenPhoto(
                          imageurl: url.toString(),
                          width: 80,
                          height: 80,
                          borderColor: Colors.white,
                        )
                      : Text('No user'),
                ),
              ),
            ],
          ),
        ));
  }
}
