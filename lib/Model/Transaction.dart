
import 'dart:convert';

import 'package:spending/Model/Group.dart';

class TransactionFields {
  static const String id = "id";
  static const String money = "money";
  static const String note = "note";
  static const String date = "date";
  static const String group = "group";
}

// Transactions transactionsFromJson(String str) => Transactions.fromJson(json.decode(str));
// String transactionsToJson(Transactions data) => json.encode(data.toJson());

class Transactions extends Group{
  int? id;
  int? money;
  String note;
  String date;
  Transactions(
      {idGroup,nameGroup,imgGroup,this.id, required this.money, required this.date, required this.note})
      : super(idGroup : idGroup  , nameGroup : nameGroup, imgGroup : imgGroup);


  factory Transactions.fromJson(Map<String, dynamic> json ) => Transactions(id: json["id"],money: json["So_Tien"], date: json["Ngay_Thang"], note: json["Ghi_Chu"]);

  factory Transactions.fromMapExtends(Map<String, dynamic> json ) => Transactions(money: json["So_Tien"], date: json["Ngay_Thang"], note: json["Ghi_Chu"],idGroup : json['id'],nameGroup: json['Ten_Nhom'], imgGroup: json['Anh_Nhom']);

  factory Transactions.fromMapHome(Map<String, dynamic> json ) => Transactions(id: json["id"],money: json["So_Tien"], date: json["Ngay_Thang"], note: json["Ghi_Chu"],idGroup: json['Nhom'],nameGroup: json['Ten_Nhom']);
  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.money: money,
        TransactionFields.note: note,
        TransactionFields.date: date,
      };

}
