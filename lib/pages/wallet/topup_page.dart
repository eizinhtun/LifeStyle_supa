// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/payment_method.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/pages/payment_method_list.dart';
import 'package:left_style/utils/validator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../tutorial_video_page.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _topupformKey = GlobalKey<FormState>();
  TextEditingController _transferAmountController = TextEditingController();
  TextEditingController _transactionIdController = TextEditingController();
  TextEditingController _paymentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  bool _isuploadingPicture = false;
  XFile file;
  String status = '';
  String base64Image;
  XFile tmpFile;
  bool _submiting = false;

  PaymentMethod _paymentMethod;
  FocusNode transferAmountFoucusNode;
  FocusNode transactionIdFoucusNode;

  @override
  void initState() {
    super.initState();
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
        .child('user_topup')
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

  Future<void> upload(TransactionModel model) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      model.status = "verifying";
      model.uid = uid;

      var result = await FirebaseFirestore.instance
          .collection(transactions)
          .add(model.toJson());
      if (result.id.isNotEmpty) {
        Navigator.pop(context, true);
        ShowMessageHandler.showMessage(
            context,
            Tran.of(context).text("success"),
            Tran.of(context).text("topup_add_success"));
      } else {
        setState(() {
          _submiting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Container(
            margin: const EdgeInsets.only(right: 40),
            child: Text(Tran.of(context).text("topup")),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.red,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Form(
                  key: _topupformKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 20, right: 25, left: 15, bottom: 10),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TutorialVideoPage(
                                          type: "topup",
                                          url: SystemData.topupVideoLink),
                                ));
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/video.png",
                                width: 30,
                              ),
                              Text("    "),
                              Text("Click to watch",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              Text(
                                  " " +
                                      Tran.of(context).text("showvideo_topup"),
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                        ),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () async {
                            var payment = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentMethodListPage()));

                            if (payment != null) {
                              _paymentMethod = payment;
                              setState(() {
                                _paymentController.text = _paymentMethod.name;
                              });
                            }
                          },
                          controller: _paymentController,
                          validator: (val) {
                            return Validator.requiredField(
                                context,
                                val.toString(),
                                Tran.of(context).text("payment_method"));
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: Colors.red,
                            ),
                            prefixIcon: (_paymentMethod == null ||
                                    _paymentMethod.logoUrl == null ||
                                    _paymentMethod.logoUrl.length == 0)
                                ? Container(
                                    child: Icon(Icons.monetization_on_outlined),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.network(
                                      _paymentMethod.logoUrl,
                                      width: 10,
                                      height: 10,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                            hintText:
                                Tran.of(context).text("payment_method_list"),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: _previewImages(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        focusNode: transferAmountFoucusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // onUserInteraction,
                        controller: _transferAmountController,
                        keyboardType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return Validator.transferAmount(context, val);
                        },
                        decoration: buildInputDecoration(
                            Tran.of(context).text("transfer_amount")),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        focusNode: transferAmountFoucusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _transactionIdController,
                        keyboardType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          return Validator.tracId(context, val);
                        },
                        decoration: buildInputDecoration(
                            Tran.of(context).text("transaction_id_6")),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                primary: Colors.white24,
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 10,
                                  bottom: 10,
                                ),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                          _submiting
                              ? SpinKitDoubleBounce(
                                  color: Theme.of(context).primaryColor,
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 10,
                                        bottom: 10,
                                      ) // foreground
                                      ),
                                  onPressed: _submiting
                                      ? null
                                      : () async {
                                          // if (file == null) {
                                          //   ShowMessageHandler.showErrMessage(
                                          //       context,
                                          //       Tran.of(context)
                                          //           .text("pic_required"),
                                          //       Tran.of(context)
                                          //           .text("pic_required_str"));
                                          //   return;
                                          // }
                                          if (_topupformKey.currentState
                                              .validate()) {
                                            if (file == null) {
                                              ShowMessageHandler.showErrMessage(
                                                  context,
                                                  Tran.of(context)
                                                      .text("pic_required"),
                                                  Tran.of(context).text(
                                                      "pic_required_str"));
                                              return;
                                            }
                                            setState(() {
                                              _submiting = true;
                                              if (file != null) {
                                                _isuploadingPicture = true;
                                              }
                                            });

                                            TransactionModel model =
                                                TransactionModel();
                                            model.paymentType =
                                                _paymentMethod.id;
                                            model.type = TransactionType.Topup;
                                            model.amount = int.parse(
                                                _transferAmountController.text);
                                            model.transactionId =
                                                _transactionIdController.text;
                                            model.paymentLogoUrl =
                                                _paymentMethod.logoUrl;
                                            model.createdDate =
                                                Timestamp.fromDate(
                                                    DateTime.now());
                                            if (file != null) {
                                              setState(() {
                                                _isuploadingPicture = true;
                                              });
                                              firebase_storage.UploadTask task =
                                                  await uploadFile(
                                                      PickedFile(file.path));
                                              if (task != null) {
                                                task.whenComplete(() async {
                                                  model.imageUrl = await task
                                                      .snapshot.ref
                                                      .getDownloadURL();
                                                  setState(() {
                                                    _isuploadingPicture = false;
                                                  });
                                                  upload(model);
                                                });
                                              }
                                            }
                                          }
                                        },
                                  child: Text(Tran.of(context).text("submit"))),
                        ],
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

  Widget _previewImages() {
    if (file != null) {
      // if (file != null || myReadUnit != null && myReadUnit.readImageUrl != null) {
      return Stack(
        children: [
          Container(
            child: kIsWeb
                ? Container()
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
                          : Container(),
                    ),
                  ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                  onPressed: _submiting ? null : chooseImage,
                  icon: Icon(
                    Icons.photo,
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
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: 10,
            ),
          ), //
          onPressed: chooseImage,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.photo,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Text(Tran.of(context).text("pic_read_unit")),
            ],
          ));
    }
  }

  chooseImage() async {
    file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {});
  }

  InputDecoration buildInputDecoration(String hinttext) {
    return InputDecoration(
      labelText: hinttext,
      labelStyle: const TextStyle(),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }
}
