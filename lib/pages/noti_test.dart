// @dart=2.9
import 'package:flutter/material.dart';

class NotiTest extends StatefulWidget {
  const NotiTest({Key key}) : super(key: key);

  @override
  _NotiTestState createState() => _NotiTestState();
}

class _NotiTestState extends State<NotiTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "Notification Test",
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 0.0,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {},
                    child: Text("Send Notification"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendScheduleNotification(BuildContext context) {}
}
