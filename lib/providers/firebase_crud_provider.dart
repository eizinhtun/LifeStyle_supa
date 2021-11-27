/*
// @dart=2.9
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/test_model.dart';
import 'package:left_style/utils/message_handler.dart';

class FirebaseCRUDProvider with ChangeNotifier, DiagnosticableTreeMixin {
  // final CollectionReference userRef = FirebaseFirestore.instance.collection(userCollection);
  //String uid = FirebaseAuth.instance.currentUser.uid.toString();
  var testRef = FirebaseFirestore.instance.collection(testCollection);
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  var balance;
  var random = new Random();
  var testData;
  List getData = [];
  Map<String, dynamic> dataMap;

  // Future<List<TestModel>> getItemData(BuildContext context) async {
  //
  //   List<TestModel> list = [];
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid;
  //     testRef.doc("$uid").snapshots().where((event){
  //
  //     });
  //     // await testRef.where("uid", isEqualTo: uid).get().then((value) {
  //     //   value.docs.forEach((result) {
  //     //     
  //     //     list.add(TestModel.fromJson(result.data()));
  //     //   });
  //     // });
  //   }
  //   notifyListeners();
  //   return list;
  //
  // }
  // Future<void> addItem(BuildContext context) async {
  //   int randomNumber = random.nextInt(100);
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid.toString();
  //     try {
  //       TestModel testModel = TestModel(
  //           uid: uid,
  //           fullName: "pyaepaye",
  //           email: "pyaepye@gmail.com",
  //           address: "Dawei"
  //       );
  //       testRef.doc("$uid").set({"data$randomNumber": testModel.toJson()},SetOptions(merge: true)).then((value) {
  //         
  //         MessageHandler.showMessage(
  //             context, "Success", "Updating User Info is successful");
  //       });
  //       // testRef.doc("$uid").collection("userData").add({"data$randomNumber": testModel.toJson()}).then((value) {
  //       //   
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       notifyListeners();
  //     } catch (e) {
  //       
  //       MessageHandler.showErrMessage(
  //           context, "Fail", "Updating User Info is fail");
  //     }
  //   }
  //   //notifyListeners();
  //
  // }
  //
  //
  // Future<void> updateItem(BuildContext context) async{
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid.toString();
  //     try {
  //       TestModel testModel = TestModel(
  //           uid: uid,
  //           fullName: "pyaepayevvvvvvvvvvv",
  //           email: "pyaepye@gmail.com",
  //           address: "Daweivvvvvv"
  //       );
  //       // TestModel updateTestData = TestModel(
  //       //     uid: uid,
  //       //     fullName: "vvvvvvvvv",
  //       //     email: "pyaepye@gmail.com",
  //       //     address: "ffffffffff"
  //       // );
  //
  //       testRef.doc("$uid").update({"data36": testModel.toJson()}).then((_) {
  //         
  //         MessageHandler.showMessage(
  //             context, "Success", "Updating User Info is successful");
  //       });
  //       // testRef.update({"data1": testModel.toJson()}).then((_) {
  //       //   
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       notifyListeners();
  //     } catch (e) {
  //       
  //       MessageHandler.showErrMessage(
  //           context, "Fail", "Updating User Info is fail");
  //     }
  //   }
  //
  // }
  // Future<void> deleteItem(BuildContext context) async{
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid.toString();
  //     try {
  //       testRef.doc("$uid").update({
  //         "data57": FieldValue.delete()
  //       });
  //       // testRef.doc("$uid").delete({"data36":}).then((_) {
  //       //   
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       // testRef.update({"data1": testModel.toJson()}).then((_) {
  //       //   
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       notifyListeners();
  //     } catch (e) {
  //       
  //       MessageHandler.showErrMessage(
  //           context, "Fail", "Updating User Info is fail");
  //     }
  //   }
  //
  // }

  Future<void> topup(BuildContext context, String paymentType) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      userRef.doc(uid).get().then((value) {
        double balance = value.data()["balance"];
        double amount = 2000.00;

        if (balance != null) {
          try {
            userRef.doc(uid).update({"balance": balance + amount}).then((_) {
              
            });
            MessageHandler.showMessage(
                context, "Success", "Your topup is successful");
            TestModel testModel = TestModel(
                uid: uid,
                type: TransactionType.topup,
                amount: amount,
                paymentType: paymentType,
                createdDate: DateTime.now());
            testRef
                .doc("$uid")
                .collection('topup')
                .add(testModel.toJson())
                .catchError((error) {
              
            });
            notifyListeners();
          } catch (e) {
            
            MessageHandler.showErrMessage(
                context, "Fail", "Your topup is fail");
          }
        } else {
          MessageHandler.showErrMessage(context, "Fail", "Balance Type null");
        }
      });
      MessageHandler.showErrMessage(context, "Fail", "No Internet");
      notifyListeners();
    }
  }

  Future<void> withdrawl(
      BuildContext context, String paymentType, double amount) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      // double balance = await getBalance();
      userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
        double balance = value.data()["balance"];
        checkPassword(context,"22222");

        if (amount > balance) {
          MessageHandler.showErrMessage(context, "Insufficient Balance",
              "Your withdraw amount is higher than your balance");
        } else {
          try {
            userRef.doc(uid).update({"balance": balance - amount}).then((_) {
              
              MessageHandler.showMessage(
                  context, "Success", "Your withdrawl is successful");
            });
            TestModel testModel = TestModel(
                uid: uid,
                type: TransactionType.withdraw,
                amount: amount,
                paymentType: paymentType,
                createdDate: DateTime.now());
            testRef
                .doc("$uid")
                .collection("withdraw")
                .add(testModel.toJson())
                .catchError((error) {
              
            });
            notifyListeners();
          } catch (e) {
            
            MessageHandler.showErrMessage(
                context, "Fail", "Your withdrawl is fail");
          }
        }
      });
    }
    notifyListeners();
  }

  Future<void> checkPassword(BuildContext context, String password) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      userRef.doc(uid).get().then((value) {
        String oldPassword = value.data()["password"];
        var isCorrect = new DBCrypt().checkpw(password, oldPassword);
        if (isCorrect == true) {
          double balance = value.data()["balance"];
          double amount = 200.00;
          if (amount > balance) {
            MessageHandler.showErrMessage(context, "Insufficient Balance",
                "Your withdraw amount is higher than your balance");
          } else {
            userRef.doc(uid).update({"balance": balance - amount}).then((_) {
              // MessageHandler.showMessage(
              //     context, "Success", "Your withdrawl is successful");
              notifyListeners();
            });
            TestModel testModel = TestModel(
                uid: uid,
                type: TransactionType.withdraw,
                amount: amount,
                paymentType: PaymentType.kpay,
                createdDate: DateTime.now());
            testRef
                .doc("$uid")
                .collection("withdraw")
                .add(testModel.toJson())
                .catchError((error) {
              
            });
            MessageHandler.showMessage(
                context, "Success", "Your withdrawl is successful");
            notifyListeners();
          }
          //MessageHandler.showMessage(context, "Success", "Your Password is successful");
          // notifyListeners();
        } else {
          
          MessageHandler.showErrMessage(context, "Fail", "Password is fail");
        }
      });
      MessageHandler.showErrMessage(context, "Fail", "No Internet");
      notifyListeners();
    }
  }

  // Future<List<TransactionModel>> getTransactionList(
  //     BuildContext context) async {
  //   List<TransactionModel> list = [];
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid;
  //     await testRef.doc("$uid").collection("topup").where("uid", isEqualTo: uid).get().then((value) {
  //       value.docs.forEach((result) {
  //         
  //         list.add(TransactionModel.fromJson(result.data()));
  //       });
  //     });
  //   }
  //   notifyListeners();
  //   return list;
  // }

}
*/
