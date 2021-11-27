// @dart=2.9

import 'package:left_style/models/meter_model.dart';

class MeterPageObj {
  List<Meter> results = [];
  int rowCount = 0;
  int pageIndex;
  int pageSize;

  MeterPageObj({this.results, this.rowCount, this.pageIndex, this.pageSize});

  MeterPageObj.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results.add(new Meter.fromJson(v));
      });
    }
    rowCount = json['totalRows'];
    pageIndex = json['pageNumber'];
    pageSize = json['rowsOfPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['totalRows'] = this.rowCount;
    data['pageNumber'] = this.pageIndex;
    data['rowsOfPage'] = this.pageSize;
    return data;
  }
}
