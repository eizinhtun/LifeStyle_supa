// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/models/meter_page_obj.dart';
import 'package:left_style/services/meter_api.dart';

abstract class MeterContract {
  void showError(String text);
  void showMessage(String text);
  void onFirstLoadSuccess(MeterPageObj page);
  void onRefreshSuccess(MeterPageObj page);
  void onLoadMoreSuccess(MeterPageObj page);
  void onDeleteSuccess(bool result);
}

class MeterPresenter {
  MeterContract _view;
  MeterApi api;
  MeterPresenter(MeterContract classObj, BuildContext context) {
    this._view = classObj;
    api = new MeterApi(context);
  }

  loadData({
    String action,
    String apiUrl,
    String searchKey,
  }) async {
    api
        .searchMeter(
      apiUrl: apiUrl,
      searchKey: searchKey,
    )
        .then((page) {
      if (page != null) {
        _view.onFirstLoadSuccess(page);
      } else {
        _view.showError("no_data");
      }
    }).catchError((error) {
      String msg = error.toString();
      try {
        msg = msg.replaceAll("Exception:", "");
      } catch (error) {}
      _view.showError(msg);
    });
  }
}
