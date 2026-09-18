import 'package:physioghar/core/utils/date_time_utils.dart';

extension DateTimeExtensions on DateTime {
  bool isSameDay(DateTime other) {
    return DateTimeUtils.isSameDay(this, other);
  }

  bool get isToday {
    return DateTimeUtils.isSameDay(this, DateTime.now());
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    return DateTimeUtils.isSameDay(this, tomorrow);
  }

  bool get isPast {
    return isBefore(DateTime.now());
  }

  bool get isFuture {
    return isAfter(DateTime.now());
  }

  String get formattedDate {
    return DateTimeUtils.formatDate(this);
  }

  String get formattedTime {
    return DateTimeUtils.formatTime(this);
  }

  String get weekdayName {
    return DateTimeUtils.formatWeekday(this);
  }

  String get weekdayShort {
    return DateTimeUtils.formatWeekdayShort(this);
  }

  String get fullDate {
    return DateTimeUtils.formatFullDate(this);
  }
}