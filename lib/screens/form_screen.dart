import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_database/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_database/main.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:flutter_database/screens/home_screen.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("แบบฟอร์มบันทึกข้อมูล"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextFormField(
                decoration: new InputDecoration(labelText: "ชื่อรายการ"),
                autofocus: true,
                controller: titleController,
                validator: ((String? str) {
                  if (str!.isEmpty) {
                    return "กรุณาป้อนชื่อรายการ";
                  }
                  return null;
                }),
              ),
              TextFormField(
                decoration: new InputDecoration(labelText: "จำนวนเงิน"),
                keyboardType: TextInputType.number,
                controller: amountController,
                validator: (String? str) {
                  if (str!.isEmpty) {
                    return "กรุณาป้อนจำนวนเงิน";
                  } else if (double.parse(str) < 0) {
                    return "กรุณาป้อนจำนวนเงินที่มากกว่าหรือเท่ากับ 0";
                  }
                  return null;
                },
              ),
              TextButton(
                child: Text("เพิ่มข้อมูล"),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    var title = titleController.value.text;
                    var amount = amountController.text;

                    // print(title);
                    // print(amount);
                    Transactions statement = Transactions(
                        title: title,
                        amount: double.parse(amount),
                        date: DateTime.now()); //object

                    var provider = Provider.of<TransactionProvider>(context,
                        listen: false);
                    provider.addTransaction(statement);
                    
                    
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true, //ปิดปุ่มย้อนกลับซ้ายบน
                            builder: (context) {
                              return MyHomePage();
                            }));
                    
                  }
                },
              )
            ]),
          ),
        ));
  }
}
