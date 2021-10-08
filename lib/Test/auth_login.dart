
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:left_style/Test/auth.dart';
import 'package:left_style/datas/constants.dart';
class AuthLogin extends StatefulWidget {
  const AuthLogin({Key? key}) : super(key: key);

  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final Services auth=Services();
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: RaisedButton(onPressed: ()async{
      //  dynamic result= await auth.signInAnon();
      //  if(result != null){
      //    print("connect Succes");
      //    print(result);
      //  }
      //  else{
      //    print("fail");
      //  }
      //
      //
      // },child: Text("anonyme"),),
      //child: RaisedButton(onPressed: (){createUser();},child: Text("click"),),

      child: RaisedButton(onPressed: (){

      },child: Text("login with facebook"),),
    );
  }
}
void createUser() async {
  Services auth=Services();

  final result= await auth.signInAnon();
  FirebaseFirestore.instance.collection('test').doc('t1').set({
    'uid': result,
    'name': 'pyaepyae',
    'phone': '076554479'
  });
}