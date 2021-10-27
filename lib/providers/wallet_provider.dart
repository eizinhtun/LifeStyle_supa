// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:left_style/datas/constants.dart';
import 'package:left_style/models/transaction_model.dart';
import 'package:left_style/utils/message_handler.dart';
import 'package:left_style/widgets/wallet.dart';

class WalletProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var tracRef = FirebaseFirestore.instance.collection(transactions);
  var userRef = FirebaseFirestore.instance.collection(userCollection);
  var balance;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  Future<void> topup(
      BuildContext context, String paymentType, double amount) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
        balance = value.data()["balance"];
        if (balance != null) {
          try {
            print('try');
            value.reference.update({"balance": balance + amount}).then((_) {
              print("topup success!");
            });
            MessageHandler.showMessage(
                context, "Success", "Your topup is successful");
            TransactionModel transactionModel = TransactionModel(
                uid: uid,
                type: TransactionType.Topup,
                amount: amount,
                paymentType: paymentType,
                createdDate: DateTime.now());
            tracRef.doc(uid).collection("manyTransition").add(transactionModel.toJson()).catchError((error) {
              print("Failed to add topup transaction: $error");
            });
            notifyListeners();
          } catch (e) {
            print("Failed to topup: $e");
            MessageHandler.showErrMessage(
                context, "Fail", "Your topup is fail");
          }
        } else {
          MessageHandler.showErrMessage(context, "Fail", "Balance Type null");
        }
        //MessageHandler.showErrMessage(context, "Fail", "No Internet");
        notifyListeners();
      });

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
  Future<void> withdrawlCheckPassword(
      BuildContext context, String paymentType, double amount,String password) async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      userRef.doc(uid).get(GetOptions(source:Source.server)).then((value) {
        String oldPassword = value.data()["password"];
        var isCorrect = new DBCrypt().checkpw(password, oldPassword);
        if(isCorrect){
          double balance = value.data()["balance"];
          if (amount > balance) {
            MessageHandler.showErrMessage(context, "Insufficient Balance",
                "Your withdraw amount is higher than your balance");
          } else {
            try {
              value.reference.update({"balance": balance - amount,}).then((_) {
                print("withdrawl success!");
                MessageHandler.showMessage(
                    context, "Success", "Your withdrawl is successful");
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Wallet()));
              });
              TransactionModel transactionModel = TransactionModel(
                  uid: uid,
                  type: TransactionType.Withdraw,
                  amount: -amount,
                  createdDate: DateTime.now());
              tracRef.doc(uid).collection("manyTransition").add(transactionModel.toJson()).catchError((error) {
                print("Failed to add withdrawl transaction: $error");
              });
              notifyListeners();
            } catch (e) {
              print("Failed to withdrawl: $e");
              MessageHandler.showErrMessage(
                  context, "Fail", "Your withdrawl is fail");
            }
          }

        }
        else{
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

  Future<List<TransactionModel>> getManyTransactionList(
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


