// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:left_style/NetworkUtil.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/database_helper.dart';
import 'package:left_style/models/Meter.dart';
import 'package:left_style/models/MeterPageObj.dart';
import 'package:left_style/services/data_key_name.dart';
import 'package:left_style/utils/message_handler.dart';

class MeterApi {
  BuildContext context;
  MeterApi(this.context);

  NetworkUtil _netUtil = new NetworkUtil();

  Future<MeterPageObj> searchMeter(
      {String apiUrl,
      String searchKey,
      String pageIndex,
      String pageSize}) async {
    //String lang=await DatabaseHelper.getData(DataKeyValue.language);
    searchKey = (searchKey == null || searchKey == "null") ? "" : searchKey;
    String url = apiUrl + searchKey;

    var myHeaders = await getHeaders();
    http.Response response = await _netUtil.get(this.context, url, myHeaders);
    if (response != null) {
      if (response.statusCode == 200) {
        var obj = json.decode(response.body);
        if (obj != null) {
          if (searchKey == "" && pageIndex == "1") {
            var ordData = json.encode(obj);
            DatabaseHelper.setData(ordData, DataKeyValue.meters);
          }

          MeterPageObj objpage = new MeterPageObj();
          objpage.results = [];
          for (var item in obj) {
            objpage.results.add(Meter.fromJson(item));
          }

          return objpage;
        } else {
          var errorMsg = obj["message"];
          MessageHandler.showMessage(context, "Error", errorMsg);
          return null;
        }
      }
    }
    return null;
  }
}
