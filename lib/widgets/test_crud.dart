// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/test_model.dart';
import 'package:left_style/providers/firebase_crud_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<TestModel> totalList = [];
  List<TestModel> tracList = [];
  //var uid= "gCmb5iDIH7PpL6NQgnPeyK0oJBu1";

  int end = 10;
  static int i = 1;
  final _passwordformKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
                backgroundColor: Color(0xfffa2e73),
                // Colors.blue,
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
              ),
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height,
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(onPressed: () async {
                        //   await context.read<FirebaseCRUDProvider>().addItem(context);
                        //   setState(() {
                        //
                        //   });
                        // }, child: Text("Add Item")),
                        // ElevatedButton(onPressed: () async {
                        //   await context.read<FirebaseCRUDProvider>().updateItem(context);
                        //   setState(() {
                        //
                        //   });
                        // },
                        //     child: Text("Update Item")),
                        //
                        // ElevatedButton(onPressed: () async {
                        //   await context.read<FirebaseCRUDProvider>().deleteItem(context);
                        //   setState(() {
                        //
                        //   });
                        // },
                        //     child: Text("Delete Item")),
                        ElevatedButton(
                            onPressed: () async {
                              await context
                                  .read<FirebaseCRUDProvider>()
                                  .topup(context, PaymentType.kpay);
                            },
                            child: Text("Topup")),
                        ElevatedButton(
                            onPressed: () async {
                              _showSimpleDialog(context);
                              setState(() {});
                            },
                            child: Text("Withdrawal")),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  _showSimpleDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text('Enter Password'),
          children: [
            SimpleDialogOption(
              child: Form(
                key: _passwordformKey,
                child: Column(
                  children: [
                    Container(
                      width: 230,
                      height: 100,
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        obscureText: _obscureText,
                        validator: (val) {
                          return Validator.password(
                              context, val.toString(), "Password", true);
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
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
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close")),
                        SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: () async {
                              await context
                                  .read<FirebaseCRUDProvider>()
                                  .checkPassword(
                                      context, _passwordController.text);
                              Navigator.of(context).pop();
                            },
                            child: Text("Confirm")),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // SimpleDialogOption(
            //   child: Text('Option 2'),
            //   onPressed: (){
            //     // Do something
            //     print('You have selected the option 2');
            //     Navigator.of(context).pop();
            //   },
            // )
          ],
        );
      },
    );
  }
}
