// @dart=2.9
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/utils/validator.dart';
import 'package:left_style/widgets/code_painter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  bool _submiting = false;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isuploadingPicture = false;
  XFile file;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _addressController = TextEditingController(text: widget.user.address);
    photoUrl = widget.user.photoUrl;
  }

  // @override
  // void dispose() {
  //   nameFocusNode.dispose();
  //   addressFocusNode.dispose();
  //   super.dispose();
  // }

  Future<void> updateUser(UserModel model) async {
    UserModel oldUserModel = UserModel();

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      var result = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .get(GetOptions(source: Source.server))
          .then((value) {
        oldUserModel = UserModel.fromJson(value.data());
        return oldUserModel;
      });
      if (result != null) {
        oldUserModel.address = model.address;
        oldUserModel.photoUrl = model.photoUrl;
        oldUserModel.fullName = model.fullName;

        try {
          await FirebaseFirestore.instance
              .collection(userCollection)
              .doc(uid)
              .update(oldUserModel.toJson());
          Navigator.pop(context, true);

          ShowMessageHandler.showMessage(
              context,
              Tran.of(context).text("updated_success"),
              Tran.of(context).text("user_updated_success"));
        } catch (e) {
          ShowMessageHandler.showErrMessage(
              context,
              Tran.of(context).text("update_fail"),
              Tran.of(context).text("user_update_fail"));
          setState(() {
            _submiting = false;
          });
        }
      }
      // try {
      //   await FirebaseFirestore.instance
      //       .collection(userCollection)
      //       .doc(uid)
      //       .set(model.toJson());
      //   Navigator.pop(context, true);
      //   // Navigator.pop(contexts, true);
      //   ShowMessageHandler.showMessage(context, "", "Successfully added");
      // } catch (e) {
      //   ShowMessageHandler.showErrMessage(
      //       context, "fail", "User Update Successfully");
      //   setState(() {
      //     _submiting = false;
      //   });
      // }
    }
  }

  Future<firebase_storage.UploadTask> uploadFile(PickedFile file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }
    var dateTime = DateTime.now();
    var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
    firebase_storage.UploadTask uploadTask;
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile')
        .child(dateFormat.toString() +
            "_" +
            FirebaseAuth.instance.currentUser.uid +
            ".jpg");

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }
  // Future<void> updateUserInfo(BuildContext context, UserModel user) async {
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid.toString();
  //     try {
  //       FirebaseFirestore.instance.collection(userCollection).doc(uid).set(user.toJson()).then((value) {
  //
  //         ShowMessageHandler.showMessage(
  //             context, "Success", "Updating User Info is successful");
  //       });
  //
  //       notifyListeners();
  //     } catch (e) {
  //
  //       ShowMessageHandler.showErrMessage(
  //           context, "Fail", "Updating User Info is fail");
  //     }
  //   }
  //   notifyListeners();
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
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(200, 30
                            // 56.0
                            ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(30),
                      child: Container(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        margin: const EdgeInsets.only(top: 90),
                        padding: const EdgeInsets.all(20),
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
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   padding: const EdgeInsets.all(4),
                              //   child: Center(
                              //     child: _previewImages(),
                              //   ),
                              // ),
                              TextFormField(
                                autofocus: false,
                                focusNode: nameFocusNode,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                validator: (val) {
                                  return Validator.userName(context, val,
                                      Tran.of(context).text("full_name"), true);
                                },
                                decoration: InputDecoration(
                                  labelText: Tran.of(context).text("full_name"),
                                  // contentPadding: const EdgeInsets.all(16),
                                ),
                                // decoration: InputDecoration(
                                //   labelText: "Name",
                                //   labelStyle: const TextStyle(),
                                //   border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //       color: Colors.black12,
                                //     ),
                                //   ),
                                //   focusedBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor),
                                //   ),
                                //   contentPadding: const EdgeInsets.symmetric(
                                //       horizontal: 20, vertical: 12),
                                // ),
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
                                  return Validator.requiredField(context, val,
                                      Tran.of(context).text("address"));
                                },
                                decoration: InputDecoration(
                                  labelText: Tran.of(context).text("address"),
                                  labelStyle: const TextStyle(),
                                  // border: OutlineInputBorder(
                                  //   borderSide: BorderSide(
                                  //     color: Colors.black12,
                                  //   ),
                                  // ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(
                                  //       color: Theme.of(context).primaryColor),
                                  // ),
                                  // contentPadding: const EdgeInsets.symmetric(
                                  //     horizontal: 20, vertical: 12),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        side: BorderSide(
                                          width: 1.0,
                                          color: Theme.of(context).primaryColor,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                              Tran.of(context).text("cancel"))),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  _submiting
                                      ? SpinKitDoubleBounce(
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Expanded(
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                side: BorderSide(
                                                  width: 1.0,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              onPressed: _submiting
                                                  ? null
                                                  : () async {
                                                      // if (file == null) {
                                                      //   ShowMessageHandler.showErrMessage(
                                                      //       context,
                                                      //       Tran.of(context).text(
                                                      //           "pic_required"),
                                                      //       Tran.of(context).text(
                                                      //           "pic_required_str"));
                                                      //   return;
                                                      // }
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        if (file == null) {
                                                          ShowMessageHandler.showErrMessage(
                                                              context,
                                                              Tran.of(context).text(
                                                                  "pic_required"),
                                                              Tran.of(context).text(
                                                                  "pic_required_str"));
                                                          return;
                                                        }
                                                        setState(() {
                                                          _submiting = true;
                                                          if (file != null) {
                                                            _isuploadingPicture =
                                                                true;
                                                          }
                                                        });

                                                        UserModel model =
                                                            UserModel();

                                                        model.fullName =
                                                            _nameController
                                                                .text;
                                                        model.address =
                                                            _addressController
                                                                .text;
                                                        if (file != null) {
                                                          setState(() {
                                                            _isuploadingPicture =
                                                                true;
                                                          });
                                                          firebase_storage
                                                                  .UploadTask
                                                              task =
                                                              await uploadFile(
                                                                  PickedFile(file
                                                                      .path));
                                                          if (task != null) {
                                                            task.whenComplete(
                                                                () async {
                                                              model.photoUrl =
                                                                  await task
                                                                      .snapshot
                                                                      .ref
                                                                      .getDownloadURL();
                                                              setState(() {
                                                                _isuploadingPicture =
                                                                    false;
                                                              });
                                                              updateUser(model);
                                                            });
                                                          }
                                                        }
                                                      }
                                                    },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Text(Tran.of(context)
                                                      .text("save")))),
                                        )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              _previewProfileImages()
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     margin: const EdgeInsets.only(top: 60),
              //     height: 120,
              //     width: 120,
              //     child: Stack(
              //       children: [
              //         newImage != null
              //             ? _showImageCircle()
              //             : UserInfoScreenPhoto(
              //                 name: widget.user.fullName
              //                     .substring(0, 1)
              //                     .toUpperCase(),
              //                 imageurl: photoUrl,
              //                 width: 120,
              //                 height: 120,
              //               ),
              //         Positioned(
              //           top: 80,
              //           left: 80,
              //           child: Container(
              //             width: 40,
              //             height: 40,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(80),
              //               color: Theme.of(context).primaryColor,
              //             ),
              //             child: IconButton(
              //                 onPressed: () {
              //                   showImage();
              //                   setState(() {});
              //                 },
              //                 icon: Icon(
              //                   Icons.photo_camera,
              //                   size: 20,
              //                   color: Colors.white,
              //                 )),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
            actionsPadding: const EdgeInsets.all(10),
            title: Center(
              child: Text(
                Tran.of(context).text("want_save_qr"),
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                    _saveQrImage();
                    Navigator.of(context).pop();
                    ShowMessageHandler.showErrMessage(
                        context,
                        Tran.of(context).text("success"),
                        Tran.of(context).text("qr_save_success"));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      Tran.of(context).text("yes"),
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
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      Tran.of(context).text("no"),
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
  String albumName = 'Media';
  Future<void> _saveQrImage() async {
    setState(() {
      saveBtnText = 'saving in progress...';
    });
    try {
      //extract bytes
      final RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      // final ByteData byteData =
      //     await image.toByteData(format: ui.ImageByteFormat.png);

      // final image = await QrPainter(
      //   data: widget.user.uid,
      //   version: QrVersions.auto,
      //   gapless: false,
      //   color: Color(0xff000000),
      //   emptyColor: Color(0xffffffff),
      // ).toImage(300);

      final byteData = await CodePainter(qrImage: image, margin: 0)
          .toImageData(300, format: ui.ImageByteFormat.png);

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      //create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);

      await GallerySaver.saveImage(capturedFile.path, albumName: albumName)
          .then((value) {
        setState(() {
          saveBtnText = 'screenshot saved!';
        });
      });
    } catch (e) {}
  }

  // void _saveNetworkImage() async {
  //   String path =
  //       'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
  //   GallerySaver.saveImage(path).then((bool success) {
  //     setState(() {
  //
  //     });
  //   });
  // }

  // Widget _previewImages() {
  //   if (file != null || photoUrl != null) {
  //     // if (file != null || myReadUnit != null && myReadUnit.readImageUrl != null) {
  //     return
  //       Align(
  //         alignment: Alignment.topCenter,
  //         child: Container(
  //           margin: const EdgeInsets.only(top: 60),
  //           height: 120,
  //           width: 120,
  //           child: Stack(
  //             children: [
  //               newImage != null
  //                   ? _showImageCircle()
  //                   : UserInfoScreenPhoto(
  //                 name: widget.user.fullName
  //                     .substring(0, 1)
  //                     .toUpperCase(),
  //                 imageurl: photoUrl,
  //                 width: 120,
  //                 height: 120,
  //               ),
  //               Positioned(
  //                 top: 80,
  //                 left: 80,
  //                 child: Container(
  //                   width: 40,
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(80),
  //                     color: Theme.of(context).primaryColor,
  //                   ),
  //                   child: IconButton(
  //                       onPressed: () {
  //                         showImage();
  //                         setState(() {});
  //                       },
  //                       icon: Icon(
  //                         Icons.photo_camera,
  //                         size: 20,
  //                         color: Colors.white,
  //                       )),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     // return Stack(
  //     //   children: [
  //     //     Container(
  //     //       child: kIsWeb
  //     //           ? Image.network(file != null ? file.path : photoUrl)
  //     //           : Container(
  //     //         constraints: BoxConstraints.expand(
  //     //           //width: MediaQuery.of(context).size.width-50,
  //     //           height: 200,
  //     //         ),
  //     //         child: PhotoView(
  //     //           loadingBuilder: (context, _progress) => Center(
  //     //             child: Container(
  //     //               width: 20.0,
  //     //               height: 20.0,
  //     //               child: CircularProgressIndicator(
  //     //                 value: _progress == null
  //     //                     ? null
  //     //                     : _progress.cumulativeBytesLoaded /
  //     //                     _progress.expectedTotalBytes,
  //     //               ),
  //     //             ),
  //     //           ),
  //     //           imageProvider: file != null
  //     //               ? FileImage(File(file.path))
  //     //               : CachedNetworkImageProvider(photoUrl),
  //     //         ),
  //     //       ),
  //     //     ),
  //     //     Positioned(
  //     //         top: 5,
  //     //         right: 5,
  //     //         child: IconButton(
  //     //             onPressed: _submiting ? null : chooseImage,
  //     //             icon: Icon(
  //     //               Icons.photo,
  //     //               color: Colors.red,
  //     //               size: 40,
  //     //             ))),
  //     //     _isuploadingPicture
  //     //         ? Container(
  //     //         constraints: BoxConstraints.expand(
  //     //           //width: MediaQuery.of(context).size.width-50,
  //     //           height: 200,
  //     //         ),
  //     //         child: SpinKitCubeGrid(
  //     //           color: Colors.white,
  //     //           size: 100,
  //     //         ))
  //     //         : Container()
  //     //   ],
  //     // );
  //   } else {
  //     return ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           padding: const EdgeInsets.only(
  //             left: 15,
  //             right: 15,
  //             top: 10,
  //             bottom: 10,
  //           ),
  //         ), //
  //         onPressed: chooseImage,
  //         child: Row(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(right: 10),
  //               child: Icon(
  //                 Icons.photo,
  //                 color: Colors.white,
  //                 size: 30,
  //               ),
  //             ),
  //             Text("Take picture of read unit."),
  //           ],
  //         ));
  //   }
  // }
  Widget _previewProfileImages() {
    if (file != null || photoUrl != null) {
      // if (file != null || myReadUnit != null && myReadUnit.readImageUrl != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          height: 120,
          width: 120,
          child: Stack(
            children: [
              Container(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: file != null
                      ? FileImage(File(file.path))
                      : CachedNetworkImageProvider(photoUrl),
                  radius: 50,
                ),
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
                      onPressed: _submiting ? null : chooseImage,
                      icon: Icon(
                        Icons.photo_camera,
                        size: 20,
                        color: Colors.white,
                      )),
                ),
              ),
              _isuploadingPicture
                  ? Container(
                      constraints: BoxConstraints.expand(
                        //width: MediaQuery.of(context).size.width-50,
                        height: 200,
                      ),
                      child: SpinKitCubeGrid(
                        color: Colors.white,
                        size: 100,
                      ))
                  : Container(),
            ],
          ),
        ),
      );
      // return Stack(
      //   children: [
      //     Container(
      //       child: kIsWeb
      //           ? Image.network(file != null ? file.path : photoUrl)
      //           : Container(
      //         constraints: BoxConstraints.expand(
      //           //width: MediaQuery.of(context).size.width-50,
      //           height: 200,
      //         ),
      //         child: PhotoView(
      //           loadingBuilder: (context, _progress) => Center(
      //             child: Container(
      //               width: 20.0,
      //               height: 20.0,
      //               child: CircularProgressIndicator(
      //                 value: _progress == null
      //                     ? null
      //                     : _progress.cumulativeBytesLoaded /
      //                     _progress.expectedTotalBytes,
      //               ),
      //             ),
      //           ),
      //           imageProvider: file != null
      //               ? FileImage(File(file.path))
      //               : CachedNetworkImageProvider(photoUrl),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //         top: 5,
      //         right: 5,
      //         child: IconButton(
      //             onPressed: _submiting ? null : chooseImage,
      //             icon: Icon(
      //               Icons.photo,
      //               color: Colors.red,
      //               size: 40,
      //             ))),
      //     _isuploadingPicture
      //         ? Container(
      //         constraints: BoxConstraints.expand(
      //           //width: MediaQuery.of(context).size.width-50,
      //           height: 200,
      //         ),
      //         child: SpinKitCubeGrid(
      //           color: Colors.white,
      //           size: 100,
      //         ))
      //         : Container()
      //   ],
      // );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          height: 120,
          width: 120,
          child: Stack(
            children: [
              Container(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/image/user-photo.png"),
                  radius: 50,
                ),
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
                      onPressed: _submiting ? null : chooseImage,
                      icon: Icon(
                        Icons.photo_camera,
                        size: 20,
                        color: Colors.white,
                      )),
                ),
              ),
              _isuploadingPicture
                  ? Container(
                      constraints: BoxConstraints.expand(
                        //width: MediaQuery.of(context).size.width-50,
                        height: 200,
                      ),
                      child: SpinKitCubeGrid(
                        color: Colors.white,
                        size: 100,
                      ))
                  : Container(),
            ],
          ),
        ),
      );
    }
    // else {
    //   return ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //         padding: const EdgeInsets.only(
    //           left: 15,
    //           right: 15,
    //           top: 10,
    //           bottom: 10,
    //         ),
    //       ), //
    //       onPressed: chooseImage,
    //       child: Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(right: 10),
    //             child: Icon(
    //               Icons.photo,
    //               color: Colors.white,
    //               size: 30,
    //             ),
    //           ),
    //           Text("Take picture of read unit."),
    //         ],
    //       ));
    // }
  }

  chooseImage() async {
    file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {});
  }

  // _showImageCircle() => Container(
  //       height: 120,
  //       width: 120,
  //       child: CircleAvatar(
  //         backgroundColor: Colors.pink[300],
  //         backgroundImage: Image.file(File(newImage.path)).image,
  //         radius: 50,
  //       ),
  //     );

  Future<void> showImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      newImage = image;
    });
  }
}
