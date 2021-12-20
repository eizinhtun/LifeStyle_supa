// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/intro_model.dart';

class IntroProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var introRef = FirebaseFirestore.instance.collection(introCollection);
  List<IntroModel> get items => _items;
  List<IntroModel> _items = [];

  bool _isloading = false;
  bool get isloading => _isloading;

  Future<List<IntroModel>> getIntros(BuildContext context) async {
    _isloading = true;
    _items = [];
    await introRef.get().then((value) {
      value.docs.forEach((result) {
        if (result.data()['isActive']) {
          _items.add(IntroModel.fromJson(result.data()));
        }
      });
    });

    _isloading = false;
    notifyListeners();
    return _items;
  }
}
