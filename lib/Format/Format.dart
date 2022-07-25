import 'dart:developer';

import 'package:intl/intl.dart';


class Format{
  static formatDate(String date)
  {
    DateTime dt = DateTime.parse(date);
    final f = DateFormat('dd-MM-yyyy');
    String dateString = f.format(dt);
    return dateString;
  }
  static formatMoney(int money)
  {
    final currencyFormatter = NumberFormat('#,###', 'ID');
    return currencyFormatter.format(money);
  }
  static formatMoneyKey()
  {
    NumberFormat _formatter;
    _formatter = NumberFormat('#,###', 'ID');
    return _formatter;
  }
  static String formatMoneyd(dynamic amount) {
    return NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
        .replaceAll(' ', '').replaceAll('.', ' ')
        .replaceAll('₫', '');
  }
}
