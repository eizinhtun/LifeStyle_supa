// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/hotline_model.dart';

class HotlineProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var hotlineRef = FirebaseFirestore.instance.collection(hotlineCollection);
  List<HotlineModel> get items => _items;
  List<HotlineModel> _items = [];

  bool _isloading = false;
  bool get isloading => _isloading;

  Future<List<HotlineModel>> getHotlineServices(BuildContext context) async {
    _isloading = true;
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      _items = [];
      await hotlineRef.get().then((value) {
        value.docs.forEach((result) {
          _items.add(HotlineModel.fromJson(result.data()));
        });
      });
    }
    _isloading = false;
    notifyListeners();
    return _items;
  }
}
