
import 'package:dio/dio.dart';

import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';
import 'package:physioghar/models/schedule_slot.dart';

class ScheduleService {
  ScheduleService({
    Dio? dio,
  }) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<ScheduleSlot>> getSchedules({
    required DateTime date,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.schedules,
      queryParameters: {
        'date': _formatDate(date),
      },
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Invalid schedules response.',
      );
    }

    return data
        .map(
          (item) => ScheduleSlot.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<ScheduleSlot> createSchedule({
    required DateTime date,
    required String time,
    required ScheduleSlotStatus status,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.schedules,
      data: {
        'date': _formatDate(date),
        'time': time,
        'status': status.value,
      },
    );

    return ScheduleSlot.fromJson(
      Map<String, dynamic>.from(
        response.data as Map,
      ),
    );
  }

  Future<ScheduleSlot> updateSchedule({
    required int scheduleId,
    ScheduleSlotStatus? status,
    String? time,
    DateTime? date,
  }) async {
    final data = <String, dynamic>{};

    if (date != null) {
      data['date'] = _formatDate(date);
    }

    if (time != null) {
      data['time'] = time;
    }

    if (status != null) {
      data['status'] = status.value;
    }

    final response = await _dio.patch(
      '${ApiEndpoints.schedules}$scheduleId/',
      data: data,
    );

    return ScheduleSlot.fromJson(
      Map<String, dynamic>.from(
        response.data as Map,
      ),
    );
  }

  Future<void> deleteSchedule(
    int scheduleId,
  ) async {
    await _dio.delete(
      '${ApiEndpoints.schedules}$scheduleId/',
    );
  }

  String _formatDate(DateTime date) {
    final year =
        date.year.toString().padLeft(4, '0');
    final month =
        date.month.toString().padLeft(2, '0');
    final day =
        date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
