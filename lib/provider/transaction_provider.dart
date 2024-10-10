import 'package:accout/database/transaction_db.dart';
import 'package:flutter/foundation.dart';
import 'package:accout/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class TransactionProvider with ChangeNotifier {
  List<Transactions> transactions = [];

  List<Transactions> getTransaction() {
    return transactions;
  }

  void initData() async {
    var db = TransactionDB(dbName: 'transactions.db');
    transactions = await db.loadAllData();
    print(transactions);
    notifyListeners();
  }

  void addTransaction(Transactions transaction) async {
    var db = TransactionDB(dbName: 'transactions.db');
    var keyID = await db.insertDatabase(transaction);
    transactions = await db.loadAllData();
    print(transactions);
    notifyListeners();
  }

  void deleteTransaction(int index) async {
    print('delete index: $index');
    var db = TransactionDB(dbName: 'transactions.db');
    await db.deleteDatabase(index);
    transactions = await db.loadAllData();
    notifyListeners();
  }

  void updateTransaction(Transactions transaction) async {
    var db = TransactionDB(dbName: 'transactions.db');
    await db.updateDatabase(transaction);
    transactions = await db.loadAllData();
    notifyListeners();
  }

  void editTransaction(Transactions updatedTransaction) {}
}
