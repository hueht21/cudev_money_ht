import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spending/View/Home/HomeAccout.dart';

import '../../Utils/font/TextStyleUtils.dart';
import '../../Utils/icon/icon_svg.dart';
import 'HomeDaily.dart';
import 'HomeStatistical.dart';
import 'Home_search.dart';

class HomeMoney extends StatefulWidget {
  @override
  State<HomeMoney> createState() => _HomeMoneyState();
}

class _HomeMoneyState extends State<HomeMoney> {
  int _selectIndex = 0;
  final Facment = [HomeDaily(), HomeSearch(), HomeStatistical(), HomeAccout()];
  void _onItemTap(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Facment[_selectIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(Icons.home),
            ), label: "Hằng ngày"),
            const BottomNavigationBarItem(icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(Icons.search),
            ), label: "Tìm kiếm"),
            BottomNavigationBarItem(icon: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: SvgPicture.asset(iconStatistical,width: 24,height: 24,color: _selectIndex == 2 ? Colors.orange : Colors.grey,),
            ), label: "Thông kê"),
            const BottomNavigationBarItem(icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(Icons.account_circle_outlined),
            ), label: "Tài khoản"),

          ],
          unselectedLabelStyle: TextStyleUtils.font12(),
          selectedLabelStyle: TextStyleUtils.font12(),
          currentIndex: _selectIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTap,
        ));
  }

}
