import 'package:intl/intl.dart';

class Formatter {
  static String dateTimeFormat(DateTime date) {
    final f = new DateFormat('MM/dd/yyyy, hh:mm a');
    return f.format(date);
  }

  static String balanceFormat(double balance) {
    return NumberFormat.decimalPattern().format(balance);
  }
}
