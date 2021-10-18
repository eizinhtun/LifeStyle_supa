// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/validators/validator.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var _newImage;
  UserModel user=UserModel();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: Container(),
                      ),
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
                              margin: EdgeInsets.only(top: 50),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Text(
                                  //   "${user.fullName}",
                                  //   style: TextStyle(
                                  //     color: Colors.black,
                                  //     fontWeight: FontWeight.w800,
                                  //     fontSize: 30,
                                  //   ),
                                  // ),
                                  TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _nameController,
                                      keyboardType: TextInputType.text,
                                      validator: (val) {
                                        return Validator.requiredField(
                                            context, user.fullName, '');
                                      },
                                     decoration: InputDecoration(
                                       filled: true,
                                       contentPadding:
                                       EdgeInsets.fromLTRB(20, 0, 0, 0),
                                       hintText: user.fullName,
                                       disabledBorder: OutlineInputBorder(
                                         borderSide: BorderSide(
                                             color: Colors.grey, width: 0.5),
                                         borderRadius: BorderRadius.circular(40.0),
                                       ),
                                     ),
                                    ),
                                  SizedBox(height: 20,),
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _addressController,
                                    keyboardType: TextInputType.text,
                                    validator: (val) {
                                      return Validator.requiredField(
                                          context, user.address, '');
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding:
                                      EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      hintText: user.address,
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Expanded(child: ElevatedButton(
                                          style: ButtonStyle(
                                            padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.only(
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
                                            setState(() {});
                                          },
                                          child: Text("Cancel")),),
                                      SizedBox(width: 10),
                                      Expanded(child: ElevatedButton(
                                          style: ButtonStyle(
                                            padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.only(
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
                                            await Authentication.uploadphotofile(_newImage);
                                            setState(() {});
                                          },
                                          child: Text("Save")),)
                                    ],
                                  ),
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
                    child: Stack(
                      children: [
                        _newImage != null?Container(
                          height: 120,
                          width: 120,
                          child: CircleAvatar(
                            backgroundImage: Image.file(File(_newImage)).image,
                            radius: 50,
                          ),
                        )
                        :UserInfoScreenPhoto(
                          imageurl: user.photoUrl,
                         ),
                        Positioned(
                            top: 80,
                            left: 80,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.blue,
                                // border: Border.all(
                                //   color: Colors.white,
                                //   width: 2,
                                // )
                              ),
                              child: IconButton(onPressed: (){
                                showImage();
                                setState(() {

                                });
                              },
                                  icon: Icon(Icons.photo_camera,size: 20,color: Colors.white,)),
                            ),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  Future<String> showImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _newImage = pickedFile;
    });
  }

}
