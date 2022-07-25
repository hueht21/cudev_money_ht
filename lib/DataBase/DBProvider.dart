
import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:spending/Model/Group.dart';
import 'package:spending/Model/ToalGroup.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spending/Model/Transaction.dart';

import '../Model/MonthMoney.dart';
import '../Model/ToalMoney.dart';
import '../Utils/img_png_jpg/img.dart';

class DBProvider {
  static const _databaseName = "money.db";
  static const _databaseVersion = 1;
  static const table = 'GiaoDich';
  String dateTime = "Hôm nay";

  static const id=1;
  static const money="So_Tien";
  static const group ="Nhom";
  static const date="Ngay_Thang";
  static const note ="Ghi_Chu";
  var now = DateTime.now();
  // var formatter = new DateFormat('yyyy-MM-dd');
  // String formattedDate = formatter.format(now);


  // make this a singleton class
  DBProvider._privateConstructor();
  DBProvider._();
  static final DBProvider db = DBProvider._();// contructor private
  static final DBProvider instance = DBProvider._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY autoincrement , $money DECIMAL, $date Date, $note varchar(100), Nhom INTEGER
           )
          ''');
    await db.execute('''
          CREATE TABLE Nhom (
            id INTEGER PRIMARY KEY autoincrement ,Ten_Nhom varchar(100), Anh_Nhom varchar(30)
           )
          ''');
    await db.rawInsert('''INSERT INTO Nhom (Ten_Nhom,Anh_Nhom) VALUES ('Ăn uống','$imgEat'),('Di chuyển','$imgMove') ,('Hoá đơn nhà' , '$imgHome') , ('Hoá đơn điện thoại','$imgPhone') ''');

  }
  
   newTransaction(Transactions) async {
    final db = await database;
    var res = await db.rawInsert('''INSERT INTO $table ($money,$date,$note,Nhom) VALUES (?,?,?,?)''', [Transactions.money,Transactions.date,Transactions.note,Transactions.idGroup]);

    return res;
  }
  Future<List<Transactions>> getTransaction() async {
    final db = await database;
    var transaction = await db.query("transaction",orderBy: 'name');
    List<Transactions> transactionList = transaction.isNotEmpty ? transaction.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactionList;
  }
  Future<List<Group>> getGroup() async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('SELECT * FROM Nhom');
    List<Group> list = [];
    for(var result in results)
    {
      Group group = Group.fromMap(result);
      list.add(group);
    }
    return list;
  }
  Future<List<Transactions>> query() async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('SELECT * FROM GiaoDich');
    List<Transactions> list = [];
    for(var result in results)
      {
        Transactions transactions = Transactions.fromJson(result);
        print(transactions.note);
        print("results");
        list.add(transactions);
      }
    return list;
  }
  Future<List<Transactions>> querySelectTransacHome() async {
    final fa = DateFormat('yyyy-MM-dd');
    dateTime = fa.format(DateTime.now());
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select gd.id,gd.So_Tien,gd.Ngay_Thang,gd.Ghi_Chu,nh.Ten_Nhom from GiaoDich gd ,Nhom nh where Ngay_Thang = "$dateTime" and gd.Nhom = nh.id ');
    List<Transactions> list = [];
    for(var result in results)
    {
      Transactions transactions = Transactions.fromMapHome(result);
      list.add(transactions);

    }
    return list;
  }
  Future<List<ToalMoney>> queryToalMoneyHome() async {
    // final fa = DateFormat('yyyy-MM-dd');
    // dateTime = fa.format(DateTime.now());
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('SELECT tong.So_Tien_Thang,ngay.So_Tien_Ngay FROM ( SELECT Sum(So_Tien) as So_Tien_Thang FROM GiaoDich WHERE strftime("%m",Ngay_Thang)   = strftime("%m",date("now")) and strftime("%Y",Ngay_Thang)   = strftime("%Y",date("now"))) tong, ( SELECT Sum(So_Tien) as So_Tien_Ngay FROM GiaoDich WHERE Ngay_Thang = Date()) ngay');
    List<ToalMoney> list = [];
    for(var result in results)
    {
      ToalMoney toalMoney = ToalMoney.fromMap(result);
      list.add(toalMoney);

    }
    return list;
  }
  Future<List<Transactions>> querySelectTransactionDay(String day) async {
    // final fa = DateFormat('yyyy-MM-dd');
    // dateTime = fa.format(DateTime.now());
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select gd.id,gd.So_Tien,gd.Ngay_Thang,gd.Ghi_Chu,nh.Ten_Nhom,gd.Nhom from GiaoDich gd ,Nhom nh where Ngay_Thang = "$day" and gd.Nhom = nh.id ');

    List<Transactions> list = [];
    for(var result in results)
    {
      Transactions transactions = Transactions.fromMapHome(result);
      list.add(transactions);

    }
    return list;
  }
  Future<List<String>> querySelectDay() async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select Ngay_Thang from GiaoDich group by Ngay_Thang order by Ngay_Thang desc');

    return results.map((e) => e["Ngay_Thang"].toString()).toList();
  }
  Future<List<ToalGroup>> querySelectToalGroup() async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select sum(So_Tien)  as Tong_Tien , Nhom.Ten_Nhom from GiaoDich , Nhom where GiaoDich.nhom = Nhom.id and  strftime("%m",Ngay_Thang)   = strftime("%m",date("now")) group by Nhom');

    List<ToalGroup> list = [];
    for(var result in results)
    {
      ToalGroup toalGroup = ToalGroup.fromMap(result);
      list.add(toalGroup);
    }
    return list;
  }
  Future<List<MonthMoney>> querySelecMonthMoney() async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select  sum(So_Tien) as Tong_Tien, "Tháng " ||  strftime("%m",Ngay_Thang) as thang  from GiaoDich where strftime("%Y",Ngay_Thang)  = strftime("%Y",date("now"))  group by  strftime("%m",Ngay_Thang) order by Ngay_Thang desc limit 2');
    List<MonthMoney> list = [];
    for(var result in results)
    {
      MonthMoney monthMoney = MonthMoney.fromMap(result);
      list.add(monthMoney);
    }
    return list;
  }
  Future<List<MonthMoney>> querySelecMonthYear() async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select  sum(So_Tien) as Tong_Tien, "Tháng " ||  strftime("%m",Ngay_Thang) as thang  from GiaoDich where strftime("%Y",Ngay_Thang)  = strftime("%Y",date("now"))  group by  strftime("%m",Ngay_Thang) order by Ngay_Thang desc ');
    List<MonthMoney> list = [];
    for(var result in results)
    {
      MonthMoney monthMoney = MonthMoney.fromMap(result);
      list.add(monthMoney);
    }
    return list;
  }
  Future<List<ToalGroup>> querySelecChartDay(String day) async {
    Database db = await database;
    List<Map<String,dynamic>> results = await db.rawQuery('select sum(So_Tien)  as Tong_Tien , Nhom.Ten_Nhom from GiaoDich , Nhom where GiaoDich.nhom = Nhom.id and  Ngay_Thang = "$day" group by Nhom');

    List<ToalGroup> list = [];
    for(var result in results)
    {
      ToalGroup toalGroup = ToalGroup.fromMap(result);
      list.add(toalGroup);
    }
    return list;
  }
  Future<String> queryToalAccout() async {
    Database db = await database;
    final results = await db.rawQuery('select sum(So_Tien) as Tong_Tien from GiaoDich');
    String? values;
    for (var element in results) {
      values = element['Tong_Tien'].toString();
    }
    return values!;
  }
  Future<void> deleteDog(int id) async {
    final db = await database;
    await db.delete(
      'GiaoDich',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}