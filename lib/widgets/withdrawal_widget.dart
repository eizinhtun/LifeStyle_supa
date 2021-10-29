// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/payment_method.dart';
import 'package:left_style/pages/payment_method_list.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({Key key}) : super(key: key);

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final _withdrawformKey = GlobalKey<FormState>();
  final _passwordformKey= GlobalKey<FormState>();
  PaymentMethod _paymentMethod;
  TextEditingController _paymentController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;


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
            child: Text("Withdraw"),
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
                  key: _withdrawformKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                          )
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          return Validator.requiredField(context, val, '');
                        },
                        decoration: buildInputDecoration("Withdraw Amount"),
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
                                if (_withdrawformKey.currentState.validate()) {
                                  print("Validate");
                                  _ShowPasswordAlertDialog(
                                      context,
                                      _paymentMethod.id,
                                      _amountController.text);
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

  _ShowPasswordAlertDialog(BuildContext context, paymentType, amount) {
 showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(

          builder: (BuildContext context, setState) =>
              Padding(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text("Enter Password", style: TextStyle(fontSize: 16)),
                      Center(
                        child: Text(
                          "Enter Your Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          autofocus: true,
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
                                "Confirm",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              print( _passwordController.text);
                              if(_withdrawformKey.currentState.validate()){
                                await context
                                    .read<WalletProvider>()
                                    .withdrawlCheckPassword(
                                    context,
                                    paymentType,
                                    int.parse(amount),
                                    _passwordController.text);
                              }

                              // if (_pwformKey.currentState.validate()) {
                              //   // widget.bill.isPaid = true;
                              //   widget.bill.remark = _remarkController.text;
                              //   widget.bill.status = "Paid";
                              //   widget.bill.payDate = getPayDate(DateTime.now());
                              //   print(widget.bill.readDate);
                              //   print(widget.bill.readImageUrl);
                              //   print(widget.bill.toJson());
                              //   await context.read<WalletProvider>().payMeterBill(
                              //       context, widget.bill, widget.docId);
                              // }
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
                                "Close",
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
                        ],
                      ),

                    ],
                  ),
                ),
              ),
        );
      },
    );
  }

  ShapeBorder _defaultShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.deepOrange,
      ),
    );
  }
}
