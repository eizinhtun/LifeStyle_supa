// @dart=2.9
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:left_style/utils/network_util.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/meter_model.dart';
import 'package:left_style/models/meter_page_obj.dart';
import 'package:left_style/utils/show_message_handler.dart';

class MeterApi {
  BuildContext context;
  MeterApi(this.context);

  NetworkUtil _netUtil = NetworkUtil();

  Future<MeterPageObj> searchMeter({
    String apiUrl,
    String searchKey,
  }) async {
    //String lang=await DatabaseHelper.getData(DataKeyValue.language);
    searchKey = (searchKey == null || searchKey == "null") ? "" : searchKey;

    String signature = searchKey + secretkey;
    String signatureKey =
        md5.convert(signature.codeUnits).toString().toUpperCase();
    String url = apiUrl + searchKey + "&signature=$signatureKey";

    var myHeaders = await getHeadersWithOutToken();
    http.Response response = await _netUtil.get(this.context, url, null);
    if (response != null) {
      if (response.statusCode == 200) {
        MeterPageObj objpage = MeterPageObj();
        objpage.rowCount = 0;
        var obj = json.decode(response.body);
        if (obj != null) {
          List<dynamic> list = jsonDecode(obj);
          objpage.results = [];
          for (var item in list) {
            objpage.results.add(Meter.fromJson(item));
          }

          objpage.pageIndex = 1;
          objpage.pageSize = objpage.results.length;
          objpage.rowCount = objpage.pageSize;

          return objpage;
        } else {
          var errorMsg = obj["message"];
          ShowMessageHandler.showMessage(context, "Error", errorMsg);
          return null;
        }
      }
    }
    return null;
  }
}
