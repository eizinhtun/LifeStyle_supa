// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/models/user_model.dart';
import 'package:left_style/providers/login_provider.dart';
import 'package:left_style/validators/validator.dart';
import 'package:provider/provider.dart';
class ScanQRData extends StatefulWidget {
  const ScanQRData({Key key,this.qrcodeuid}) : super(key: key);
  final String qrcodeuid;

  @override
  _ScanQRDataState createState() => _ScanQRDataState(qrcodeuid: this.qrcodeuid);
}

class _ScanQRDataState extends State<ScanQRData> {

  final _transferformKey = GlobalKey<FormState>();
  TextEditingController _transferController= TextEditingController();
  UserModel user=UserModel();
  final String qrcodeuid;
  _ScanQRDataState({this.qrcodeuid});

  @override
  void initState() {
    super.initState();
    getUser();
  }
  Future<UserModel> getUser() async {
    user= await context.read<LoginProvider>().getUserScanData(context,qrcodeuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(color: Colors.black),
                      backgroundColor: Colors.blue,
                      pinned: true,
                      snap: false,
                      floating: false,
                      expandedHeight: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.vertical(
                          bottom: new Radius.elliptical(200, 56.0),
                        ),
                      ),

                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: Container(),
                      ),

                    ),
                    SliverToBoxAdapter(
                      child: Container(
                          constraints: BoxConstraints.expand(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                          ),
                          child: Container(

                          )
                      ),
                    ),
                  ],
                ),

                Positioned(
                  top: 100,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: MediaQuery.of(context).size.height - 100,
                    width: MediaQuery.of(context).size.width - 30,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            elevation: 10,
                            child: Container(
                              // padding:
                              //     EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                                        child: user.fullName !=null ?Text(user.fullName.toUpperCase(),style: TextStyle(fontSize: 18,color: Colors.grey)):Text("loading..."),
                                      ),
                                      Container(
                                        child: Form(
                                          key: _transferformKey,
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: Colors.transparent,
                                                  ),
                                                  child: TextFormField(
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    controller: _transferController,
                                                    keyboardType: TextInputType.number,
                                                    validator: (val) {
                                                      return Validator.requiredField(
                                                          context, val, "transfer amount");
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Transfer Amount',
                                                    ),
                                                  )),

                                            ],
                                          ),
                                        ),

                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}
