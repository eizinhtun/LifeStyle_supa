import 'package:intl/intl.dart';

class Formatter {
  static String dateTimeFormat(DateTime date) {
    final f = new DateFormat('MM/dd/yyyy, hh:mm a');
    return f.format(date);
  }

  static String getDate(DateTime date) {
    var dateFormat = DateFormat("dd-MM-yyyy hh:mm a");
    return dateFormat.format(date);
  }

  static String getDates(DateTime date) {
    var dateFormat = DateFormat("dd-MM-yyyy");
    return dateFormat.format(date);
  }

  static String getHour(DateTime date) {
    var dateFormat = DateFormat("hh:mm a");
    return dateFormat.format(date);
  }

  static String balanceUnseenFormat(int num) {
    String s = "****";

    return s;
  }

  static String balanceFormat(int balance) {
    return NumberFormat.decimalPattern().format(balance);
  }

  static String balanceFormatFromDouble(double balance) {
    return NumberFormat.decimalPattern().format(balance);
  }

  static String formatPhone(String phone) {
    if (phone.startsWith("+95")) {
      return phone;
    }
    if (phone.startsWith("95")) {
      return "+" + phone;
    }
    if (phone.startsWith("+950")) {
      return phone.replaceAll("+950", "+95");
    }
    if (phone.startsWith("09")) {
      return "+95" + phone.substring(1, phone.length);
    }
    return phone;
  }
}
