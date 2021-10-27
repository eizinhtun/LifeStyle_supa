// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/test_model.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/validators/validator.dart';
import 'package:left_style/widgets/wallet.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({Key key}) : super(key: key);

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final _withdrawformKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool viewVisible = false;

  String pay = "";
  double kbzOpacity = 0.5;
  double cbOpacity = 0.5;
  double waveOpacity = 0.5;
  String paymentType = PaymentType.KPay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.blue,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 0.0,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200))),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: Container(),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await context.read<LoginProvider>().logOut(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.logout))
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
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
                        margin: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Please select a bank to top up"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    paymentType = PaymentType.KPay;
                                    showWidget();

                                    pay = "KBZ Pay";
                                    kbzOpacity = 1;
                                    cbOpacity = 0.5;
                                    waveOpacity = 0.5;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black
                                                  .withOpacity(kbzOpacity),
                                              BlendMode.dstATop),
                                          image: AssetImage(
                                              "assets/payment/kbzpay.png")),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      // color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    paymentType = PaymentType.CbPay;
                                    showWidget();
                                    pay = "CB Pay";
                                    kbzOpacity = 0.5;
                                    cbOpacity = 1;
                                    waveOpacity = 0.5;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black
                                                  .withOpacity(cbOpacity),
                                              BlendMode.dstATop),
                                          image: AssetImage(
                                              "assets/payment/cbpay.png")),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      // color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    paymentType = PaymentType.WavePay;
                                    showWidget();
                                    pay = "WAVE Pay";
                                    kbzOpacity = 0.5;
                                    cbOpacity = 0.5;
                                    waveOpacity = 1;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black
                                                  .withOpacity(waveOpacity),
                                              BlendMode.dstATop),
                                          image: AssetImage(
                                              "assets/payment/wavepay.png")),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      // color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  _showWithdrawal(pay),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _showWithdrawal(String pay) => Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: viewVisible,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _withdrawformKey,
          child: Column(
            children: [
              Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent,
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      return Validator.requiredField(
                          context, val, "withdraw amount");
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Transfer Amount',
                    ),
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 10,
                        bottom: 10,
                      ) // foreground
                      ),
                  onPressed: () async {
                    if (_withdrawformKey.currentState.validate()) {
                     _ShowAlertDialog(context,double.parse(_amountController.text.toString()),paymentType);

                      _amountController.clear();
                    }
                  },
                  child: Text("Confirm")),
            ],
          ),
        ),
      ));
  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  _ShowAlertDialog(BuildContext context,amount,paymentType) {
    return showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
            backgroundColor:Colors.white,
            shape: _defaultShape(),
            insetPadding: EdgeInsets.all(20),
            elevation: 10,
            titlePadding: const EdgeInsets.all(0.0),
            title: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black12, width: 3)),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                              children: [
                                _getCloseButton(context),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text("Enter Password",textAlign: TextAlign.center,style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ),
                      //_getCloseButton(context),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: _passwordController,
                                obscureText: _obscureText,
                                validator: (val) {
                                  return Validator.password(
                                      context,
                                      val.toString(),
                                      "Password",
                                      true);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                    "Password",
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
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400])),
                                //keyboardType: TextInputType.number,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(onPressed: () async {

                                  await context.read<WalletProvider>().withdrawlCheckPassword(context, paymentType,
                                      amount,_passwordController.text);

                                }, child: Text("Yes")),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          alignment: FractionalOffset.topLeft,
          child: GestureDetector(child: Icon(Icons.clear,color: Colors.red,),

            onTap: (){
              Navigator.pop(context);
            },),
        ),
      ),
    );
  }

}
