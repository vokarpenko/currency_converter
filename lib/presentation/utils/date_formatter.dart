import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatEEEddMMM(DateTime date) {
    return DateFormat('EEE, dd MMM').format(date);
  }

  static String formatDDMMM(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
}
