class MonthMoney {
  int? monthMoney;
  String toalMoney;

  MonthMoney({required this.monthMoney,required this.toalMoney});
  factory MonthMoney.fromMap(Map<String,dynamic> json) => MonthMoney(monthMoney: json["Tong_Tien"], toalMoney: json["thang"]);
}