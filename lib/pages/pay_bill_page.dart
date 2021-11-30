// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/meter_bill_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/formatter.dart';
import 'package:left_style/utils/validator.dart';
import 'package:provider/provider.dart';

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
  TextStyle style = TextStyle(
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
        margin: EdgeInsets.all(8),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            widget.bill.meterNo,
                            style: TextStyle(
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
                          // hintStyle: TextStyle(),
                          contentPadding: EdgeInsets.all(16),
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
                            // showPwDialog(context);
                            showPwBottomSheet(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "${Tran.of(context)?.text("pay_bill")}",
                            style: TextStyle(
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
              padding: EdgeInsets.all(16),
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
              // margin: EdgeInsets.all(16),
              child: Form(
                key: _pwformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        Tran.of(context).text("enter_password"),
                        style: TextStyle(
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
                        labelStyle: TextStyle(),
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
                            padding: EdgeInsets.all(12),
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
                            padding: EdgeInsets.all(12),
                            child: Text(
                              Tran.of(context)?.text("confirm"),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_pwformKey.currentState.validate()) {
                              widget.bill.remark = _remarkController.text;
                              widget.bill.payDate =
                                  Timestamp.fromDate(DateTime.now());
                              await context
                                  .read<WalletProvider>()
                                  .payMeterBill(context, widget.bill);
                              Navigator.of(context).pop();
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

  String getPayDate(DateTime date) {
    var dateFormat = DateFormat("yyyy-MM-dd"); // you can change the format here
    return dateFormat.format(date);
  }
}
