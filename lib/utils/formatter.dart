import 'package:intl/intl.dart';

class Formatter {
  static String dateTimeFormat(DateTime date) {
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    return f.format(date.toUtc());
  }
}
