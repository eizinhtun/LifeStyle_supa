// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/localization/Translate.dart';
import 'package:left_style/models/Meter.dart';
import 'package:left_style/models/MeterCity.dart';
import 'package:left_style/models/MeterPageObj.dart';
import 'package:left_style/providers/meter_presenter.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_dash/flutter_dash.dart';
/*import 'package:userthai2d3d/data/database_helper.dart';
import 'package:userthai2d3d/localization/Translate.dart';
import 'package:userthai2d3d/data/sys_data.dart';
import 'package:userthai2d3d/models/Meter.dart';
import 'package:userthai2d3d/models/MeterPageObj.dart';
import 'package:userthai2d3d/page/topup/tutorialVideoPage.dart';
import 'package:userthai2d3d/page/transcationHistoryDeniedPage.dart';
import 'package:userthai2d3d/page/transcationHistoryPendingPage.dart';
import 'package:userthai2d3d/page/transcationHistorySuccessPage.dart';
import 'package:userthai2d3d/provider/transaction_presenter.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:userthai2d3d/utils/MessageHandel.dart';
import 'package:flutter_dash/flutter_dash.dart';*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  class MeterCityPage extends StatefulWidget {
  @override
  _MeterCityPageState createState() => _MeterCityPageState();
  }

  class _MeterCityPageState extends State<MeterCityPage> {

    TextEditingController _searchController = TextEditingController();
    Future resultsLoaded;
    List _allResults = [];
    List _resultsList = [];
    final db = FirebaseFirestore.instance;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select City"),
        centerTitle: true,
      ),
      body: Column(
        children: [
       /*   Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: TextField(
              onChanged: (value) {
              //  searchKey=value;
                setState(() {

                });
              },
             controller: _searchController,
              decoration: InputDecoration(
                  //labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(0.0),
                  border: OutlineInputBorder(
                      gapPadding:0,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            ),
          ),*/
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('citys').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return

                    ListView(
                    children: snapshot.data.docs.map((doc) {
                      return Card(
                        child: ListTile(
                          onTap: (){
                            var url=doc.get("apiUrl");
                            Navigator.pop(context,url);
                          },
                          title: Text(doc.get("name")+" - "+doc.get("name_"+SystemData.language)),
                        ),
                      );
                    }).toList(),
                  );
                   /* ListView.builder(
                      itemCount: _resultsList.length,
                      itemBuilder: (BuildContext context, int index) =>
                         Card(
                    child: ListTile(
                    title: Text(_resultsList[index]("name")+" - "+_resultsList[index]("name_"+SystemData.language)),
                ),
                ),
                    );*/



              },
            ),
          ),
        ],
      ),
    );
  }
}
