
import 'package:physioghar/data/services/schedule_service.dart';
import 'package:physioghar/models/new/schedule_slot.dart';

class ScheduleRepository {
  ScheduleRepository({
    ScheduleService? scheduleService,
  }) : _scheduleService =
            scheduleService ?? ScheduleService();

  final ScheduleService _scheduleService;

  Future<List<ScheduleSlot>> getSchedules({
    required DateTime date,
  }) async {
    return _scheduleService.getSchedules(
      date: date,
    );
  }

  Future<ScheduleSlot> createSchedule({
    required DateTime date,
    required String time,
    required ScheduleSlotStatus status,
  }) async {
    return _scheduleService.createSchedule(
      date: date,
      time: time,
      status: status,
    );
  }

  Future<ScheduleSlot> updateSchedule({
    required int scheduleId,
    ScheduleSlotStatus? status,
    String? time,
    DateTime? date,
  }) async {
    return _scheduleService.updateSchedule(
      scheduleId: scheduleId,
      status: status,
      time: time,
      date: date,
    );
  }

  Future<void> deleteSchedule(
    int scheduleId,
  ) async {
    await _scheduleService.deleteSchedule(
      scheduleId,
    );
  }
}
