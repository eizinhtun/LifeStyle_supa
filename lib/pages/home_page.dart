// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/widgets/qr_code_demo.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "HomePage",
                  style: TextStyle(fontSize: 30, color: Colors.pink),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Pressed");
                    await context.read<LoginProvider>().logOut(context);
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRCodePage()));
                  
                }, child: Text("Go to QR Page"))
              ],
            ),
          ),
        ));
  }
}
