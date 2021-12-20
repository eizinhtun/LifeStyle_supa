// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/payment_method.dart';

class PaymentMethodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My uploaded unit',
      home: PaymentMethodListPage(),
    );
  }
}

class PaymentMethodListPage extends StatefulWidget {
  const PaymentMethodListPage({Key key}) : super(key: key);

  @override
  PaymentMethodListPageState createState() => PaymentMethodListPageState();
}

class PaymentMethodListPageState extends State<PaymentMethodListPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(Tran.of(context).text("payment_method_list")),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection(paymentMethodCollection).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data.docs.map((doc) {
                PaymentMethod item = PaymentMethod.fromJson(doc.data());
                return Card(
                  margin: const EdgeInsets.only(
                      top: 0, left: 5, right: 5, bottom: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 1,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Navigator.of(context).pop(item);
                        },
                        contentPadding: const EdgeInsets.only(
                            top: 10.0, left: 0.0, right: 0.0, bottom: 10.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              alignment: Alignment.center,
                              width: 60,
                              height: 60,
                              child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage: CachedNetworkImageProvider(
                                    item.logoUrl,
                                  )
                                  // NetworkImage(
                                  //   item.logoUrl,
                                  // ),
                                  ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                )),
                          ],
                        ),
                        dense: true,
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
        },
      ),
    );
  }

  // @override
  // void showError(String text) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text(Tran.of(context).text(text))));
  // }

  // @override
  // void showMessage(String text) {
  //   ShowMessageHandler.showMessage(context, "", text);
  // }
}
