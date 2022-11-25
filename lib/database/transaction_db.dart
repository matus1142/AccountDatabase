import 'dart:ffi';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/Transactions.dart';
import '../providers/transaction_provider.dart';

class TransactionDB {
  //transaction database
  String? dbName;
  TransactionDB({this.dbName});

  // windows use directory -> c:/users/alohay
  //dbName = transaction.db
  //join(appDirectory.path,dbName) -> c:/users/alohay/transaction.db
  Future<Database> openDatabase() async {
    //จำเป็นต้องรอให้ดาต้าเบสตอบกลับจึงระบุ async
    Directory appDirectory =
        await getApplicationDocumentsDirectory(); //find user account each phone for create database
    String dbLocation = join(appDirectory.path, dbName);
    //create database
    DatabaseFactory dbFactory =
        await databaseFactoryIo; //declare strucure of database
    Database db = await dbFactory.openDatabase(dbLocation);

    return db;
  }

  //for save data
  Future<int> InsertData(Transactions statement) async {
    //database => Store
    var db = await this.openDatabase();
    var store = intMapStoreFactory
        .store("expense"); //create storeName "expense" in transcation.db

    // save statement as json
    var keyID = store.add(db, {
      //statement object
      //  title:
      //  amount:
      //  date:

      "title": statement.title,
      "amount": statement.amount,
      "date": statement.date.toIso8601String() //standard date time format
    });
    db.close();
    return keyID; //เรียงลำดับจาก 1,2,3,4,...
  }

  //load data
  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense"); //open store expense
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [
          SortOrder(Field.key, false)
        ])); //Field.key,false = เรียงจากใหม่ไปเก่า ,Field.key,true = เรียงจากเก่าไปใหม่
    List<Transactions> transactionList =
        List<Transactions>.from(<List<Transactions>>[]);
    var record;
    for (record in snapshot) {
      transactionList.add(Transactions(
          title: record["title"],
          amount: record["amount"],
          date: DateTime.parse(record["date"])));
    }

    // print(snapshot);
    return transactionList;
  }

  Future DeleteData(String title, double amount, DateTime date) async {
    //database => Store
    var db = await this.openDatabase();
    var store = intMapStoreFactory
        .store("expense"); //create storeName "expense" in transcation.db
    var findkey = await store.findKey(db,
        finder: Finder(
            filter: Filter.and([
          Filter.equals('title', title),
          Filter.equals('amount', amount),
          Filter.equals('date', date.toIso8601String())
        ])));
    var record = await store.record(findkey!);
    await record.delete(db);
    // await store.delete(db);
    db.close();
  }
}
