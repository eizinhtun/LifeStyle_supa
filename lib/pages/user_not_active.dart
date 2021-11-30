// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:provider/provider.dart';

class UserNotActiveScreen extends StatefulWidget {
  const UserNotActiveScreen({Key key}) : super(key: key);

  @override
  _UserNotActiveScreenState createState() => _UserNotActiveScreenState();
}

class _UserNotActiveScreenState extends State<UserNotActiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Tran.of(context).text("user_not_active"),
                  style: TextStyle(fontSize: 20, color: Colors.pink),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Tran.of(context).text("login_with_another"),
                  style: TextStyle(fontSize: 14, color: Colors.pink),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<LoginProvider>().logOut(context);
                  },
                  child: Text(
                    Tran.of(context).text("log_out"),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
