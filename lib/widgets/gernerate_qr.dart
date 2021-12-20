// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  //String qrData= FirebaseAuth.instance.currentUser.uid.toString();
  UserModel user = UserModel();
  String qrData;
  String photo;
  String fullName;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<UserModel> getUser() async {
    user = await context.read<LoginProvider>().getUser(context);
    qrData = user.uid;
    photo = user.photoUrl;
    fullName = user.fullName.toUpperCase();
    return user;
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
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(200, 56.0),
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
                        child: Container()),
                  ),
                ],
              ),
              Positioned(
                top: 100,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            elevation: 10,
                            child: Container()),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    children: [
                      (qrData != null)
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white,
                                elevation: 10,
                                child: Container(
                                  // padding:
                                  //     EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
                                            child: Text(fullName,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey)),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            child: Text(Tran.of(context)
                                                .text("scan_to_pay")),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 50),
                                            width: 200,
                                            height: 200,
                                            //child: QrImage(data: qrData)
                                            child: _qrImage(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Text(
                                Tran.of(context).text("loading"),
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

  _qrImage() {
    if (photo == null) {
      return QrImage(
        data: qrData,
        version: QrVersions.auto,
        size: 320,
        gapless: false,
        embeddedImage: AssetImage("assets/image/user-photo.png"),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(50, 50),
        ),
      );
    } else {
      return QrImage(
        data: qrData,
        version: QrVersions.auto,
        size: 320,
        gapless: false,
        embeddedImage: CachedNetworkImageProvider(photo),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(50, 50),
        ),
      );
    }
  }
}
