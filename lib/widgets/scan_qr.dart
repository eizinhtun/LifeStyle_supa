// @dart=2.9

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:left_style/widgets/scan_qr_data.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String qrCodeResult = "Not Yet Scanned";

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
                          child: Container()),
                    ),
                  ],
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 100),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String codeSanner = await BarcodeScanner
                                            .scan(); //barcode scanner
                                        qrCodeResult = codeSanner;
                                        if (qrCodeResult != null) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScanQRData(
                                                          qrcodeuid:
                                                              qrCodeResult)));
                                        } else {
                                          String codeSanner =
                                              await BarcodeScanner.scan();
                                        }

                                        setState(() {});
                                      },
                                      child: Text(
                                        "Open Scanner",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      //Button having rounded rectangle border
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   top: 100,
                //   child: Container(
                //     constraints: BoxConstraints.expand(
                //       height: MediaQuery
                //           .of(context)
                //           .size
                //           .height,
                //     ),
                //
                //       child: Card(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(15.0),
                //           ),
                //           color: Colors.white,
                //           elevation: 2,
                //           child: Container(
                //             color: Colors.red,
                //             child: Column(
                //               children: [
                //                 user.fullName !=null ?Text(user.fullName.toUpperCase(),style: TextStyle(fontSize: 20,color: Colors.grey)):Text("loading..."),
                //                 Container(
                //                     width: 200,
                //                     height: 200,
                //                     child: QrImage(data: qrData)
                //                 ),
                //               ],
                //             ),
                //           )
                //       ),
                //     ),
                //
                // ),
              ],
            ),
          ),
        ));
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Scan QR Code"),
    //   ),
    //   body: Container(
    //     padding: EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         //Message displayed over here
    //         Text(
    //           "Result",
    //           style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
    //           textAlign: TextAlign.center,
    //         ),
    //         Text(
    //           qrCodeResult,
    //           style: TextStyle(
    //             fontSize: 20.0,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //         SizedBox(
    //           height: 20.0,
    //         ),
    //
    //         //Button to scan QR code
    //         FlatButton(
    //           padding: EdgeInsets.all(15),
    //           onPressed: () async {
    //             String codeSanner = await BarcodeScanner.scan(); //barcode scanner
    //             setState(() {
    //               qrCodeResult = codeSanner;
    //             });
    //           },
    //           child: Text("Open Scanner",style: TextStyle(color: Colors.indigo[900]),),
    //           //Button having rounded rectangle border
    //           shape: RoundedRectangleBorder(
    //             side: BorderSide(color: Colors.indigo[900]),
    //             borderRadius: BorderRadius.circular(20.0),
    //           ),
    //         ),
    //
    //       ],
    //     ),
    //   ),
    // );
  }
}
