class DateTimeUtils {
  DateTimeUtils._();

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _weekdaysShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String formatWeekday(DateTime dateTime) {
    return _weekdays[dateTime.weekday - 1];
  }

  static String formatWeekdayShort(DateTime dateTime) {
    return _weekdaysShort[dateTime.weekday - 1];
  }

  static String formatMonth(DateTime dateTime) {
    return _months[dateTime.month - 1];
  }

  static bool isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static String formatFullDate(DateTime dateTime) {
    return '${formatWeekday(dateTime)}, '
        '${formatMonth(dateTime)} '
        '${dateTime.day}';
  }
}