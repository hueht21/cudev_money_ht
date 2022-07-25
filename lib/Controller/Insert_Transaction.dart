import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spending/View/Home/HomeDaily.dart';

import '../DataBase/DBProvider.dart';
import '../Model/Transaction.dart';

class InsertInsaction {
  insert(Transactions transactions, BuildContext context) {
    if (transactions.id == 0 || transactions.note.isEmpty || transactions.idGroup == 0 ||
        transactions.date == "Hôm nay" ||
        transactions.money == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Bạn chưa nhập đủ thông tin, chọn ngày'),
      ));
    } else {
      log('your message here' + transactions.idGroup.toString());
      DBProvider.db.newTransaction(transactions);
      Navigator.pop(context);
    }
  }
}
