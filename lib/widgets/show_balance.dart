// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/wallet/topup_page.dart';
import 'package:left_style/pages/wallet/withdrawal_page.dart';
import 'package:left_style/utils/formatter.dart';

class ShowBalance extends StatelessWidget {
  ShowBalance(
      {Key key,
      @required this.onTopuped,
      @required this.onWithdrawed,
      this.color = Colors.black38,
      this.walletColor = Colors.white,
      this.showIconColor = Colors.pink})
      : super(key: key);
  final ValueSetter<bool> onTopuped; //= (value) {};
  final ValueSetter<bool> onWithdrawed; // = (value) {};
  final Color color;
  final Color walletColor;
  final Color showIconColor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(userCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (snapshot.hasData) {
          UserModel _user = UserModel.fromJson(snapshot.data.data());
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection(userCollection)
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .update({"showBalance": !_user.showBalance});
                  },
                  icon: Icon(
                    Icons.account_balance_wallet,
                    color: walletColor,
                    size: 35,
                  ),
                  label: Row(
                    children: [
                      Text(
                        "${_user.showBalance ? Formatter.balanceFormat(_user.balance) : Formatter.balanceUnseenFormat(_user.balance)} ${Tran.of(context).text("ks")}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: color),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            _user.showBalance
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 15,
                            color: showIconColor,
                          ),
                        ),
                      ),
                    ],
                  )),
              PopupMenuButton(
                  onSelected: (val) async {
                    if (val == 1) {
                      var result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TopUpPage()));
                      onTopuped(result);
                      /*if (result != null && result == true) {
                        _isLoading = true;
                        _onRefresh();
                      }*/
                    }
                    if (val == 2) {
                      var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => WithdrawalPage()));
                      onWithdrawed(result);
                      /*if (result != null && result == true) {
                        _isLoading = true;
                        _onRefresh();
                      }*/
                    }
                  },
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: color,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 10, bottom: 10),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  Text(Tran.of(context).text("topup")),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 10, bottom: 10),
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  Text(Tran.of(context).text("withdrawal")),
                                ],
                              ),
                              Divider()
                            ],
                          ),
                          value: 2,
                        )
                      ]),
            ],
          );
        } else {
          return Text(Tran.of(context).text("no_data_found"));
        }
      },
    );
  }

  Widget getUnseen(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.add, size: 14),
          ),
          WidgetSpan(
            child: Icon(Icons.add, size: 14),
          ),
          WidgetSpan(
            child: Icon(Icons.add, size: 14),
          ),
          WidgetSpan(
            child: Icon(Icons.add, size: 14),
          ),
        ],
      ),
    );
  }
}
