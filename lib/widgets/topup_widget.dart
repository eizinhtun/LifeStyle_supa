// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  TextEditingController _amountController = TextEditingController();
  double amount;
  var _user = FirebaseAuth.instance.currentUser;
  bool viewVisible = false;
  String pay = "";
  double kbzOpacity = 0.5;
  double cbOpacity = 0.5;
  double waveOpacity = 0.5;
  PaymentType paymentType=PaymentType.KPay;

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
                    // child: Container(
                    //   margin: EdgeInsets.only(top: 80),
                    //   width: double.infinity,
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15.0),
                    //     ),
                    //     color: Colors.white,
                    //     elevation: 10,
                    //     child: Container(
                    //       margin: EdgeInsets.all(20),
                    //       child: Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: <Widget>[
                    //           Text("Please select a bank to top up"),
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {
                    //                   paymentType=PaymentType.KPay;
                    //                   showWidget();
                    //                   pay = "KBZ Pay";
                    //                   kbzOpacity = 1;
                    //                   cbOpacity = 0.5;
                    //                   waveOpacity = 0.5;
                    //                   setState(() {});
                    //                 },
                    //                 child: Container(
                    //                   width: 80,
                    //                   height: 80,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black,
                    //                     image: DecorationImage(
                    //                         fit: BoxFit.cover,
                    //                         colorFilter: ColorFilter.mode(
                    //                             Colors.black
                    //                                 .withOpacity(kbzOpacity),
                    //                             BlendMode.dstATop),
                    //                         image: AssetImage(
                    //                             "assets/payment/kbzpay.png")),
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(8.0)),
                    //                     // color: Colors.redAccent,
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(width: 10),
                    //               InkWell(
                    //                 onTap: () {
                    //                   paymentType=PaymentType.CbPay;
                    //                   showWidget();
                    //                   pay = "CB Pay";
                    //                   kbzOpacity = 0.5;
                    //                   cbOpacity = 1;
                    //                   waveOpacity = 0.5;
                    //                   setState(() {});
                    //                 },
                    //                 child: Container(
                    //                   width: 80,
                    //                   height: 80,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black,
                    //                     image: DecorationImage(
                    //                         fit: BoxFit.cover,
                    //                         colorFilter: ColorFilter.mode(
                    //                             Colors.black
                    //                                 .withOpacity(cbOpacity),
                    //                             BlendMode.dstATop),
                    //                         image: AssetImage(
                    //                             "assets/payment/cbpay.png")),
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(8.0)),
                    //                     // color: Colors.redAccent,
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(width: 10),
                    //               InkWell(
                    //                 onTap: () {
                    //                   paymentType=PaymentType.WavePay;
                    //                   showWidget();
                    //                   pay = "WAVE Pay";
                    //                   kbzOpacity = 0.5;
                    //                   cbOpacity = 0.5;
                    //                   waveOpacity = 1;
                    //
                    //                   setState(() {});
                    //                 },
                    //                 child: Container(
                    //                   width: 80,
                    //                   height: 80,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black,
                    //                     image: DecorationImage(
                    //                         fit: BoxFit.cover,
                    //                         colorFilter: ColorFilter.mode(
                    //                             Colors.black
                    //                                 .withOpacity(waveOpacity),
                    //                             BlendMode.dstATop),
                    //                         image: AssetImage(
                    //                             "assets/payment/wavepay.png")),
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(8.0)),
                    //                     // color: Colors.redAccent,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(top: 20),
                    //             child: Column(
                    //               children: [
                    //                 _showTopUp(pay),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                  // Container(
                  //   width: double.infinity,
                  //   child: Card(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //     ),
                  //     color: Colors.white,
                  //     elevation: 10,
                  //     child: Container(
                  //       margin: EdgeInsets.all(20),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: <Widget>[
                  //           CircleAvatar(
                  //             radius: 55,
                  //             backgroundColor: Colors.transparent,
                  //             child: CircleAvatar(
                  //               radius: 50,
                  //               backgroundImage: NetworkImage(
                  //                 _user.photoURL,
                  //               ),
                  //             ),
                  //           ),
                  //           Column(
                  //             children: [
                  //               Text(
                  //                 "Balance",
                  //                 style: TextStyle(fontSize: 20),
                  //               ),
                  //               Text("20000 Ks"),
                  //             ],
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                                    paymentType=PaymentType.KPay;
                                    showWidget();

                                    pay = "KBZ Pay";
                                    kbzOpacity = 1;
                                    cbOpacity = 0.5;
                                    waveOpacity = 0.5;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 80,
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
                                    paymentType=PaymentType.CbPay;
                                    showWidget();
                                    pay = "CB Pay";
                                    kbzOpacity = 0.5;
                                    cbOpacity = 1;
                                    waveOpacity = 0.5;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 80,
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
                                    paymentType=PaymentType.WavePay;
                                    showWidget();
                                    pay = "WAVE Pay";
                                    kbzOpacity = 0.5;
                                    cbOpacity = 0.5;
                                    waveOpacity = 1;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 80,
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
        child: Column(
          children: [

            Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent,
                ),
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Transfer Amount',

                  ),
                  onChanged: (text) {
                    setState(() {
                      amount = double.parse(_amountController.text);
                    });
                  },
                )
            ),
            SizedBox(height: 20),
            Text("1.Please top up at least 1000 Ks to one of the following " +
                pay +
                " accounts.\n2.Then click on Submit."),
            Text(
              "We only accept payment with following accounts.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
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
                  clearText();
                 await context.read<WalletProvider>().topup(context,paymentType, amount);
                },
                child: Text("Submit")),
          ],
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
