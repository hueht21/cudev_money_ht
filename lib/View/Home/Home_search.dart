import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spending/Utils/font/TextStyleUtils.dart';
import 'package:spending/View/ItemList/ListItem.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../DataBase/DBProvider.dart';
import '../../Model/ToalGroup.dart';
import '../../Model/Transaction.dart';
import '../ItemList/ViewDate.dart';

class HomeSearch extends StatefulWidget {
  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  int? _cubIndex;
  String day = "";
  late List<String> list = [];
  setIndex(int index, String day) {
    setState(() {
      this._cubIndex = index;
      this.day = day;
    });
  }

  List<ToalGroup>? _charData;
  late Future<List<Transactions>> listFuru;
  void loadData(String day) {
    listFuru = DBProvider.db.querySelectTransactionDay(day);
  }

  setData(String dayy) async {
    final List<ToalGroup> charData =
        await DBProvider.db.querySelecChartDay(dayy);
    setState(() {
      _charData = charData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelectDay();
    // day = list[0];
    loadData("2020-12-12");
    setData(day);
  }

  getSelectDay() async {
    final data = await DBProvider.db.querySelectDay();
    setState(() {
      list = data;
    });
  }

  int currentTab = 0;
  setActiveTab({required int index}) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.orangeAccent,
          ),
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  _listDay(context),
                  const SizedBox(
                    height: 15,
                  ),
                  _tabContrl(),
                  currentTab == 0
                      ? ListItem(
                          listFuru: listFuru, title: "Chưa có thông tin tìm kiếm, mời bạn chọn ngày")
                      : _reportDay()
                ],
              ),
        ),
      ),
    ));
  }

  Widget _tabContrl() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            filterItem(title: "Thông tin tìm kiếm", index: 0),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            filterItem(title: "Báo cáo cho giao đoạn", index: 1),
            const SizedBox(
              width: 20,
            ),
          ],
        ));
  }

  Widget filterItem({required String title, required int index}) {
    bool isActive = index == currentTab; // nếu bằng thì trả về true
    return GestureDetector(
      // click
      onTap: () => setActiveTab(index: index),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isActive == true ? Colors.orangeAccent : Colors.transparent,
                    width: 2))),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: isActive
              ? TextStyleUtils.font18().copyWith(color: Colors.orangeAccent)
              : TextStyleUtils.font18(),
        ),
      ),
    );
  }

  Widget _listDay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      color: Colors.orangeAccent,
      width: MediaQuery.of(context).size.width,
      height: 110,
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            bool isActive = index == _cubIndex;
            return InkWell(
              onTap: () async {
                setIndex(index, list[index]);
                loadData(list[index]);
                setData(list[index]);
                // setState(() async {
                //   log("load lai");
                //   list = await DBProvider.db.querySelectDay();
                // });

              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  isActive == true
                      ? Container(
                          height: 105,
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 5, bottom: 2),
                          decoration: BoxDecoration(
                              color: const Color(0xffEEEEEE),
                              borderRadius: BorderRadius.circular(8)),
                          child: _itemDay(
                              day: ViewDate.setDataDay(list[index]),
                              month: ViewDate.setDataMonth(list[index]),
                              year: ViewDate.setDataYear(list[index]),
                              check: 1))
                      : _itemDay(
                          day: ViewDate.setDataDay(list[index]),
                          month: ViewDate.setDataMonth(list[index]),
                          year: ViewDate.setDataYear(list[index]),
                          check: 0)
                ],
              ),
            );
          }),
    );
  }

  Widget _itemDay({required String day, required String month, required String year, required int check}) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "THG $month",
            style: check == 0
                ? TextStyleUtils.font14w600()
                : TextStyleUtils.font14w600().copyWith(color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            day,
            style: check == 0
                ? TextStyleUtils.font18()
                : TextStyleUtils.font18().copyWith(color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            year,
            style: check == 0
                ? TextStyleUtils.font14w600()
                : TextStyleUtils.font14w600().copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _reportDay() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: SfCircularChart(
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyleUtils.font14w400()),
        title: ChartTitle(
            text: "Biểu đồ báo cáo giai đoạn ",
            textStyle: TextStyleUtils.font18()),
        series: <CircularSeries>[
          PieSeries<ToalGroup, String>(
              dataSource: _charData,
              xValueMapper: (ToalGroup data, _) => data.nameGroup,
              yValueMapper: (ToalGroup data, _) => data.toalGroup,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true, textStyle: TextStyleUtils.font14w400()))
        ],
      ),
    );
  }
}
