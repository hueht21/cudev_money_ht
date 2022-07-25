import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spending/DataBase/DBProvider.dart';
import 'package:spending/Format/Format.dart';
import 'package:spending/Utils/img_png_jpg/img.dart';

import '../../Utils/font/TextStyleUtils.dart';
import '../../Utils/icon/icon_svg.dart';

class HomeAccout extends StatefulWidget {
  @override
  State<HomeAccout> createState() => _HomeAccoutState();
}

class _HomeAccoutState extends State<HomeAccout> {

  late Future<String> moneyToal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moneyToal = DBProvider.db.queryToalAccout();
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
        title: Text("Tài khoản", style: TextStyleUtils.font24(),),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              const SizedBox(height: 15,),
              _myWallet(),
              const SizedBox(height: 50,),
              _menuItem(title: 'Nạp tiền', icon: iconWallet, onTap: () async {
                final values = await DBProvider.db.queryToalAccout();
                print('values: $values');//chay đi, em ấn rồi đe, ơ hinh như nó kh vao day,  d
              }),
              _menuItem(title: 'Ngôn ngữ', icon: iconMenu, description: 'Tiếng việt(VN)'),
              _menuItem(title: 'Chính sách và bảo mật', icon: iconSecurity),
              _menuItem(title: 'Phản hồi ý kiến', icon: iconFeedback),
              _menuItem(title: 'Giới thiệu về chúng tôi', icon: iconIntroduce),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myWallet() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        margin:const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  "Ví của tôi",
                  style: TextStyleUtils.font18(),
                ),
                const SizedBox(height: 8,)
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Image.asset(imgSpending),
                const SizedBox(width: 10,),
                Text("Chi tiêu", style: TextStyleUtils.font16Semibold(),),
                const Flexible(fit: FlexFit.tight,child: SizedBox()),
                FutureBuilder<String>(
                    future: moneyToal,
                    builder: (context,snapshot) {
                      if(!snapshot.hasData)
                       {
                         return const Text("Loadingggg");
                       }
                     // log("data"+ snapshot.data.toString());
                      return Text('${snapshot.data == "null" ? 'Chưa có dữ liệu' : Format.formatMoney(int.parse(snapshot.data!))} đ',style: TextStyleUtils.font18(),);
                    },
                   )
              ],
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  Widget _menuItem({required String title, required String icon, String? description, VoidCallback? onTap, int? logout}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            if (onTap != null) onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(icon),
                      const SizedBox(
                        width: 18,
                      ),
                      logout != 1
                          ? Text(
                              title,
                              style: TextStyleUtils.font16Semibold(),
                            )
                          : Text(
                              title,
                              style: TextStyleUtils.font16Semibold(),
                            ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    description != null
                        ? Text(description,
                            style: TextStyleUtils.font16Semibold())
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 16,
                    ),
                    logout != 1
                        ? SvgPicture.asset(iconArrowRight)
                        : const SizedBox
                            .shrink(), //Tạo một hộp sẽ trở nên nhỏ như mức độ mà cha mẹ của nó cho phép.
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
