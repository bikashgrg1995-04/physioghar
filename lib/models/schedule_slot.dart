import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';

ScheduleSlot scheduleSlotFromJson(String str) =>
    ScheduleSlot.fromJson(json.decode(str) as Map<String, dynamic>);

String scheduleSlotToJson(ScheduleSlot data) => json.encode(data.toJson());

enum ScheduleSlotStatus {
  open,
  booked,
  blocked;

  String get value {
    switch (this) {
      case ScheduleSlotStatus.open:
        return 'open';

      case ScheduleSlotStatus.booked:
        return 'booked';

      case ScheduleSlotStatus.blocked:
        return 'blocked';
    }
  }

  String get label {
    switch (this) {
      case ScheduleSlotStatus.open:
        return 'OPEN';

      case ScheduleSlotStatus.booked:
        return 'BOOKED';

      case ScheduleSlotStatus.blocked:
        return 'BLOCKED';
    }
  }

  Color get color {
    switch (this) {
      case ScheduleSlotStatus.open:
        return AppColors.pine;

      case ScheduleSlotStatus.booked:
        return AppColors.amber;

      case ScheduleSlotStatus.blocked:
        return AppColors.danger;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ScheduleSlotStatus.open:
        return AppColors.pinePale;

      case ScheduleSlotStatus.booked:
        return AppColors.amberPale;

      case ScheduleSlotStatus.blocked:
        return AppColors.dangerPale;
    }
  }

  static ScheduleSlotStatus fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'open':
        return ScheduleSlotStatus.open;

      case 'booked':
        return ScheduleSlotStatus.booked;

      case 'blocked':
        return ScheduleSlotStatus.blocked;

      default:
        throw FormatException('Unknown schedule slot status: $value');
    }
  }
}

class ScheduleSlot {
  final int? id;
  final DateTime? date;
  final String? time;
  final ScheduleSlotStatus? status;
  final int? sessionId;

  ScheduleSlot({this.id, this.date, this.time, this.status, this.sessionId});

  ScheduleSlot copyWith({
    int? id,
    DateTime? date,
    String? time,
    ScheduleSlotStatus? status,
    Object? sessionId = _keepSessionId,
  }) => ScheduleSlot(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time ?? this.time,
    status: status ?? this.status,
    sessionId: sessionId == _keepSessionId ? this.sessionId : sessionId as int?,
  );

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) => ScheduleSlot(
    id: json['id'] as int?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    time: json['time'] as String?,
    status: json['status'] == null
        ? null
        : ScheduleSlotStatus.fromJson(json['status'] as String),
    sessionId: json['session_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date == null ? null : _formatDate(date!),
    'time': time,
    'status': status?.value,
    'session_id': sessionId,
  };

  DateTime get dateTime {
    final parts = time!.split(':');

    return DateTime(
      date!.year,
      date!.month,
      date!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

const _keepSessionId = Object();
