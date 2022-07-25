import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spending/DataBase/DBProvider.dart';
import 'package:spending/Model/Group.dart';

class GroupTransaction extends StatefulWidget {
  @override
  State<GroupTransaction> createState() => _GroupTransactionState();
}

class _GroupTransactionState extends State<GroupTransaction> {
  late Future<List<Group>> listFuru;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFuru = DBProvider.db.getGroup();
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
        title: const Text("Chọn nhóm"),
      ),
      body: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [Expanded(child: _listGroup())]))),
    );
  }

  Widget _listGroup() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FutureBuilder<List<Group>>(
          future: listFuru,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("Loadinggg......!"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      //Group = Group(nameGroup: snapshot.data![index].nameGroup, imgGroup: imgGroup);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Selected: ${snapshot.data![index].nameGroup} + ${snapshot.data![index].idGroup}'),
                      ));
                      Navigator.pop(context, snapshot.data![index]);
                    },
                    child: Container(
                      child: Column(children: [
                        Row(
                          children: [
                            Image.asset(
                              snapshot.data![index].imgGroup!,
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(snapshot.data![index].nameGroup!),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                        )
                      ]),
                    ),
                  );
                });
          }),
    );
  }
}
