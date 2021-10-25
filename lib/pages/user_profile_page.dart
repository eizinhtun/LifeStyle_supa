// @dart=2.9
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/me_page.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/validators/validator.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class EditUserProfilePage extends StatefulWidget {
  final String fullName;
  final String photoUrl;
  final String address;
  const EditUserProfilePage(this.fullName, this.photoUrl, this.address,
      {Key key})
      : super(key: key);
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState(
      fullName: this.fullName, photoUrl: this.photoUrl, address: this.address);
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  var newImage;
  UserModel user = UserModel();
  TextEditingController _nameController;
  TextEditingController _addressController;
  FocusNode nameFocusNode;
  FocusNode addressFocusNode;
  final String fullName, photoUrl, address;
  _EditUserProfilePageState({this.fullName, this.photoUrl, this.address});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUser();
    _nameController = TextEditingController(text: fullName);
    _addressController = TextEditingController(text: address);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }
  // Future<UserModel> getUser() async {
  //   user= await context.read<LoginProvider>().getUser(context);
  //   _nameController = TextEditingController(text: user.fullName);
  //   _addressController = TextEditingController(text: user.address);
  // }

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
                            height: MediaQuery.of(context).size.height,
                          ),
                          child: Container(
                              margin: EdgeInsets.only(top: 50),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  TextFormField(
                                    autofocus: false,
                                    focusNode: nameFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    validator: (val) {
                                      return Validator.requiredField(
                                          context, val, '');
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    focusNode: addressFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _addressController,
                                    keyboardType: TextInputType.text,
                                    validator: (val) {
                                      return Validator.requiredField(
                                          context, address, '');
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsets>(
                                                      EdgeInsets.only(
                                                          top: 10, bottom: 10)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.blue,
                                              ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() {});
                                            },
                                            child: Text("Cancel")),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsets>(
                                                      EdgeInsets.only(
                                                          top: 10, bottom: 10)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.blue,
                                              ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              var imgUrl = await Authentication
                                                  .uploadphotofile(newImage);
                                              if (imgUrl != null) {
                                                user.photoUrl = imgUrl;
                                                user.fullName = _nameController
                                                    .text
                                                    .toString();
                                                user.address =
                                                    _addressController.text
                                                        .toString();

                                                //UserModel();
                                                await context
                                                    .read<LoginProvider>()
                                                    .updateUserInfo(
                                                        context, user);
                                              }

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MePage()));

                                              setState(() async {});
                                            },
                                            child: Text("Save")),
                                      )
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
                          newImage != null
                              ? _showImageCircle()
                              : UserInfoScreenPhoto(
                                  imageurl: photoUrl,
                                  width: 120,
                                  height: 120,
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
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    showImage();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.photo_camera,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  _showImageCircle() => Container(
        height: 120,
        width: 120,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: Image.file(File(newImage.path)).image,
          radius: 50,
        ),
      );

  Future<String> showImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      newImage = image;
    });
  }
}
