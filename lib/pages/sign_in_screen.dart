import 'package:flutter/material.dart';
import 'package:left_style/res/custom_colors.dart';
import 'package:left_style/widgets/profile_image.dart';
import 'package:left_style/widgets/wallet.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // bool _isLoggedIn = false;
  // Map _userObj = {};
  var _imageUrl =
      "https://image.freepik.com/free-psd/stationery-dark-copper-mockup_23-2149052439.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                child: Text("click me"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wallet()));
                },
              ),
              ProfileImage(
                onChanged: (url) {
                  _imageUrl = url;
                  setState(() {});
                },
                width: 80,
                height: 80,
                borderColor: Colors.white,
                imageurl: _imageUrl,
              ),
              /*FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.firebaseOrange,
                    ),
                  );
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
