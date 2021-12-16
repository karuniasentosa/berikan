import 'package:intl/intl.dart';

/// Describe a date difference
class DateDiffDescriber
{
  /// Returns a difference in hour with description.
  /// example: '8 jam lalu'
  ///
  /// If [from] and [to] makes 0 difference in hour,
  /// return 'Baru saja'
  static String hourDiff(DateTime from, DateTime to)
  {
    final int inHours = _absDiff(from, to).inHours;
    if (inHours > 0) {
      return '$inHours jam lalu';
    } else {
      return 'Baru saja';
    }
  }

  static String dayDiff(DateTime from, DateTime to, {DateFormat? dateFormat})
  {
    final int inDays = _absDiff(from, to).inDays;
    if (inDays >= 30) {
      return (dateFormat ?? DateFormat.yMMM()).format(from);
    } else if (inDays >= 7) {
      // example: 8 Okt
      return (dateFormat ?? DateFormat.yMMMMd()).format(from);
    } else if (inDays >= 2) {
      return '$inDays hari lalu';
    } else if (inDays >= 1){
      return 'Kemarin';
    } else {
      return 'Hari ini';
    }
  }

  static Duration _absDiff(DateTime from, DateTime to) => from.difference(to).abs();
}