import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spending/DataBase/DBProvider.dart';
import 'package:spending/Model/ToalGroup.dart';

import '../../Model/MonthMoney.dart';
import '../../Utils/font/TextStyleUtils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HomeStatistical extends StatefulWidget {
  @override
  State<HomeStatistical> createState() => _HomeStatisticalState();
}

class _HomeStatisticalState extends State<HomeStatistical> {
  int currentTab = 0;
  setActiveTab({required int index}) {
    setState(() {
      currentTab = index;
    });
  }

  List<ToalGroup>? _charData;
  List<MonthMoney>? _charGetData = [];
  List<MonthMoney>? _charGetDataYear = [];
  getData() async {
    final List<ToalGroup> charData = await DBProvider.db.querySelectToalGroup();
    final List<MonthMoney> charGetData =
        await DBProvider.db.querySelecMonthMoney();
    final List<MonthMoney> charGetDataYear =
        await DBProvider.db.querySelecMonthYear();
    await DBProvider.db.querySelecMonthMoney();
    setLocalMonth(charGetData);
    setState(() {
      _charData = charData;
      setLocalMonth(charGetData);
      _charGetData = charGetData;
      _charGetDataYear = charGetDataYear;
    });
  }

  void setLocalMonth(List<MonthMoney> list) {
    for (int i = 0; i <= list.length; i++) {
      if (i == 0) {
        list[i].toalMoney = "Tháng này";
      }
      if (i == 1) {
        list[i].toalMoney = "Tháng trước";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.orangeAccent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        ),
        backgroundColor: Colors.orangeAccent,
        title: const Text("Thống kê giao dịch"),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              _tabContro(),
              currentTab == 0 ? _chartMonth() : _chartYear()
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartMonth() {
    return SingleChildScrollView(
      child: Column(children: [_chartsMoney(), _chartsMoneyHeight()]),
    );
  }

  Widget _chartYear() {
    return SingleChildScrollView(
      child: Column(children: [_chartsMoneyYear()]),
    );
  }

  Widget _tabContro() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            filterItem(title: "Biểu đồ tháng", index: 0),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            filterItem(title: "Bảng chi tiết năm", index: 1),
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

  Widget _chartsMoney() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: SfCircularChart(
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyleUtils.font14w400()),
        title: ChartTitle(
            text: "Thống kê giao dịch chi tiêu trong tháng",
            textStyle: TextStyleUtils.font18()),
        series: <CircularSeries>[
          PieSeries<ToalGroup, String>(
              dataSource: _charData,
              xValueMapper: (ToalGroup data, _) => data.nameGroup,
              yValueMapper: (ToalGroup data, _) => data.toalGroup,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true, textStyle: TextStyleUtils.font14w400()),),


        ],
      ),
    );
  }

  Widget _chartsMoneyHeight() {
    return SizedBox(
      // width: MediaQuery.of(context).size.width,
      // height: 300,
      child: Column(
        children: [
          SfCartesianChart(
            // SfCartesianChart
            isTransposed: true,
            series: <ChartSeries>[
              BarSeries<MonthMoney, String>(
                  dataSource: _charGetData!,
                  xValueMapper: (MonthMoney gdp, _) => gdp.toalMoney,
                  yValueMapper: (MonthMoney gdp, _) => gdp.monthMoney,
                  dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
          ),
          Text("Biểu đồ chi tiết chi tiêu tháng",
              style: TextStyleUtils.font18())
        ],
      ),
      // child: Subscr,
    );
  }

  Widget _chartsMoneyYear() {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Text("Biểu đồ chi tiết chi tiêu năm", style: TextStyleUtils.font18()),
          const SizedBox(
            height: 15,
          ),
          SfCartesianChart(
            // SfCartesianChart
            //isTransposed: true,
            series: <ChartSeries>[
              BarSeries<MonthMoney, String>(
                  dataSource: _charGetDataYear!,
                  xValueMapper: (MonthMoney gdp, _) => gdp.toalMoney,
                  yValueMapper: (MonthMoney gdp, _) => gdp.monthMoney)
            ],
            primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0))
          )
        ],
      ),
      // child: Subscr,
    );
  }
}
