// @dart=2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/meter_bill.dart';
import 'package:left_style/providers/meter_bill_provider.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/validators/validator.dart';
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
              elevation: 10,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Meter Unit :",
                              style: style,
                            ),
                            Text(
                              NumberFormat('#,###,000')
                                      .format(widget.bill.unitsToPay) +
                                  " Unit",
                              style: style,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.black26,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Meter Bill :",
                              style: style,
                            ),
                            Text(
                              NumberFormat('#,###,000')
                                      .format(widget.bill.totalCost) +
                                  " Ks",
                              style: style,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.0, color: Colors.grey[400]),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: TextField(
                          autofocus: true,
                          maxLines: null,
                          // expands: true,
                          controller: _remarkController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            // labelText: "Remark",
                            // floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText: "Enter your remark",
                            hintStyle: TextStyle(),
                            contentPadding: EdgeInsets.all(16),
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        validator: (val) {
                          return Validator.password(
                              context, val.toString(), "Password", true);
                        },
                        decoration: InputDecoration(
                          labelText: "${Tran.of(context)?.text('password')}",
                          labelStyle: TextStyle(),
                          hintText: "${Tran.of(context)?.text('password')}",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(_obscureText
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
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await context.read<WalletProvider>().payMeterBill(
                                context, widget.bill.totalCost.toDouble());
                            //   .then((value) async {
                            // print(value);
                            // if (value) {
                            widget.bill.isPaid = true;
                            widget.bill.remark = _remarkController.text;
                            widget.bill.status = "Paid";
                            widget.bill.payDate = getPayDate(DateTime.now());
                            print(widget.bill.isPaid);
                            print(widget.bill.remark);
                            print(widget.bill.payDate);
                            await context
                                .read<MeterBillProvider>()
                                .updateMeterBill(
                                    context, widget.bill, widget.docId);
                            // }
                            // });
                          }
                        },
                        child: Text(
                          "${Tran.of(context)?.text("pay_bill")}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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

  String getPayDate(DateTime date) {
    var dateFormat = DateFormat("yyyy-MM-dd"); // you can change the format here
    return dateFormat.format(date);
  }
}
