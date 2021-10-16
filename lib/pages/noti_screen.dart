import 'package:flutter/material.dart';
import 'package:left_style/providers/noti_provider.dart';
import 'package:provider/provider.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({Key? key}) : super(key: key);

  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "Notification",
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
                    onPressed: () async {
                      // await context.read<NotiProvider>().sendNoti(context);
                    },
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
}
