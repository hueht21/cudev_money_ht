class ToalMoney{// lớp Tổng tiền ngày và tháng
  int? toalDay;
  int? toalMonth;

  ToalMoney({this.toalDay, this.toalMonth});

  factory ToalMoney.fromMap(Map<String, dynamic> json ) => ToalMoney(toalDay: json["So_Tien_Ngay"] ,toalMonth: json["So_Tien_Thang"]);

}