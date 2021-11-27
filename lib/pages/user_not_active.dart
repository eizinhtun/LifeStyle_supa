// @dart=2.9
import 'package:flutter/material.dart';
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
                  "The user is not active.",
                  style: TextStyle(fontSize: 20, color: Colors.pink),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Login with another acount OR Contact Admin",
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
                    "Log out",
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
