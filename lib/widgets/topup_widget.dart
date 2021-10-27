// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _topupformKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  bool viewVisible = false;
  String pay = "";
  double kbzOpacity = 0.5;
  double cbOpacity = 0.5;
  double waveOpacity = 0.5;
  String paymentType;

  @override
  void initState() {
    super.initState();
    paymentType = PaymentType.kpay;
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
                                    paymentType = PaymentType.kpay;
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
                                    paymentType = PaymentType.cbpay;
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
                                    paymentType = PaymentType.wavepay;
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
                                  _showTopUp(pay),
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

  Widget _showTopUp(String pay) => Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: viewVisible,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _topupformKey,
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
                          context, val, "topup amount");
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Transfer Amount',
                    ),
                  )),
              SizedBox(height: 20),
              Text("1.Please top up at least 1000 Ks to one of the following " +
                  pay +
                  " accounts.\n2.Then click on Submit."),
              Text(
                "We only accept payment with following accounts.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
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
                    if (_topupformKey.currentState.validate()) {
                      print("Validate");
                      await context.read<WalletProvider>().topup(
                          context,
                          paymentType,
                          double.parse(_amountController.text.toString()));
                      clearText();
                    }
                  },
                  child: Text("Submit")),
            ],
          ),
        ),
      ));
  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void clearText() {
    _amountController.clear();
  }
}
