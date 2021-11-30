// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:left_style/localization/translate.dart';

class MeterCityPage extends StatefulWidget {
  @override
  _MeterCityPageState createState() => _MeterCityPageState();
}

class _MeterCityPageState extends State<MeterCityPage> {
  // TextEditingController _searchController = TextEditingController();
  Future resultsLoaded;
  // List _allResults = [];
  // List _resultsList = [];
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Tran.of(context).text("select_city"),
        ),
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
                  return ListView(
                    children: snapshot.data.docs.map((doc) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            var url = doc.get("apiUrl");
                            Navigator.pop(context, url);
                          },
                          title: Text(doc.get("name") +
                              " - " +
                              doc.get("name_" + SystemData.language)),
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
