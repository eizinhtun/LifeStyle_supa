// // @dart=2.9
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:left_style/datas/constants.dart';

// class WalletProvider with ChangeNotifier, DiagnosticableTreeMixin {
//   var tracRef = FirebaseFirestore.instance.collection(transactions);
//   var userRef = FirebaseFirestore.instance.collection(userCollection);

//   Future<void> topup(BuildContext context, double amount) async {
//     if (FirebaseAuth.instance.currentUser?.uid != null) {
//       String uid = FirebaseAuth.instance.currentUser.uid.toString();
//       QuerySnapshot snaptData =
//           await userRef.where('uid', isEqualTo: uid).get();
//       if (snaptData.docs.length > 0) {
//         return true;
//       } else {
//         return false;
//       }
//       tracRef
//           .add({
//             "uid": user.uid,
//             "full_name": user.displayName,
//             "email": user.email,
//             "phone": user.phoneNumber,
//             "photo": user.photoURL
//           })
//           .then((value) => print("User Added $value"))
//           .catchError((error) => print("Failed to add user: $error"));
//     }
//     notifyListeners();
//   }
// }
