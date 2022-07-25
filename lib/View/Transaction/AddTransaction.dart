import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spending/Model/Group.dart';
import 'dart:developer';
import 'package:spending/Utils/font/TextStyleUtils.dart';
import 'package:spending/View/Transaction/GroupTransaction.dart';

import '../../Controller/Insert_Transaction.dart';
import '../../Model/Transaction.dart';


class AddTransaction extends StatefulWidget {
  Transactions transactions;
  int? id;

  AddTransaction({required this.transactions, this.id});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction>{
  String dateTime = "Hôm nay";
  late  TextEditingController _money ;
  late TextEditingController _note;
  late Group group;
  static const _locale = 'en';

  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
  @override
  void initState() {
    super.initState();
    _money = TextEditingController();
    _note = TextEditingController();
    if(widget.id ==0 ) {
        group = Group(idGroup: 0, nameGroup: "Chọn nhóm", imgGroup: "");
        log("load lai 1");
    }
    else{
      log("log lai 2" );
      group = Group(idGroup: widget.transactions.idGroup, nameGroup: widget.transactions.nameGroup, imgGroup: "");
      //group.idGroup= ,group.nameGroup = widget.transactions.nameGroup
    }
    //group = Group(idGroup: 0, nameGroup: "Chọn nhóm", imgGroup: "");

  }

  void showDate()
  {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate:  DateTime(2222) ,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orangeAccent,
            ),
          ),
          child: child!,
        );
      },
    ).then((date)
    {
      setState(() {
        final f = DateFormat('yyyy-MM-dd');
        dateTime = f.format(date!);
      });
    });
  }

  // void _selectDate(DateTime? newSelectedDate) {
  //   if (newSelectedDate != null) {
  //     setState(() {
  //       _selectedDate.value = newSelectedDate;
  //       dateTime = '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //             'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
  //       ));
  //     });
  //   }
  // }

  void sentDataGroup() async
  {
     group  = await Navigator.push(context, MaterialPageRoute(builder: (context) => GroupTransaction()));
     widget.transactions.id=-1;
     log("gia tri nhan ve : " + group.nameGroup!);
      setState(() {
      });
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
        title: const Text("Thêm giao dịch"),
        actions: [
           InkWell(
             onTap: () {
               String tien ="";
               _money.text.isEmpty ? _money.text = "0" : _money.text;
               List<String> values = _money.text.split(","); // split() will split from . and gives new List with separated elements.
               values.forEach((String a) => tien = tien +a);
                var trasaction = Transactions(money: int.tryParse(tien) , date: dateTime, note: _note.text, idGroup: group.idGroup);
                InsertInsaction().insert(trasaction,context);
             },
             child: Container(
               margin: const EdgeInsets.only(right: 20),
               alignment: Alignment.centerLeft,
                 child: Text("Lưu", style: TextStyleUtils.font18(),)),
           )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _informationInput(context))),
      ),
    );
  }

  Widget _informationInput(BuildContext context) {
    return Column(
      children: [
        _edtInputMoney(),
        const SizedBox(height: 25,),
        _inputGroup(),
        const SizedBox(height: 25,),
        TextField(
          controller: _note,
          decoration: const InputDecoration(hintText: "Nhập thông tin giao dịch",icon: Icon(Icons.notes,size: 32,)),
          style: TextStyleUtils.font24w600().copyWith(color: Colors.black),
        ),
        const SizedBox(height: 25,),
        _inputDate()
      ],
    );
  }
  Widget _edtInputMoney() {
    widget.id ==0 ? _money : _money.text = widget.transactions.money.toString();
    return TextField(
      controller:  _money,
      onChanged: (string) {
        //Format.formatMoney(int.parse(string));
        // // log('First text field: ${Format.formatMoney(int.parse(string))}');
        //
        if(string != ''){
          if(string.length >8)
          {
            ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Bạn đã nhập quá số quy định'),));
          }
          else
          {
            string = _formatNumber(string.replaceAll(',', ''));
            _money.value = TextEditingValue(text: string, selection: TextSelection.collapsed(offset: string.length),);
          }
        }

      },

      decoration: const InputDecoration(hintText: "0 đ"),
      keyboardType: TextInputType.number,
      style: TextStyleUtils.font32().copyWith(color: Colors.green),
    );
  }
  Widget _inputGroup() {
    //group.idGroup ==0 ? group : {group.idGroup= widget.transactions.idGroup,group.nameGroup = widget.transactions.nameGroup };
    //log("group 9"+ group.nameGroup! + group.idGroup.toString());
    return InkWell(
      onTap: () {
        sentDataGroup();
      },
      child: SizedBox(
        child: Row(
          children: [
            const Icon(
              Icons.grading_outlined,
              size: 32,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              group.nameGroup!,
              style: TextStyleUtils.font24(),
            )
          ],
        ),
      ),
    );
  }
  Widget _inputDate()
  {
    widget.transactions.id == 0 ? widget.transactions.date = dateTime : dateTime =  widget.transactions.date;
    log("date" + dateTime);
     return SizedBox(
       child: Row(
         children: [
           const Icon(
             Icons.calendar_month,
             size: 32,
           ),
           const SizedBox(
             width: 15,
           ),
           InkWell(
             onTap: (){
               showDate();
             },
             child: Text(
               dateTime,
               style: TextStyleUtils.font24(),
             ),
           )
         ],
       ),
     );
  }
}
