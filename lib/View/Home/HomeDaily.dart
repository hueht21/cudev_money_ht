

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spending/Model/ToalMoney.dart';
import 'package:spending/Utils/font/TextStyleUtils.dart';
import '../../DataBase/DBProvider.dart';
import '../../Format/Format.dart';
import '../../Model/Transaction.dart';
import '../ItemList/ListItem.dart';
import '../Transaction/AddTransaction.dart';

class HomeDaily extends StatefulWidget {
  @override
  State<HomeDaily> createState() => _HomeDailyState();
}

class _HomeDailyState extends State<HomeDaily> with RouteAware {
  late Future<List<Transactions>> listFuru;
  late Future<List<ToalMoney>> listFuruToal;
  String? dateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  void loadData() {
    //log("message load data");
    listFuru = DBProvider.db.querySelectTransacHome();
    listFuruToal = DBProvider.db.queryToalMoneyHome();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
       child: SafeArea(
          child: Container(
            color: const Color(0xffEEEEEE),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [_tableSpending(context), ListItem(listFuru: listFuru, title: "Chưa có giao dịch ngày hôm nay")],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTransaction(transactions: Transactions(id: 0,money: 0, date: "2022-12-12", note: ""),)));
          loadData();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }


  Widget _tableSpending(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: MediaQuery.of(context).size.width,
        height: 110,
        child: FutureBuilder<List<ToalMoney>>(
            future: listFuruToal,
            builder: (context, snapshot) {
              if (!snapshot.hasData){ return const Text("loading.......");}
              return Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Bảng chi tiêu",
                      style: TextStyleUtils.font18(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          "Số tiền tiêu trong tháng",
                          style: TextStyleUtils.font16w600(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(Format.formatMoney(snapshot.data![0].toalMonth!),
                            style: TextStyleUtils.font16w600()
                                .copyWith(color: Colors.red))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text("Số tiền tiêu trong ngày", style: TextStyleUtils.font16w600(),),
                        const SizedBox(width: 10,),
                        Text('${snapshot.data![0].toalDay == null ? '' : Format.formatMoney(snapshot.data![0].toalDay!) }',
                            style: TextStyleUtils.font16w600().copyWith(color: Colors.red))
                      ],
                    ),
                  ],
                ),
              );
            }));
  }



}
