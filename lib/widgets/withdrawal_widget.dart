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
            child: Text("Wallet"),
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

  _ShowPasswordAlertDialog(BuildContext context, amount, paymentType) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) =>
            AlertDialog(
            backgroundColor: Colors.white,
            shape: _defaultShape(),
            insetPadding: EdgeInsets.all(20),
            elevation: 10,
            titlePadding: const EdgeInsets.all(0.0),
            title: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      TextFormField(
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
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderSide: BorderSide(
                              //     color: Colors.black12,
                              //   ),
                              // ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              //border: InputBorder.none,
                              hintText: "Password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText =
                                    !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              hintStyle: TextStyle(color: Colors.grey[400])),
                          obscureText: _obscureText,
                          validator: (val) {
                            return Validator.password(
                                context, val.toString(), "Password", true);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
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

                              print(paymentType);
                              print(amount.toString());

                              await context
                                  .read<WalletProvider>()
                                  .withdrawlCheckPassword(
                                  context,
                                  paymentType,
                                  int.parse(amount),
                                  _passwordController.text);


                            },
                            child: Text("Confirm")),
                      ),

                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.65,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 15,
                        )),
                  ),
                ),
              ],
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
