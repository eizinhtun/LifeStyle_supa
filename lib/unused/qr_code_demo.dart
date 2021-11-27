// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:left_style/widgets/scan_qr.dart';

import '../widgets/gernerate_qr.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({Key key}) : super(key: key);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 500,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Display Image
          Image(
              image: CachedNetworkImageProvider(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQyYwscUPOH_qPPe8Hp0HAbFNMx-TxRFubpg&usqp=CAU")),

          //First Button

          FlatButton(
            padding: EdgeInsets.all(15),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ScanQR()));
            },
            child: Text(
              "Scan QR Code",
              style: TextStyle(color: Colors.indigo[900]),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.indigo[900]),
            ),
          ),
          SizedBox(height: 10),

          //Second Button
          FlatButton(
            padding: EdgeInsets.all(15),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GenerateQR()));
            },
            child: Text(
              "Generate QR Code",
              style: TextStyle(color: Colors.indigo[900]),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.indigo[900]),
            ),
          ),
        ],
      ),
    ));
  }
}
