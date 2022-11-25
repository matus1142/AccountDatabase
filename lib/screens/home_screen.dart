import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_database/screens/form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Transactions.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("แอพบัญชี"),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return FormScreen();
                // }));
                SystemNavigator.pop(); //exit app button
              },
            )
          ],
        ),
        body: Consumer(
            builder: (context, TransactionProvider provider, Widget? child) {
          var count = provider.transactions.length;
          if (count <= 0) {
            return Center(
              child: Text(
                "ไม่พบข้อมูล",
                style: TextStyle(fontSize: 35),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: ((context, int index) {
                Transactions data = provider.transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(child: Text(data.amount.toString())),
                    ),
                    title: Text(data.title),
                    subtitle:
                        Text(DateFormat("dd/MM/yyyy") //เปลี่ยน format date
                            .format(data.date)),
                    trailing: PopupMenuButton(itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: 'Delete',
                        )
                      ];
                    }, onSelected: (String value) {
                      print("Delete");
                      var provider = Provider.of<TransactionProvider>(context,
                          listen: false);
                      provider.deleteTransaction(
                          data.title, data.amount, data.date);
                    }),
                    onLongPress: () {
                      // var provider = Provider.of<TransactionProvider>(context,
                      //     listen: false);
                      // provider.deleteTransaction(
                      //     data.title, data.amount, data.date);
                    },
                  ),
                );
              }),
            );
          }
        }));
  }
}
