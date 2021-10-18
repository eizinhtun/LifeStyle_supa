// @dart=2.9
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _profileformKey = GlobalKey<FormState>();
  bool _obscureText = true;
  // bool isEnabled = true;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isPhoneToken = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = FirebaseAuth.instance.currentUser.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "User Profile",
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
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(4),
                                child: Center(
                                  child: Text(
                                    "Add User Profile",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                ),
                              ),
                              Form(
                                key: _profileformKey,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: TextFormField(
                                          // enabled: isEnabled,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _phoneController,
                                          validator: (val) {
                                            String phoneFormate =
                                                Validator.registerPhone(
                                                    val.toString());
                                            if (phoneFormate != null) {
                                              return phoneFormate;
                                            }
                                            String data =
                                                Validator.showPhoneToken(
                                                    isPhoneToken);
                                            if (data != "") {
                                              return data;
                                            }

                                            return null;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('phone')}",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey))),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _nameController,
                                          validator: (val) {
                                            return Validator.userName(
                                                context,
                                                val.toString(),
                                                "User Name",
                                                true);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('full_name')}",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _passwordController,
                                          obscureText: _obscureText,
                                          validator: (val) {
                                            return Validator.password(
                                                context,
                                                val.toString(),
                                                "Password",
                                                true);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('password')}",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _obscureText =
                                                        !_obscureText;
                                                  });
                                                },
                                                child: Icon(_obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _confirmPasswordController,
                                          obscureText: _obscureText,
                                          validator: (val) {
                                            return Validator.confirmPassword(
                                                context,
                                                val.toString(),
                                                _passwordController.text,
                                                "Confirm Password",
                                                true);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "${Tran.of(context)?.text('confirm_password')}",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _obscureText =
                                                        !_obscureText;
                                                  });
                                                },
                                                child: Icon(_obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minHeight: 50,
                                    minWidth: double.infinity,
                                    maxHeight: 400),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // bool isTaken = await checkPhoneIsTaken();
                                    // phone = phNoFormat();
                                    // if (!isTaken) {
                                    //   register();
                                    // }
                                    var pass = DBCrypt().hashpw(
                                        _passwordController.text,
                                        DBCrypt().gensalt());
                                    // var isCorrect = new DBCrypt().checkpw(plain, hashed);
                                    UserModel userModel = UserModel(
                                        uid: FirebaseAuth
                                            .instance.currentUser.uid,
                                        fullName:
                                            _nameController.text.toString(),
                                        phone: _phoneController.text.toString(),
                                        password: pass,
                                        isActive: true,
                                        createdDate: DateTime.now());
                                    await context
                                        .read<LoginProvider>()
                                        .addUserProfile(context, userModel);
                                  },
                                  child: Text(
                                    "Add User Profile",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
