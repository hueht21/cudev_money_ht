import 'package:flutter/material.dart';
import 'package:spending/View/Transaction/Detail.dart';

import '../../DataBase/DBProvider.dart';
import '../../Format/Format.dart';
import '../../Model/Transaction.dart';
import '../../Utils/font/TextStyleUtils.dart';
import '../../Utils/img_png_jpg/img.dart';

class ListItem extends StatefulWidget
{
  Future<List<Transactions>> listFuru;
  String title;

  ListItem({required this.listFuru, required this.title});
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return _listViewTransaction(widget.listFuru);
  }

  Widget _listViewTransaction(Future<List<Transactions>> listFuru) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<List<Transactions>>(
          future: listFuru,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("Loadinggg......!"),
              );
            }
            return snapshot.data?.length ==0 ? _waitPage(): ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return _itemTracsaction(snapshot.data![index],context);
                });
          },
        ),
      ),
    );
  }

  Widget _itemTracsaction(Transactions transactions,BuildContext context) {
    return InkWell(
      onTap: () async
      {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(transactions)));
      widget.listFuru = DBProvider.db.querySelectTransacHome();
      setState(() {});
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  transactions.getNameGroup!,
                  style: TextStyleUtils.font18(),
                ),
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                Text(
                  Format.formatMoney(transactions.money!) + " đ",
                  style: TextStyleUtils.font18()
                      .copyWith(color: Colors.deepOrangeAccent),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  transactions.note,
                  style: TextStyleUtils.font16Semibold(),
                ),
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                Text(
                  Format.formatDate(transactions.date),
                  style: TextStyleUtils.font16Semibold(),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
// các item trong list
  Widget _waitPage() {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            imgTears,
            width: 200,
            height: 200,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.title,
            style: TextStyleUtils.font16w600(),
          )
        ],
      ),
    );
  }}