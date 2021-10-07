
import 'package:flutter/material.dart';
import 'package:left_style/Test/auth.dart';
class AuthLogin extends StatefulWidget {
  const AuthLogin({Key? key}) : super(key: key);

  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  Services auth=Services();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(onPressed: ()async{
       final result= await auth.signInAnon();
       if(result != null){
         print("connect Succes");
         print(result);
       }
       else{
         print("fail");
       }


      },child: Text("anonyme"),),
    );
  }
}
