// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/payment_method.dart';
import 'package:left_style/pages/payment_method_list.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:left_style/utils/message_handler.dart' as myMsg;
import 'dart:io';
import 'package:provider/provider.dart';

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

  PaymentMethod _paymentMethod;
  FocusNode transferAmountFoucusNode;
  FocusNode transactionIdFoucusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 40),
            child: Text("TopUp"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Form(
                  key: _topupformKey,
                  child: Column(
                    children: [
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
                                          new PaymentMethodListPage()));

                              if (payment != null) {
                                _paymentMethod = payment;
                                setState(() {
                                  _paymentController.text = _paymentMethod.name;
                                });
                              }
                            },
                            controller: _paymentController,
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
                                      child:
                                          Icon(Icons.monetization_on_outlined),
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
                              hintText: "Select Payment",
                            ),
                          )),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: _previewImages(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        focusNode: transferAmountFoucusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _transferAmountController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return Validator.requiredField(context, val, '');
                        },
                        decoration: buildInputDecoration("Transfer Amount"),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        focusNode: transferAmountFoucusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _transactionIdController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return Validator.requiredField(context, val, '');
                        },
                        decoration:
                            buildInputDecoration("Transaction Id 6 digit"),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                primary: Colors.white24,
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 10,
                                  bottom: 10,
                                ),
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 10,
                                  bottom: 10,
                                ) // foreground
                                ),
                            onPressed: () async {
                              if (file == null) {
                                myMsg.MessageHandler.showErrMessage(
                                    context,
                                    "Picture is required",
                                    "Plase take a picture and upload");
                                return;
                              }
                              if (_topupformKey.currentState.validate()) {
                                print("Validate");
                                await context.read<WalletProvider>().topup(
                                    context,
                                    _paymentMethod.id,
                                    double.parse(
                                        _transferAmountController.text),
                                    _transactionIdController.text,
                                    file);
                              }
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 10,
                                    bottom: 10,
                                  ) // foreground
                                  ),
                              onPressed: () async {
                                if (file == null) {
                                  myMsg.MessageHandler.showErrMessage(
                                      context,
                                      "Picture is required",
                                      "Plase take a picture and upload");
                                  return;
                                }
                                if (_topupformKey.currentState.validate()) {
                                  print("Validate");
                                  await context.read<WalletProvider>().topup(
                                      context,
                                      _paymentMethod.id,
                                      double.parse(
                                          _transferAmountController.text),
                                      _transactionIdController.text,
                                      file);
                                }
                              },
                              child: Text("Submit")),
                        ],
                      )
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
                  onPressed: chooseImage,
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
            padding: EdgeInsets.only(
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
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.photo,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Text("Take picture of read unit."),
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
      labelStyle: TextStyle(),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }
}
