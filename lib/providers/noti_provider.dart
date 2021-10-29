// @dart=2.9
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/datas/system_data.dart';
import 'package:left_style/models/noti_model.dart';
import 'package:http/http.dart' as http;

class NotiProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var notiRef = FirebaseFirestore.instance.collection(notifications);
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  Future<List<NotiModel>> getNotiList(BuildContext context) async {
    List<NotiModel> list = [];
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      await notiRef.doc(uid).collection(notilist).get().then((value) {
        value.docs.forEach((result) {
          print(result.data());
          list.add(NotiModel.fromJson(result.data()));
        });
      });
    }
    notifyListeners();
    return list;
  }

  Future<void> addNotiToStore(NotiModel noti) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser?.uid;
      await notiRef
          .doc(uid)
          .collection(notilist)
          .doc(noti.messageId)
          .set(noti.toJson());
      notifyListeners();
    }
    notifyListeners();
  }

  Future<NotiModel> getNotiById(BuildContext context, String id) async {
    NotiModel noti = NotiModel();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser?.uid;
      await notiRef
          .doc(uid)
          .collection(notilist)
          .where("message_id", isEqualTo: id)
          .get()
          .then((value) {
        noti = NotiModel.fromJson(value.docs.first.data());
      });
      notifyListeners();
      return noti;
    }
    notifyListeners();
    return noti;
  }

  Future<void> sendNoti(BuildContext context) async {
    // NotiModel notiModel = NotiModel(title:'this is a title',body:'this is a body',  );
    try {
      await userRef.get().then((value) {
        value.docs.forEach((result) async {
          http.Response response = await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: json.encode(
              <String, dynamic>{
                'notification': <String, dynamic>{
                  'body': 'this is a body',
                  'title': 'this is a title'
                },
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done'
                },
                'to': result.data()['fcmtoken'],
              },
            ),
          );
          print(response.statusCode);
          print(response.body);
        });
      });
    } catch (e) {
      print("error push notification");
    }
    notifyListeners();
  }

  int updateNotiCount(BuildContext context, int count) {
    SystemData.notiCount = count;
    notifyListeners();
    return count;
  }
}
