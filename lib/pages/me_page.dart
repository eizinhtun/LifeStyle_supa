// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/user_profile_page.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import 'login.dart';

class MePage extends StatefulWidget {
  const MePage({Key key}) : super(key: key);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {

  UserModel user=UserModel();
  bool _isSigningOut = false;
  String url = "";
  bool _loading = false;

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
  void initState() {
    super.initState();
    getUser();
  }
  Future<UserModel> getUser() async {
    user= await context.read<LoginProvider>().getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: user.fullName !=null && user.photoUrl != null && user.address !=null ? Stack(
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
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context)
                                .pushReplacement(_routeToLogin());
                          },
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                          constraints: BoxConstraints.expand(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 300),
                             child: Column(
                               children: [
                                 _isSigningOut
                                     ? CircularProgressIndicator(
                                   valueColor:
                                   AlwaysStoppedAnimation<Color>(Colors.white),
                                 )
                                     : Card(
                                       margin: EdgeInsets.only(
                                           top: 10.0, left: 10, right: 10, bottom: 20),
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(10.0),
                                       ),
                                       child: ListTile(
                                         onTap: () async {
                                           await showLogoutConfirmDialog(context);
                                          // await MessageHandel.comfirmLogoutDialg(context);

                                           // if (_confirm != null && _confirm) {
                                           //   await sysData.logout(context);
                                           // }
                                         },
                                         title: new Container(
                                           child: Row(
                                             children: <Widget>[
                                               Expanded(
                                                 child: Row(
                                                   children: <Widget>[
                                                     Image.asset(
                                                       "assets/image/logout.png",
                                                       width: 25,
                                                       height: 25,
                                                     ),
                                                     Container(
                                                         padding: EdgeInsets.only(left: 20.0),
                                                         child: Text(
                                                           "Logout",
                                                           style: TextStyle(
                                                               color: Color(0xFF313131),
                                                               fontSize: 15),
                                                         )),
                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                 ),
                                 // IconButton(
                                 //   icon: Icon(
                                 //     Icons.logout,
                                 //     color: Colors.white,
                                 //   ),
                                 //   tooltip: 'Sign Out',
                                 //   onPressed: () async {
                                 //     setState(() {
                                 //       _isSigningOut = true;
                                 //     });
                                 //     await context
                                 //         .read<LoginProvider>()
                                 //         .logOut(context);
                                 //     setState(() {
                                 //       _isSigningOut = false;
                                 //     });
                                 //     Navigator.of(context)
                                 //         .pushReplacement(_routeToLogin());
                                 //   },
                                 // ),
                                 //

                               ],
                             ),
                          )
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            elevation: 2,
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                       Container(
                                         margin: EdgeInsets.only(top: 20),
                                         child: Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                            UserInfoScreenPhoto(imageurl: user.photoUrl,width: 80,height: 80,),
                                            Text(user.fullName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                            ],
                                         ),
                                       ),
                                       Spacer(),
                                       Container(
                                         margin: EdgeInsets.only(top: 20),
                                         decoration: BoxDecoration(
                                           color: Colors.blue,
                                           shape: BoxShape.circle,
                                           border: Border.all(width: 2.0, color: Colors.white),
                                         ),
                                         child: IconButton(onPressed: (){
                                           fullName=user.fullName.toString();
                                           photoUrl=user.photoUrl.toString();
                                           address=user.address.toString();
                                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditUserProfilePage(fullName,photoUrl,address)));
                                            }, icon: Icon(Icons.edit_outlined,color: Colors.white,size: 25,)
                                         ),
                                       ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(width: 2.0, color: Colors.black12),

                                      ),

                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                                      child: Row(
                                        children: [
                                          Text("Balance",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                          Spacer(),
                                         Text(user.balance.toString()+" Ks",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ):Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            )

          ),
        ));
  }
  showLogoutConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed:  () async{
        setState(() {
          _isSigningOut = true;
        });
        await context
            .read<LoginProvider>()
            .logOut(context);
        setState(() {
          _isSigningOut = false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        setState(() {

        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>super.widget));
        
        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MePage()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure logout?",style: TextStyle(fontSize: 20),),
      //content: Text(""),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
