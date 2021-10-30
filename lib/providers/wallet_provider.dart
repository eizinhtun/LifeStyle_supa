// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/meter_bill.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/widgets/wallet.dart';

class WalletProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var tracRef = FirebaseFirestore.instance.collection(transactions);
  var userRef = FirebaseFirestore.instance.collection(userCollection);
  var meterBillRef =
      FirebaseFirestore.instance.collection(meterBillsCollection);
  var balance;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  Future<bool> topup(BuildContext context, String paymentType, double amount,
      String transactionId, imageFile) async {
    print(imageFile);
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      var dateTime = DateTime.now();
      var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
      print(dateFormat.toString());
      final ref = FirebaseStorage.instance
          .ref('user_topup')
          .child(dateFormat.toString() + "_" + uid + ".jpg");
      final uploadTask = ref.putFile(File(imageFile.path));
      String downloadUrl = await (await uploadTask).ref.getDownloadURL();
      if (downloadUrl != null) {
        userRef.doc(uid).get().then((value) {
          double balance = value.data()["balance"] ?? 0;
          print(balance);
          if (balance != null) {
            print(balance + amount);
            try {
              value.reference.update({"balance": balance + amount}).then((_) {
                print("topup success!");
              });

              TransactionModel transactionModel = TransactionModel(
                  uid: uid,
                  type: TransactionType.Topup,
                  amount: amount.toInt(),
                  status: "verifying",
                  paymentType: paymentType,
                  imageUrl: downloadUrl,
                  transactionId: transactionId,
                  createdDate: Timestamp.fromDate(DateTime.now()));
              tracRef
                  .doc(uid)
                  .collection("manyTransition")
                  .add(transactionModel.toJson())
                  .catchError((error) {
                print("Failed to add topup transaction: $error");
              });
              notifyListeners();
              MessageHandler.showMessage(
                  context, "Success", "Your topup is successful");
              return true;
            } catch (e) {
              print("Failed to topup: $e");
              MessageHandler.showErrMessage(
                  context, "Fail", "Your topup is fail");
              return false;
            }
          } else {
            MessageHandler.showErrMessage(context, "Fail", "Balance Type null");
          }
          //MessageHandler.showErrMessage(context, "Fail", "No Internet");
          notifyListeners();
        });
      }
      notifyListeners();
    }
  }

  // Future<void> withdrawl(
  //     BuildContext context, PaymentType paymentType, double amount) async {
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
  //       double balance = value.data()["balance"];
  //       if (amount > balance) {
  //         MessageHandler.showErrMessage(context, "Insufficient Balance",
  //             "Your withdraw amount is higher than your balance");
  //       } else {
  //         try {
  //           value.reference.update({"balance": balance - amount,}).then((_) {
  //             print("withdrawl success!");
  //             MessageHandler.showMessage(
  //                 context, "Success", "Your withdrawl is successful");
  //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Wallet()));
  //           });
  //           TransactionModel transactionModel = TransactionModel(
  //               uid: uid,
  //               type: TransactionType.Withdraw,
  //               amount: -amount,
  //               createdDate: DateTime.now());
  //           tracRef.doc(uid).collection("manyTransition").add(transactionModel.toJson()).catchError((error) {
  //             print("Failed to add withdrawl transaction: $error");
  //           });
  //           notifyListeners();
  //         } catch (e) {
  //           print("Failed to withdrawl: $e");
  //           MessageHandler.showErrMessage(
  //               context, "Fail", "Your withdrawl is fail");
  //         }
  //       }
  //     });
  //   }
  //   notifyListeners();
  // }
  Future<void> withdrawlCheckPassword(BuildContext context, String paymentType,
      int amount, String password) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      userRef.doc(uid).get(GetOptions(source: Source.server)).then((value) {
        String oldPassword = value.data()["password"];
        var isCorrect = new DBCrypt().checkpw(password, oldPassword);
        if (isCorrect) {
          double balance = value.data()["balance"];
          if (amount > balance) {
            MessageHandler.showErrMessage(context, "Insufficient Balance",
                "Your withdraw amount is higher than your balance");
          } else {
            try {
              value.reference.update({
                "balance": balance - amount,
              }).then((_) {
                print("withdrawl success!");
                MessageHandler.showMessage(
                    context, "Success", "Your withdrawl is successful");
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Wallet()));
              });
              TransactionModel transactionModel = TransactionModel(
                  uid: uid,
                  type: TransactionType.Withdraw,
                  amount: -amount,
                  createdDate: Timestamp.fromDate(DateTime.now()));
              tracRef
                  .doc(uid)
                  .collection("manyTransition")
                  .add(transactionModel.toJson())
                  .catchError((error) {
                print("Failed to add withdrawl transaction: $error");
              });
              notifyListeners();
            } catch (e) {
              print("Failed to withdrawl: $e");
              MessageHandler.showErrMessage(
                  context, "Fail", "Your withdrawl is fail");
            }
          }
        } else {
          MessageHandler.showErrMessage(context, "Fail", "Password is fail");
          notifyListeners();
        }
        MessageHandler.showMessage(context, "Success", "Password is true");
        notifyListeners();
      });
      // MessageHandler.showErrMessage(context, "Fail", "No Internet");
      // notifyListeners();
    }
  }
  // Future<void> checkPassword(
  //     BuildContext context, String password) async {
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
  //       String oldPassword = value.data()["password"];
  //       var isCorrect = new DBCrypt().checkpw(password, oldPassword);
  //       MessageHandler.showMessage(context, "Success", "Password is true");
  //       notifyListeners();
  //
  //     });
  //     // MessageHandler.showErrMessage(context, "Fail", "No Internet");
  //     // notifyListeners();
  //   }
  // }

  // Future<double> getBalance() async {
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid.toString();

  //     await userRef.doc(uid).get().then((value) {
  //       return value.data()["balance"];
  //     });
  //     // return doc.data()["balance"] ?? 0;
  //   }
  //   return 0;
  // }

  // Future<List<TransactionModel>> getManyTransactionList(
  //     BuildContext context) async {
  //   List<TransactionModel> list = [];
  //   if (FirebaseAuth.instance.currentUser?.uid != null) {
  //     String uid = FirebaseAuth.instance.currentUser.uid;
  //     await tracRef.doc(uid).collection(manyTransaction).get().then((value) {
  //       print(value.docs);
  //       value.docs.forEach((result) {
  //         list.add(TransactionModel.fromJson(result.data()));
  //       });
  //     });
  //   }
  //   notifyListeners();
  //   return list;
  // }

  Future<List<TransactionModel>> getTransactionList(
      BuildContext context) async {
    List<TransactionModel> list = [];
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      await tracRef.doc(uid).collection(manyTransaction).get().then((value) {
        print(value.docs);
        value.docs.forEach((result) {
          list.add(TransactionModel.fromJson(result.data()));
        });
      });
    }
    notifyListeners();
    return list;
  }

  Future<void> payMeterBill(
      BuildContext context, MeterBill bill, String docId) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      userRef.doc(uid).get().then((value) async {
        double balance = value.data()["balance"];

        if (bill.totalCost > balance) {
          MessageHandler.showErrMessage(context, "Insufficient Balance",
              "Your meter bill is higher than your balance");
        } else {
          try {
            userRef
                .doc(uid)
                .update({"balance": balance - bill.totalCost}).then((_) {
              print("meter bill payment success!");
              MessageHandler.showMessage(
                  context, "Success", "Your  meter bill payment is successful");
            });
            TransactionModel transactionModel = TransactionModel(
                uid: uid,
                type: TransactionType.meterbill,
                // paymentType: ,
                // amount: bill.totalCost.toDouble(),
                createdDate: Timestamp.fromDate(DateTime.now()));

            tracRef
                .doc(uid)
                .collection("manyTransition")
                .add(transactionModel.toJson())
                .catchError((error) {
              print("Failed to add meter bill payment transaction: $error");
            });

            await meterBillRef.doc(docId).set(bill.toJson());

            notifyListeners();
          } catch (e) {
            print("Failed to meter bill payment: $e");
            MessageHandler.showErrMessage(
                context, "Fail", "Your meter bill payment is fail");
          }
        }
      });
    }
    notifyListeners();
  }
}
