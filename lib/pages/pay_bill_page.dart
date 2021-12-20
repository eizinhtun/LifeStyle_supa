// @dart=2.9
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_bill_model.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/utils/network_util.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:left_style/utils/validator.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'my_meterBill_detail.dart';

class PayBillPage extends StatefulWidget {
  const PayBillPage({Key key, this.bill, this.docId}) : super(key: key);
  final MeterBill bill;
  final String docId;

  @override
  _PayBillPageState createState() => _PayBillPageState();
}

class _PayBillPageState extends State<PayBillPage> {
  final _formKey = GlobalKey<FormState>();
  final _pwformKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  bool _obscureText = false;
  bool _isLoading = true;
  bool _submiting = false;
  TextStyle style = const TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(Tran.of(context).text("pay_bill").toString()),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            widget.bill.meterNo,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Tran.of(context).text("read_date") + " :",
                              style: style,
                            ),
                            Text(
                              Formatter.getDate(widget.bill.readDate.toDate())
                                  .toString(),
                              style: style,
                            ),
                          ],
                        ),
                      ),

                      Dash(
                        direction: Axis.horizontal,
                        length: MediaQuery.of(context).size.width * 0.84,
                        dashLength: 2,
                        /////// dashColor: sysData.mainColor
                      ),
                      // Divider(
                      //   thickness: 1,
                      //   height: 1,
                      //   color: Colors.black26,
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Tran.of(context).text("meter_unit") + " :",
                              style: style,
                            ),
                            Text(
                              NumberFormat('#,###,000')
                                      .format(widget.bill.unitsToPay) +
                                  " " +
                                  Tran.of(context).text("unit"),
                              style: style,
                            ),
                          ],
                        ),
                      ),
                      Dash(
                        direction: Axis.horizontal,
                        length: MediaQuery.of(context).size.width * 0.84,
                        dashLength: 2,
                        /////// dashColor: sysData.mainColor
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Tran.of(context).text("meter_bill") + " :",
                              style: style,
                            ),
                            Text(
                              NumberFormat('#,###,000')
                                      .format(widget.bill.totalCost) +
                                  " " +
                                  Tran.of(context).text("ks"),
                              style: style,
                            ),
                          ],
                        ),
                      ),
                      Dash(
                        direction: Axis.horizontal,
                        length: MediaQuery.of(context).size.width * 0.84,
                        dashLength: 2,
                        /////// dashColor: sysData.mainColor
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: true,
                        maxLines: 1,
                        // expands: true,
                        controller: _remarkController,
                        keyboardType: TextInputType.text,
                        // validator: (val) {
                        //   return Validator.requiredField(
                        //       context, val.toString(), "Remark");
                        // },
                        decoration: InputDecoration(
                          labelText: Tran.of(context).text("enter_remark"),
                          // hintText: "Enter your remark",
                          // hintStyle: const TextStyle(),
                          contentPadding: const EdgeInsets.all(16),
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: Theme.of(context).primaryColor),
                          // ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            showPwBottomSheet(context);
                            setState(() {
                              _submiting = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "${Tran.of(context)?.text("pay_bill")}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
    );
  }

  showPwBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              // height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 10,
                //       color: Colors.grey[300],
                //       spreadRadius: 5)
                // ],
              ),
              // margin: const EdgeInsets.all(16),
              child: Form(
                key: _pwformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        Tran.of(context).text("enter_password"),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      validator: (val) {
                        return Validator.password(context, val.toString(),
                            Tran.of(context).text("password"), true);
                      },
                      decoration: InputDecoration(
                        labelText: "${Tran.of(context)?.text('password')}",
                        labelStyle: const TextStyle(),
                        hintText: "${Tran.of(context)?.text('password')}",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            side: BorderSide(
                              width: 1.0,
                              color: Colors.black12,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              Tran.of(context)?.text("close"),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        _submiting
                            ? SpinKitDoubleBounce(
                                color: Theme.of(context).primaryColor,
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  side: BorderSide(
                                    width: 1.0,
                                    color: Colors.black12,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    Tran.of(context)?.text("confirm"),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                onPressed: _submiting
                                    ? null
                                    : () async {
                                        if (_pwformKey.currentState
                                            .validate()) {
                                          setState(() {
                                            _submiting = true;
                                          });

                                          widget.bill.remark =
                                              _remarkController.text;

                                          widget.bill.payDate =
                                              Timestamp.fromDate(
                                                  DateTime.now());

                                          bool checkPass = await checkPassword(
                                              _passwordController.text);

                                          if (checkPass != null && checkPass) {
                                            payMeterBill(context, widget.bill);

                                            _submiting = false;
                                          } else {
                                            ShowMessageHandler.showErrMessage(
                                                context,
                                                Tran.of(context)
                                                    .text("can_not_pay_bill"),
                                                Tran.of(context)
                                                    .text("pin_not_correct"));
                                          }
                                        }
                                      },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkPassword(password) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      var userRef = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(uid)
          .get(GetOptions(source: Source.server));
      if (userRef != null && userRef.exists) {
        String oldPassword = userRef.data()["password"];
        bool isCorrect = DBCrypt().checkpw(password, oldPassword);
        if (isCorrect) {
          setState(() {
            _isLoading = false;
          });

          return true;
        } else {
          Navigator.pop(context, null);
          ShowMessageHandler.showMessage(
              context,
              Tran.of(context).text("password_fail"),
              Tran.of(context).text("password_fail_str"));
          setState(() {
            _isLoading = false;
          });
          return false;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  // var userRef = FirebaseFirestore.instance.collection(userCollection);
  // Future<bool> checkPassword(BuildContext context, String password) {
  //   var pass = DBCrypt().hashpw(password, DBCrypt().gensalt());
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid.toString();
  //     userRef.doc(uid).get().then((value) {
  //       bool pwValid = value.data()['password'] == pass;
  //       return pwValid;
  //     });
  //   }
  // }

  Future<bool> payMeterBill(BuildContext context, MeterBill bill) async {
    NetworkUtil _netUtil = NetworkUtil();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      var myHeaders = await getHeadersWithOutToken();
      String signature = bill.customerId +
          bill.branchId +
          uid +
          (bill.totalCost + bill.creditAmount).toString() +
          secretkey;
      String signatureKey =
          md5.convert(signature.codeUnits).toString().toUpperCase();
      var url =
          "$domainName/Value?companyId=${bill.companyId}&customerId=${bill.customerId}&paymentAmount=${bill.totalCost + bill.creditAmount}&uid=$uid&branchId=${bill.branchId}&signature=$signatureKey";
      http.Response response = await _netUtil.get(context, url, null);
      if (response != null) {
        if (response.statusCode == 200) {
          Navigator.pop(context, true);
          Navigator.pop(context, true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MeterBillDetailPage(docId: bill.docId),
            ),
          ).then((value) {});
          ShowMessageHandler.showMessage(
              context,
              Tran.of(context).text("success"),
              Tran.of(context).text("bill_pay_success"));
          return true;
        } else {
          setState(() {
            _submiting = false;
          });
          Navigator.pop(context, true);
          ShowMessageHandler.showErrMessage(
            context,
            Tran.of(context).text("fail"),
            Tran.of(context).text("bill_pay_fail"),
          );
          return false;
        }
      }

      // FirebaseFirestore.instance
      //     .collection(meterBillsCollection)
      //     .doc(bill.docId)
      //     .update({'isPaid': true, 'status': 'Paid'});
      // Navigator.pop(context, true);
      // Navigator.pop(context, true);

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MeterBillDetailPage(docId: bill.docId),
      //   ),
      // ).then((value) {});

      // ShowMessageHandler.showMessage(context, Tran.of(context).text("success"),
      //     Tran.of(context).text("bill_pay_success"));
      // return true;
    }
  }

  String getPayDate(DateTime date) {
    var dateFormat = DateFormat("yyyy-MM-dd"); // you can change the format here
    return dateFormat.format(date);
  }
}
