import 'dart:developer';


class ViewDate{
 // String date;
  // late String day;
  // late String month;
  // late String year;
  //ViewDate(this.date);


  static setDataYear(String date)
  {
    final dateList = date.split("-");
    return dateList[0];
  }
  static setDataMonth(String date)
  {
    final dateList = date.split("-");
    return dateList[1];
  }
  static setDataDay(String date)
  {
    final dateList = date.split("-");
    return dateList[2];
  }

}