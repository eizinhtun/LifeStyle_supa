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
  List getData=[];
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
  //     //     print(result.data());
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
  //         print("Add user success!");
  //         MessageHandler.showMessage(
  //             context, "Success", "Updating User Info is successful");
  //       });
  //       // testRef.doc("$uid").collection("userData").add({"data$randomNumber": testModel.toJson()}).then((value) {
  //       //   print("Add user success!");
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       notifyListeners();
  //     } catch (e) {
  //       print("Failed to update user: $e");
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
  //         print(" Update user success!");
  //         MessageHandler.showMessage(
  //             context, "Success", "Updating User Info is successful");
  //       });
  //       // testRef.update({"data1": testModel.toJson()}).then((_) {
  //       //   print(" Update user success!");
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       notifyListeners();
  //     } catch (e) {
  //       print("Failed to update user: $e");
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
  //       //   print(" Update user success!");
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       // testRef.update({"data1": testModel.toJson()}).then((_) {
  //       //   print(" Update user success!");
  //       //   MessageHandler.showMessage(
  //       //       context, "Success", "Updating User Info is successful");
  //       // });
  //       notifyListeners();
  //     } catch (e) {
  //       print("Failed to update user: $e");
  //       MessageHandler.showErrMessage(
  //           context, "Fail", "Updating User Info is fail");
  //     }
  //   }
  //
  // }
  Future<void> topup(
      BuildContext context, PaymentType paymentType) async {
      double amount = 2000.00;
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
        double balance= value.data()["balance"];
        if(balance != null){
          try {
            value.reference.update({"balance":  balance + amount }).then((_) {
              print("topup success!");
            });
            MessageHandler.showMessage(context, "Success", "Your topup is successful");
            TestModel testModel = TestModel(
                uid: uid,
                type: TestType
                    .Topup,
                amount: amount,
                paymentType: paymentType,
                createdDate: DateTime.now());
                value.reference.collection('manyTransition').add(testModel.toJson()).catchError((error) {
              //print("Failed to add topup transaction: $error");
            });
            notifyListeners();
          } catch (e) {
            print("Failed to topup: $e");
            MessageHandler.showErrMessage(context, "Fail", "Your topup is fail");
          }
        }else{
          MessageHandler.showErrMessage(context, "Fail", "Balance Type null");
        }
      });
      MessageHandler.showErrMessage(context, "Fail", "No Internet");
      notifyListeners();
    }
  }

  Future<void> withdrawl(
      BuildContext context, PaymentType paymentType, double amount) async {
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
              print("withdrawl success!");
              MessageHandler.showMessage(
                  context, "Success", "Your withdrawl is successful");
            });
            TestModel testModel = TestModel(
                uid: uid,
                type: TestType.Withdraw,
                amount: amount,
                paymentType: paymentType,
                createdDate: DateTime.now());
            testRef.doc("$uid").collection("withdraw").add(testModel.toJson()).catchError((error) {
              print("Failed to add withdrawl transaction: $error");
            });
            notifyListeners();
          } catch (e) {
            print("Failed to withdrawl: $e");
            MessageHandler.showErrMessage(
                context, "Fail", "Your withdrawl is fail");
          }
        }
      });
    }
    notifyListeners();
  }

  Future<void> checkPassword(
      BuildContext context, String password) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
       String oldPassword = value.data()["password"];
       var isCorrect = new DBCrypt().checkpw(password, oldPassword);
       if(isCorrect == true){
         double balance = value.data()["balance"];
         double amount =200.00;
         if (amount > balance) {
           MessageHandler.showErrMessage(context, "Insufficient Balance",
               "Your withdraw amount is higher than your balance");
         } else {
             value.reference.update({"balance": balance - amount}).then((_) {

             });
             TestModel testModel = TestModel(
                 uid: uid,
                 type: TestType.Withdraw,
                 amount: amount,
                 paymentType: PaymentType.KPay,
                 createdDate: DateTime.now());
             testRef.doc("$uid").collection("withdraw").add(testModel.toJson()).catchError((error) {
               print("Failed to add withdrawl transaction: $error");
             });
             MessageHandler.showMessage(context, "Success", "Your withdrawl is successful");
             notifyListeners();
         }
         //MessageHandler.showMessage(context, "Success", "Your Password is successful");
        // notifyListeners();
       }
       else{
         print("Failed to password: $e");
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
  //         print(result.data());
  //         list.add(TransactionModel.fromJson(result.data()));
  //       });
  //     });
  //   }
  //   notifyListeners();
  //   return list;
  // }

}
*/
