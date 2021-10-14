// @dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/pages/sign_in_screen.dart';
import 'package:left_style/pages/upload_images.dart';
import 'package:left_style/res/custom_colors.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/widgets/CommonExampleRouteWrapper.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({Key key, User user})
      : _user = user,
        super(key: key);

   User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {

  User _user;
  bool _isSigningOut = false;
  String url="";
  File _image;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
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
    _user = widget._user;
    url=_user.photoURL.toString();
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
                   child: Container(

                   ),
                 ),
                 actions: [
                   _isSigningOut
                       ? CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                   )
                       :IconButton(icon: Icon(Icons.logout,color: Colors.white,),
                            tooltip: 'Sign Out',
                            onPressed: () async {
                            setState(() {
                            _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
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
                           SizedBox(height: 60.0),
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
                                 padding: MaterialStateProperty.all<EdgeInsets>(
                                     EdgeInsets.only(left: 100,right: 100,top: 10, bottom: 10)),
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
                                 url= await Authentication.uploadphotofilecamera();
                                 //url=await Authentication.updatePhoto();
                                 setState(() {

                                 });

                           }, child: Text("Take a Photo")),
                           SizedBox(height: 20,),
                           ElevatedButton(
                               style: ButtonStyle(
                                 padding: MaterialStateProperty.all<EdgeInsets>(
                                     EdgeInsets.only(left: 76,right: 76,top: 10, bottom: 10)),
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
                                url= await Authentication.uploadphotofile();
                                 //url=await Authentication.updatePhoto();
                                     setState(() {

                                     });

                               }, child: Text("Choose From Album")),
                           // SizedBox(height: 16.0),
                           // _isSigningOut
                           //     ? CircularProgressIndicator(
                           //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                           // )
                           //     : ElevatedButton(
                           //
                           //   style: ButtonStyle(
                           //     padding: MaterialStateProperty.all<EdgeInsets>(
                           //         EdgeInsets.only(left: 20,right: 20)),
                           //     backgroundColor: MaterialStateProperty.all(
                           //       Colors.blue,
                           //     ),
                           //     shape: MaterialStateProperty.all(
                           //       RoundedRectangleBorder(
                           //         borderRadius: BorderRadius.circular(50),
                           //       ),
                           //     ),
                           //   ),
                           //   onPressed: () async {
                           //     setState(() {
                           //       _isSigningOut = true;
                           //     });
                           //     await Authentication.signOut(context: context);
                           //     setState(() {
                           //       _isSigningOut = false;
                           //     });
                           //     Navigator.of(context)
                           //         .pushReplacement(_routeToSignInScreen());
                           //   },
                           //
                           //
                           //   child: Padding(
                           //     padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                           //     child: Container(
                           //       width: 120,
                           //       child: Row(
                           //         children: [
                           //           Icon(Icons.logout),
                           //           Text(
                           //             'Sign Out',
                           //             style: TextStyle(
                           //               fontSize: 16,
                           //               fontWeight: FontWeight.bold,
                           //               color: Colors.white,
                           //               letterSpacing: 2,
                           //             ),
                           //           ),
                           //         ],
                           //       ),
                           //     ),
                           //   ),
                           // ),
                         ],
                       )
                   )
                 ),


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
                   ?UserInfoScreenPhoto( imageurl: url.toString(),width: 80, height: 80, borderColor: Colors.white,):Text('No user'),
             ),
           ),


           // Positioned(
           //   left: 120,
           //   top: 70,
           //   child: Stack(
           //     children: [
           //       Container(
           //         child: url != null
           //             ?UserInfoScreenPhoto( imageurl: url,width: 80, height: 80, borderColor: Colors.white,):Text('No user'),
           //       ),
           //
           //
           //     ],
           //   ),
           // ),

         ],
       ),
     )

    );
    // return Scaffold(
    //   backgroundColor: CustomColors.firebaseNavy,
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: CustomColors.firebaseNavy,
    //
    //   ),
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.only(
    //         left: 16.0,
    //         right: 16.0,
    //         bottom: 20.0,
    //       ),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Stack(
    //             children: [
    //               Container(
    //                 child: url != null
    //                     ?UserInfoScreenPhoto( imageurl: url,width: 80, height: 80, borderColor: Colors.white,): Text("not photo"),
    //               ),
    //               Positioned(
    //                 top: 50,
    //                 left: 50,
    //                 child: IconButton(
    //                   icon: Icon(Icons.photo_camera,size: 50,color: Colors.white,),
    //                   tooltip: 'Increase volume by 10',
    //                   onPressed: () async {
    //                     url=await Authentication.updatePhoto();
    //                     setState(() {
    //                     });
    //                   },
    //
    //                 ),
    //                 // child: ElevatedButton(
    //                 //   onPressed: () async {
    //                 //     url=await Authentication.updatePhoto();
    //                 //     setState(() {
    //                 //     });
    //                 //   },
    //                 //   child: Icon(Icons.camera,size: 30,),
    //                 //
    //                 //
    //                 // ),
    //               ),
    //
    //
    //
    //
    //
    //             ],
    //           ),
    //
    //           SizedBox(height: 16.0),
    //
    //           SizedBox(height: 8.0),
    //           Text(
    //             _user.displayName!,
    //             style: TextStyle(
    //               color: CustomColors.firebaseYellow,
    //               fontSize: 26,
    //             ),
    //           ),
    //           SizedBox(height: 8.0),
    //           Text(
    //             '( ${_user.email!} )',
    //             style: TextStyle(
    //               color: CustomColors.firebaseOrange,
    //               fontSize: 16,
    //               letterSpacing: 0.5,
    //             ),
    //           ),
    //           SizedBox(height: 24.0),
    //
    //           SizedBox(height: 16.0),
    //           _isSigningOut
    //               ? CircularProgressIndicator(
    //             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //           )
    //               : ElevatedButton(
    //             style: ButtonStyle(
    //               backgroundColor: MaterialStateProperty.all(
    //                 Colors.redAccent,
    //               ),
    //               shape: MaterialStateProperty.all(
    //                 RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //               ),
    //             ),
    //             onPressed: () async {
    //               setState(() {
    //                 _isSigningOut = true;
    //               });
    //               await Authentication.signOut(context: context);
    //               setState(() {
    //                 _isSigningOut = false;
    //               });
    //               Navigator.of(context)
    //                   .pushReplacement(_routeToSignInScreen());
    //             },
    //
    //             child: Padding(
    //               padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               child: Text(
    //                 'Sign Out',
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   letterSpacing: 2,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
// void _uploadCamera() async{
//   final picker = ImagePicker();
//   final pickedFileCamera = await picker.getImage(source: ImageSource. camera);
//   url= await Authentication.updatePhotoFromCamera(pickedFileCamera);
//   setState((){
//
//   });
// }
//   void _uploadGallery() async{
//     final picker = ImagePicker();
//     final pickedFileGallery = await picker.getImage(source: ImageSource. gallery);
//     url= await Authentication.updatePhotoFromGallery(pickedFileGallery);
//     setState((){
//
//     });
//   }





}

