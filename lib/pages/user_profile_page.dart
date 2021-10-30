// @dart=2.9
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/me_page.dart';
import 'package:left_style/utils/authentication.dart';
import 'package:left_style/validators/validator.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/login_provider.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
    nameFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
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
                  SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.only(top: 70),
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                child: Center(
                                  child: InkWell(
                                    onLongPress: () {
                                      _showAlertDialog(context);
                                    },
                                    child: RepaintBoundary(
                                      key: _globalKey,
                                      child: QrImage(
                                        data: widget.user.uid,
                                        version: QrVersions.auto,
                                        gapless: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                                      color: Colors.black12,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
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
                                      color: Colors.black12,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
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
                                      child: Container(
                                          padding: EdgeInsets.all(12),
                                          child: Text("Cancel")),
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
                                                _nameController.text.toString();

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
                                        child: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Text("Save"))),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: Center(child: new Text("Do you want to save QR image?")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                    // setState(() {});
                    _saveQrImage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: Color(0xff000000),
        emptyColor: Color(0xffffffff),
      ).toImage(300);
      final a = await image.toByteData(format: ui.ImageByteFormat.png);
      return a.buffer.asUint8List();
    } catch (e) {
      throw e;
    }
  }

  String saveBtnText = 'Save QR Image';
  final GlobalKey _globalKey = GlobalKey();
  Future<void> _saveQrImage() async {
    setState(() {
      saveBtnText = 'saving in progress...';
    });
    try {
      //extract bytes
      final RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      //create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile.path);

      await GallerySaver.saveImage(capturedFile.path).then((value) {
        setState(() {
          saveBtnText = 'screenshot saved!';
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _saveNetworkImage() async {
    String path =
        'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path).then((bool success) {
      setState(() {
        print('Image is saved');
      });
    });
  }

  _showImageCircle() => Container(
        height: 120,
        width: 120,
        child: CircleAvatar(
          backgroundColor: Colors.pink[300],
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
