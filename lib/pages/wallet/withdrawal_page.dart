// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/payment_method.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/pages/payment_method_list.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/utils/validator.dart';
import 'package:left_style/utils/show_message_handler.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';

import '../tutorial_video_page.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({Key key}) : super(key: key);

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final _withdrawformKey = GlobalKey<FormState>();
  final _pwformKey = GlobalKey<FormState>();
  PaymentMethod _paymentMethod;
  TextEditingController _paymentController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _transferAccountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true;
  bool _obscureText = true;
  bool _submiting = false;
  int balance = 0;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<UserModel> getUser() async {
    UserModel user = UserModel();
    user = await context.read<LoginProvider>().getUser(context);
    return user;
  }

  Future<void> upload(TransactionModel model) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      model.status = "verifying";
      model.uid = uid;
      // var result = await FirebaseFirestore.instance
      //     .collection(transactions)
      //     .doc(uid)
      //     .collection("manyTransition")
      //     .add(model.toJson());
      var result = await FirebaseFirestore.instance
          .collection(transactions)
          .add(model.toJson());
      if (result.id.isNotEmpty) {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        ShowMessageHandler.showMessage(
            context,
            Tran.of(context).text("success"),
            Tran.of(context).text("withdraw_add_success"));
      } else {
        setState(() {
          _submiting = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Container(
            margin: const EdgeInsets.only(right: 40),
            child: Text(Tran.of(context).text("withdrawal")),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.red,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 20, right: 25, left: 15, bottom: 10),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => TutorialVideoPage(
                              type: "withdraw",
                              url: SystemData.withdrawVideoLink),
                        ));
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/video.png",
                        width: 30,
                      ),
                      Text("    "),
                      Text("Click to watch",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                          )),
                      Text(" " + Tran.of(context).text("showvideo_withdrawl"),
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
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
                                          PaymentMethodListPage()));

                              if (payment != null) {
                                _paymentMethod = payment;
                                setState(() {
                                  _paymentController.text = _paymentMethod.name;
                                });
                              }
                            },
                            controller: _paymentController,
                            validator: (val) {
                              return Validator.requiredField(
                                  context,
                                  val.toString(),
                                  Tran.of(context).text("payment_method"));
                            },
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
                              hintText: Tran.of(context).text("select_payment"),
                            ),
                          )),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _transferAccountController,
                        keyboardType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return Validator.transferAccount(context, val);
                        },
                        decoration: buildInputDecoration(
                          Tran.of(context).text("transfer_account"),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          // return Validator.requiredField(context, val,
                          //     Tran.of(context).text("withdraw_amount"));
                          return Validator.withdrawAmount(
                              context,
                              Tran.of(context).text("withdraw_amount"),
                              val.toString(),
                              "1000",
                              SystemData.balance,
                              true);
                        },
                        decoration: buildInputDecoration(
                            Tran.of(context).text("withdraw_amount")),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: Colors.white24,
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 10,
                                bottom: 10,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              Tran.of(context).text("cancel"),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 10,
                                bottom: 10,
                              ),
                              // foreground
                            ),
                            onPressed: () async {
                              if (_withdrawformKey.currentState.validate()) {
                                _showPasswordAlertDialog(
                                    context,
                                    _paymentMethod.id,
                                    _amountController.text,
                                    _transferAccountController.text);
                                setState(() {
                                  _submiting = false;
                                });
                              }
                            },
                            child: Text(
                              Tran.of(context).text("submit"),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
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
      labelStyle: const TextStyle(),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  _showPasswordAlertDialog(
      BuildContext context, paymentType, amount, transferAccount) {
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
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text("Enter Password", style: const TextStyle(fontSize: 16)),
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
                  Form(
                    key: _pwformKey,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        validator: (val) {
                          return Validator.password(context, val.toString(),
                              Tran.of(context)?.text('password'), true);
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
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                        ),
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
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            primary: Colors.white24,
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 10,
                              bottom: 10,
                            ),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          Tran.of(context).text("cancel"),
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _submiting
                          ? SpinKitDoubleBounce(
                              color: Theme.of(context).primaryColor,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 10,
                                    bottom: 10,
                                  ) // foreground
                                  ),
                              onPressed: _submiting
                                  ? null
                                  : () async {
                                      if (_pwformKey.currentState.validate()) {
                                        setState(() {
                                          _submiting = true;
                                        });

                                        TransactionModel model =
                                            TransactionModel();
                                        model.paymentType = paymentType;
                                        model.type = TransactionType.Withdraw;
                                        model.amount = -int.parse(amount);
                                        model.transferAccount = transferAccount;
                                        model.createdDate =
                                            Timestamp.fromDate(DateTime.now());
                                        model.paymentLogoUrl =
                                            _paymentMethod.logoUrl;
                                        bool checkPass = await checkPassword(
                                            _passwordController.text);

                                        if (checkPass != null && checkPass) {
                                          upload(model);
                                          _submiting = false;
                                        } else {
                                          ShowMessageHandler.showErrMessage(
                                              context,
                                              Tran.of(context)
                                                  .text("can_not_edit"),
                                              Tran.of(context)
                                                  .text("pin_not_correct"));
                                        }
                                      }
                                    },
                              child: Text(Tran.of(context)?.text("submit"))),
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

  // ShapeBorder _defaultShape() {
  //   return RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(10.0),
  //     side: BorderSide(
  //       color: Colors.deepOrange,
  //     ),
  //   );
  // }
}
