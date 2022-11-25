import 'package:flutter/cupertino.dart';
import 'package:flutter_database/database/transaction_db.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_database/models/Transactions.dart';

class TransactionProvider with ChangeNotifier {
  List<Transactions> transactions = [];

  List<Transactions> getTransaction() {
    return transactions;
  }

  void initData() async {
    var db = TransactionDB(dbName: "transaction.db");
    transactions = await db.loadAllData();
    notifyListeners();
  }

  void addTransaction(Transactions statement) async {
    //var db = await TransactionDB(dbName: "transaction.db").openDatabase(); //
    //print(db); -> /data/user/0/com.example.flutter_database/app_flutter/transaction.db

    var db = TransactionDB(dbName: "transaction.db");
    await db.InsertData(statement);

    //load all data
    transactions = await db.loadAllData();

    // transactions.insert(0,statement);//แทรก statement เข้าไปที่ index 0
    notifyListeners(); //เปลี่ยนแปลงหน้าจอหลังจากเพิ่มข้อมูล
  }

  void deleteTransaction(String title,double amount,DateTime date) async {
    //var db = await TransactionDB(dbName: "transaction.db").openDatabase(); //
    //print(db); -> /data/user/0/com.example.flutter_database/app_flutter/transaction.db

    var db = TransactionDB(dbName: "transaction.db");
    await db.DeleteData(title,amount,date);
    transactions = await db.loadAllData();
    notifyListeners(); //เปลี่ยนแปลงหน้าจอหลังจากเพิ่มข้อมูล
  }
}
