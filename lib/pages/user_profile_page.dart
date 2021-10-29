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
  final UserModel user;

  const EditUserProfilePage({
    Key key,
    this.user,
  }) : super(key: key);
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  var newImage;
  String photoUrl;
  TextEditingController _nameController;
  TextEditingController _addressController;
  FocusNode nameFocusNode;
  FocusNode addressFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _addressController = TextEditingController(text: widget.user.address);
    photoUrl = widget.user.photoUrl;
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
                      iconTheme: IconThemeData(color: Colors.white),
                      backgroundColor: Theme.of(context).primaryColor,
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
                    SliverFillRemaining(
                      child: Container(
                          margin: EdgeInsets.only(top: 70),
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
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
                                    labelText: "Name",
                                    labelStyle: TextStyle(),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
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
                                        context, val, '');
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Address",
                                    labelStyle: TextStyle(),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {});
                                        },
                                        child: Text("Cancel"),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              String imgUrl =
                                                  widget.user.photoUrl;
                                              if (newImage != null) {
                                                imgUrl = await Authentication
                                                    .uploadphotofile(newImage);
                                              }
                                              widget.user.photoUrl = imgUrl;
                                              widget.user.address =
                                                  _addressController.text
                                                      .toString();
                                              widget.user.fullName =
                                                  _nameController.text
                                                      .toString();

                                              print(widget.user.toJson());
                                              await context
                                                  .read<LoginProvider>()
                                                  .updateUserInfo(
                                                      context, widget.user);

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MePage()));
                                            }
                                          },
                                          child: Text("Save")),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
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
                                  name: widget.user.fullName
                                      .substring(0, 1)
                                      .toUpperCase(),
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
                                color: Theme.of(context).primaryColor,
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
          backgroundColor: Colors.green,
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
    // style: ButtonStyle(
    //                                       padding: MaterialStateProperty
    //                                           .all<EdgeInsets>(EdgeInsets.only(
    //                                               top: 10, bottom: 10)),
    //                                       backgroundColor:
    //                                           MaterialStateProperty.all(
    //                                         Colors.blue,
    //                                       ),
    //                                       shape: MaterialStateProperty.all(
    //                                         RoundedRectangleBorder(
    //                                           borderRadius:
    //                                               BorderRadius.circular(50),
    //                                         ),
    //                                       ),
    //                                     ),