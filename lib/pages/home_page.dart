// @dart=2.9
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/Meter.dart';
import 'package:left_style/pages/meter_search_result.dart';
import 'package:left_style/pages/my_meterBill_list.dart';
import 'package:left_style/pages/my_uploadUnit_list.dart';
import 'package:left_style/pages/upload_my_read.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/widgets/qr_code_demo.dart';
import 'package:left_style/widgets/scan_qr.dart';
import 'package:left_style/widgets/scan_qr_data.dart';
import 'package:provider/provider.dart';

import 'meter_city.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

// Alert Dialog function
  Future<String> _showAlertDialog(context) {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: Center(child: new Text("Select search option")),
            //content: new Text("Alert Dialog body"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () {
                    Navigator.of(context).pop("QR");
                    return "QR";
                  },
                ),
                new IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).pop("Key");
                    return "Key";
                  },
                ),
                new TextButton(
                  child: new Text("close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    return null;
                  },
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "HomePage",
                  style: TextStyle(fontSize: 30, color: Colors.pink),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Pressed");
                    await context.read<LoginProvider>().logOut(context);
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Pressed");
                    var meterRef =
                        FirebaseFirestore.instance.collection(meterCollection);

                    if (FirebaseAuth.instance.currentUser?.uid != null) {
                      String uid =
                          FirebaseAuth.instance.currentUser.uid.toString();

                      await meterRef
                          .doc(uid)
                          .collection(userMeterCollection)
                          .doc("7324392739")
                          .set(jsonString);
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String codeSanner =
                        await BarcodeScanner.scan().then((value) {
                      if (value != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UploadMyReadScreen(customerId: value)));
                      }
                    }).catchError((error) {});
                  },
                  child: Text(
                    "Read Unit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyMeterBillListPage()));
                  },
                  child: Text(
                    "My Meter bills",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyUploadUnitListPage()));
                  },
                  child: Text(
                    "My Uploaded unit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRCodePage()));
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MeterSearchResultPage()));

                      var apiUrl = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => MeterCityPage()));

                      if (apiUrl != null) {
                        var typeResult = await _showAlertDialog(context);
                        if (typeResult != null && typeResult == "QR") {
                          try {
                            String codeSanner =
                                await BarcodeScanner.scan().then((value) {
                              if (value != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MeterSearchResultPage(
                                          searchKey: value,
                                          apiUrl: apiUrl,
                                        )));
                              }
                            }).catchError((error) {}); //barcode scanner

                          } catch (ex) {
                            print("cancel scan");
                          }
                        } else if (typeResult != null && typeResult == "Key") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MeterSearchResultPage(
                                    searchKey: null,
                                    apiUrl: apiUrl,
                                  )));
                        }
                      }
                    },
                    child: Text("Go to QR Page"))
              ],
            ),
          ),
        ));
  }
}

const jsonString = {
  "AllowedUnit": 0,
  "Ampere": "10/30",
  "ApplyDate": null,
  "AvageUseUnit": 99,
  "BillNeedModity": false,
  "BinderId": 5,
  "Block": null,
  "BranchId": "1",
  "BusinessNo": "",
  "CategoryId": 1,
  "CategoryName": "ရိုးရိုး",
  "ChargePerUnit": 35,
  "ConsumerName": "ဦးအိုက်နပ်",
  "ConsumerType": "P",
  "CoverSeal": null,
  "CreditAmount": 79040,
  "CreditReason": null,
  "CreditUnit": 0,
  "CurrencyType": "ks",
  "CustomerId": "7324392739",
  "DueDate": "2016-07-28T15:15:28.307",
  "ExcelFileName": null,
  "FeederID": 3,
  "GroupId": 2,
  "HorsePower": 0,
  "HorsePowerCost": 0,
  "HouseNo": "အမှတ်-၂၀/၂၂၊ တက္ကသိုလ်ရိပ်သာလမ်း",
  "Id": 2,
  "InsertDate": "2016-07-28T15:15:28.307",
  "InstallPerson": null,
  "IsShowDebt": true,
  "IssueDate": null,
  "JoinDate": "23-12-2019",
  "LastDate": "2016-07-28T15:15:28.307",
  "LastMonthRedUnit": null,
  "LastReadUnit": 13151,
  "Latitude": "22.9534015",
  "LayerAmount": null,
  "LayerDescription": null,
  "LayerRate": null,
  "LedgerId": "BH1",
  "LedgerPostFix": "01/03",
  "Longitude": "97.7405598",
  "MainLedgerId": 1,
  "MainLedgerTitle": "2110",
  "MaintainenceCost": 500,
  "ManufacturerNo": "10/30",
  "MeterNo": "YA-046496",
  "MeterSerial": "",
  "Mobile": "09123456789",
  "Multiplier": "1",
  "NoLayer": false,
  "NoOfRoom": 1,
  "OldAccount": null,
  "OutDemand": null,
  "Percentage": 0,
  "PoleNo": null,
  "Rate": "1 ",
  "ReadDate": "2016-07-28T15:15:28.307",
  "RequiredMatchGPS": false,
  "Street": "နယ်မြေ(၁)",
  "StreetLightCost": null,
  "TerminalSeal": null,
  "TransformerID": 49,
  "TspEng": null,
  "TspMM": null,
  "TwinLeftSeal": null,
  "TwinRightSeal": null,
  "Voltage": "230",
  "WattLoad": "",
  "dueDate": "2016-07-28T15:15:28.307",
  "meterBill": 150000
};
