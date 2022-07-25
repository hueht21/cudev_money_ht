import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spending/DataBase/DBProvider.dart';
import 'package:spending/Model/Transaction.dart';
import 'package:spending/Utils/font/TextStyleUtils.dart';
import 'package:spending/Utils/img_png_jpg/img.dart';
import 'package:spending/View/Transaction/AddTransaction.dart';

class Detail extends StatelessWidget {

  Transactions transactions;

  Detail(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: [_appbar(context), _deatailTransaction()],
            ),
          ),
        ));
  }

  Widget _appbar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          _onTapClick(assetIcon: Icons.close, index: 0, context: context),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          _onTapClick(assetIcon: Icons.edit, index: 1, context: context),
          const SizedBox(
            width: 20,
          ),
          _onTapClick(assetIcon: Icons.delete, index: 2, context: context),
        ],
      ),
    );
  }

  Widget _onTapClick({required IconData assetIcon, required int index, required BuildContext context}) {
    return SizedBox(
      width: 30,
      height: 30,
      child: InkWell(
        onTap: () {
          switch (index) {
            case 0:
              {
                Navigator.pop(context);
                break;
              }
            case 1:
              {
                Navigator.push(context,MaterialPageRoute(builder: (context) => AddTransaction(transactions: transactions, id: 0)));
                break;
              }
            case 2:
              {
                DBProvider.db.deleteDog(transactions.id!);
                Navigator.pop(context);
                break;
              }
          }
        },
        child: Icon(assetIcon),
      ),
    );
  }

  Widget _deatailTransaction() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          _deatil(title: '${transactions.nameGroup}', check: 0),
          const SizedBox(height: 15,),
          _detailMoney(),
          const SizedBox(height: 15,),
          _deatil(title: transactions.note, check: 1,icon: Icons.notes),
          const SizedBox(height: 25,),
          _deatil(title:transactions.date, check: 1,icon: Icons.calendar_month),
        ],
      ),
    );
  }


  Widget _detailMoney() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 65),
        child: Text(
          '${transactions.money}',
          style: TextStyleUtils.font24().copyWith(color: Colors.red),
        ));
  }
  Widget _deatil({required String title, required int check,IconData? icon}) {
    return Row(
      children: [
        check == 0
            ? Image.asset(imgMove, width: 50, height: 50,)
            : Icon(icon, size: 32,),
        SizedBox(width: check == 0 ? 15 : 30,),
        Text(title, style: TextStyleUtils.font24(),),
      ],
    );
  }
}
