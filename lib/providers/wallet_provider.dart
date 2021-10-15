// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/message_handler.dart';

class WalletProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var tracRef = FirebaseFirestore.instance.collection(transactions);
  var userRef = FirebaseFirestore.instance.collection(userCollection);

  Future<void> topup(BuildContext context, double amount) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      double balance = await getBalance();

      try {
        userRef.doc(uid).update({"balance": balance + amount}).then((_) {
          print("topup success!");
        });
        MessageHandler.showMessage(
            context, "Success", "Your topup is successful");
        TransactionModel transactionModel = TransactionModel(
            uid: uid,
            type: TransactionType.Topup,
            amount: amount,
            createdDate: DateTime.now());
        tracRef.add(transactionModel.toJson()).catchError((error) {
          print("Failed to add topup transaction: $error");
        });
      } catch (e) {
        print("Failed to topup: $e");
        MessageHandler.showErrMessage(context, "Fail", "Your topup is fail");
      }

      notifyListeners();
    }
  }

  Future<void> withdrawl(BuildContext context, double amount) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      double balance = await getBalance();
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
          TransactionModel transactionModel = TransactionModel(
              uid: uid,
              type: TransactionType.Withdraw,
              amount: amount,
              createdDate: DateTime.now());
          tracRef.add(transactionModel.toJson()).catchError((error) {
            print("Failed to add withdrawl transaction: $error");
          });
        } catch (e) {
          print("Failed to withdrawl: $e");
          MessageHandler.showErrMessage(
              context, "Fail", "Your withdrawl is fail");
        }
      }
    }
    notifyListeners();
  }

  Future<double> getBalance() async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      await userRef.doc(uid).get().then((value) {
        return value.data()["balance"] ?? 0;
      });
      // return doc.data()["balance"] ?? 0;
    }
    return 0;
  }

  Future<List<TransactionModel>> getTransactionList(
      BuildContext context) async {
    List<TransactionModel> list = [];
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      await tracRef.where("uid", isEqualTo: uid).get().then((value) {
        value.docs.forEach((result) {
          print(result.data());
          list.add(TransactionModel.fromJson(result.data()));
        });
      });
    }
    notifyListeners();
    return list;
  }
}
