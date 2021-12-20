// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_model.dart';
import 'package:left_style/models/my_read_unit.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:left_style/utils/validator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadMyReadScreen extends StatefulWidget {
  final String customerId;
  final String branchId;
  final String companyId;
  final String monthName;
  const UploadMyReadScreen(
      {Key key, this.customerId, this.monthName, this.branchId, this.companyId})
      : super(key: key);

  @override
  _UploadMyReadScreenState createState() => _UploadMyReadScreenState();
}

class _UploadMyReadScreenState extends State<UploadMyReadScreen> {
  final _profileformKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _uniteController = TextEditingController();
  bool _isLoading = true;
  bool _isuploadingPicture = false;

  Meter meter;
  User _user;
  XFile file;
  String status = '';
  String base64Image;
  XFile tmpFile;
  String errMessage = 'Error Uploading Image';
  String monthName = "";
  bool isExist = false;
  bool _isUploadingData = false;
  MyReadUnit myReadUnit;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month - 1, now.day);
    if (widget.monthName != null) {
      monthName = widget.monthName;
    } else {
      // monthName = DateFormat('MM/yyyy').format(lastMonth);
    }

    _user = FirebaseAuth.instance.currentUser;
    _phoneController.text = _user.phoneNumber;
    if (_user.phoneNumber != null && _user.phoneNumber.startsWith('+95')) {
      _phoneController.text = _user.phoneNumber.replaceFirst('+95', "0");
    }

    checkMeterExist();
    checkReadMonth();
  }

  Future<void> upload(MyReadUnit model) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      await FirebaseFirestore.instance
          .collection(userUploadUnitCollection)
          .doc(monthName.replaceAll("/", "-") + '-' + widget.customerId)
          .set(model.toJson());
      setState(() {
        _isUploadingData = false;
      });
      Navigator.pop(context, true);
      ShowMessageHandler.showMessage(
          context,
          Tran.of(context).text("success_added"),
          Tran.of(context).text("meter_unit_success_added"));
    }
  }

  Future<bool> checkUnitExist(bool instail) async {
    var value = await FirebaseFirestore.instance
        .collection(userUploadUnitCollection)
        // .doc(FirebaseAuth.instance.currentUser.uid)
        // .collection(userReadUnitCollection)
        .doc(monthName.replaceAll("/", "-") + '-' + widget.customerId)
        .get();

    if (value.exists) {
      myReadUnit = MyReadUnit.fromJson(value.data());
      if (instail) {
        _uniteController.text = myReadUnit.readUnit.toString();
        _phoneController.text = myReadUnit.mobile;
        if (myReadUnit.mobile != null && myReadUnit.mobile.startsWith('+95')) {
          _phoneController.text = myReadUnit.mobile.replaceFirst('+95', "0");
        }
      }

      setState(() {
        isExist = myReadUnit.status == "APPROVED" ? true : false;
      });

      return isExist;
    } else {
      setState(() {
        isExist = false;
      });
      return false;
    }
  }

  Widget _previewImages() {
    if (file != null || myReadUnit != null && myReadUnit.readImageUrl != null) {
      return Stack(
        children: [
          Container(
            // label: 'image_picker_example_picked_image',
            child: kIsWeb
                ? Image.network(
                    file != null ? file.path : myReadUnit.readImageUrl)
                : Container(
                    constraints: BoxConstraints.expand(
                      //width: MediaQuery.of(context).size.width-50,
                      height: 200,
                    ),
                    child: PhotoView(
                      loadingBuilder: (context, _progress) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: _progress == null
                                ? null
                                : _progress.cumulativeBytesLoaded /
                                    _progress.expectedTotalBytes,
                          ),
                        ),
                      ),
                      imageProvider: file != null
                          ? FileImage(File(file.path))
                          : CachedNetworkImageProvider(myReadUnit.readImageUrl),
                      // NetworkImage(myReadUnit.readImageUrl),
                    ),
                  ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                  onPressed: chooseImage,
                  icon: Icon(
                    Icons.camera,
                    color: Colors.red,
                    size: 40,
                  ))),
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
              : Container()
        ],
      );
    } else {
      return TextButton.icon(
        onPressed: chooseImage,

        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        // label: 'Take picture of read unit.',,
        label: Text(
          'Take picture of read unit.',
          textAlign: TextAlign.center,
        ),
        icon: Icon(
          Icons.camera,
          color: Colors.red,
          size: 30,
        ),
      );
    }
  }

  Future<firebase_storage.UploadTask> uploadFile(PickedFile file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user_meter_bill')
        .child('/' +
            monthName.replaceAll("/", "-") +
            '-' +
            meter.customerId +
            '.jpg');

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

  chooseImage() async {
    file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {});
  }

  bool isValidMonth = false;
  Future<void> checkReadMonth() async {
    String docId = "${widget.companyId}_${widget.branchId}";
    var value = await FirebaseFirestore.instance
        .collection(readMeterMonthCollection)
        .doc(docId)
        .get(GetOptions(source: Source.server));

    if (value.exists) {
      DateTime currentDate = DateTime.now();
      DateTime currentDate1 =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      Timestamp fromTimeStamp = value.data()['fromDate'];
      DateTime fromDate = fromTimeStamp.toDate();
      DateTime fromDate1 =
          DateTime(fromDate.year, fromDate.month, fromDate.day);

      Timestamp toTimeStamp = value.data()['toDate'];

      DateTime toDate = toTimeStamp.toDate();
      DateTime toDate1 = DateTime(toDate.year, toDate.month, toDate.day);
      if ((fromDate1.isBefore(currentDate1) ||
              fromDate1.isAtSameMomentAs(currentDate1)) &&
          (currentDate1.isBefore(toDate1) ||
              toDate1.isAtSameMomentAs(currentDate1))) {
        isValidMonth = true;
        monthName = value.data()['monthName'];
      } else {
        isValidMonth = false;
      }
    } else {
      isValidMonth = false;
    }
    checkUnitExist(true);
  }

  Future<bool> checkMeterExist() async {
    var value = await FirebaseFirestore.instance
        .collection(meterCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(userMeterCollection)
        .doc(widget.customerId)
        .get();

    if (value.exists) {
      meter = Meter.fromJson(value.data());
      setState(() {
        _isLoading = false;
      });

      return true;
    } else {
      Navigator.pop(context, null);
      ShowMessageHandler.showMessage(
          context,
          Tran.of(context).text("device_not_connect"),
          Tran.of(context).text("device_not_connect_str"));
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "" + (meter == null ? "Meter" : meter.meterNo),
          ),
        ),
        backgroundColor: Colors.white,
        body: !isValidMonth && !isExist
            ? Center(
                child: Text(
                  Tran.of(context).text("can_not_upload_unit_str"),
                ),
              )
            : _isLoading
                ? (SpinKitDoubleBounce(
                    color: Colors.red,
                  ))
                : SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "For: " + meter.meterName + " " + monthName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  myReadUnit != null &&
                                          myReadUnit.status.length > 0
                                      ? myReadUnit.status
                                      : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: Center(
                              child: _previewImages(),
                            ),
                          ),
                          Form(
                            key: _profileformKey,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                /* boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]*/
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2)))),
                                    child: TextFormField(
                                      // enabled: isEnabled,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: _phoneController,
                                      validator: (val) {
                                        String phoneFormate =
                                            Validator.registerPhone(
                                                context, val.toString());
                                        if (phoneFormate != null) {
                                          return phoneFormate;
                                        }

                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "${Tran.of(context)?.text('phone')}",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2)))),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: _uniteController,
                                      validator: (val) {
                                        return Validator.requiredField(
                                          context,
                                          val.toString(),
                                          "${Tran.of(context)?.text('current_unit')}",
                                        );
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "${Tran.of(context)?.text('current_unit')}",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            constraints: BoxConstraints(
                              // minHeight: 60,
                              minWidth: double.infinity,
                              // maxHeight: 400
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white24,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    Tran.of(context).text("cancel"),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _isUploadingData
                                    ? SpinKitDoubleBounce(
                                        color: Colors.pink,
                                      )
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                        ),
                                        onPressed: () async {
                                          if (file == null &&
                                              (myReadUnit == null ||
                                                  myReadUnit
                                                          .readImageUrl.length <
                                                      1)) {
                                            ShowMessageHandler.showErrMessage(
                                                context,
                                                Tran.of(context)
                                                    .text("pic_required"),
                                                Tran.of(context)
                                                    .text("pic_required_str"));
                                            return;
                                          }
                                          if (_profileformKey.currentState
                                              .validate()) {
                                            if (!isValidMonth) {
                                              ShowMessageHandler.showErrMessage(
                                                  context,
                                                  Tran.of(context).text(
                                                      "can_not_upload_unit"),
                                                  Tran.of(context).text(
                                                      "can_not_upload_unit_str"));
                                              return;
                                            }
                                            bool existAndApproved =
                                                await checkUnitExist(false);
                                            if (existAndApproved) {
                                              ShowMessageHandler.showErrMessage(
                                                  context,
                                                  Tran.of(context)
                                                      .text("can_not_edit"),
                                                  monthName +
                                                      "\' s unit is been approved");
                                              return;
                                            }
                                            setState(() {
                                              _isUploadingData = true;
                                            });

                                            MyReadUnit model = MyReadUnit();
                                            model.uid = FirebaseAuth
                                                .instance.currentUser.uid;
                                            model.monthName = monthName;
                                            model.customerId = meter.customerId;
                                            model.companyId = meter.companyId;
                                            model.meterNo = meter.meterNo;
                                            model.consumerName =
                                                meter.consumerName;
                                            model.branchId = meter.branchId;
                                            model.mobile =
                                                _phoneController.text;
                                            model.readUnit = int.parse(
                                                _uniteController.text);
                                            model.status = "Applying";
                                            model.readDate = Timestamp.fromDate(
                                                DateTime.now());
                                            model.companyId = "1";
                                            if (file != null) {
                                              setState(() {
                                                _isuploadingPicture = true;
                                              });
                                              firebase_storage.UploadTask task =
                                                  await uploadFile(
                                                      PickedFile(file.path));
                                              if (task != null) {
                                                task.whenComplete(() async {
                                                  model.readImageUrl =
                                                      await task.snapshot.ref
                                                          .getDownloadURL();
                                                  setState(() {
                                                    _isuploadingPicture = false;
                                                  });
                                                  upload(model);
                                                });
                                              }
                                            } else if (myReadUnit != null &&
                                                myReadUnit.readImageUrl.length >
                                                    0) {
                                              model.readImageUrl =
                                                  myReadUnit.readImageUrl;
                                              upload(model);
                                            }

/*
                                UserModel userModel = UserModel(
                                    uid: _user.uid,
                                    fullName:_unitController.text.toString(),
                                    phone:Formatter.formatPhone( _phoneController.text.toString()),
                                    password: pass,
                                    photoUrl:_user.photoURL,
                                    email: _user.email,

                                    isActive: true,
                                    createdDate: DateTime.now());
                                await context
                                    .read<LoginProvider>()
                                    .updateUserInfo(
                                    context, userModel);*/
                                          }
                                        },
                                        child: Text(
                                          Tran.of(context).text("upload"),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
  }
}
