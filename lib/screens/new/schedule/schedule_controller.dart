
import 'package:flutter/material.dart';

import 'package:physioghar/data/repositories/schedule_repository.dart';
import 'package:physioghar/models/new/schedule_slot.dart';

class ScheduleController {
  ScheduleController({
    ScheduleRepository? scheduleRepository,
  }) : _scheduleRepository =
            scheduleRepository ?? ScheduleRepository();

  final ScheduleRepository _scheduleRepository;

  final isLoading =
      ValueNotifier<bool>(false);

  final isUpdating =
      ValueNotifier<bool>(false);

  final selectedDate =
      ValueNotifier<DateTime>(
    DateTime.now(),
  );

  final slots =
      ValueNotifier<List<ScheduleSlot>>([]);

  String? _errorMessage;

  String? get errorMessage =>
      _errorMessage;

  Future<bool> loadSchedules({
    DateTime? date,
  }) async {
    if (isLoading.value) {
      return false;
    }

    final dateToLoad =
        date ?? selectedDate.value;

    selectedDate.value = dateToLoad;

    isLoading.value = true;
    _errorMessage = null;

    try {
      final result =
          await _scheduleRepository
              .getSchedules(
        date: dateToLoad,
      );

      slots.value = result;

      return true;
    } catch (error) {
      debugPrint(
        'Failed to load schedules: $error',
      );

      _errorMessage =
          'Unable to load schedule.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> selectDate(
    DateTime date,
  ) async {
    return loadSchedules(
      date: date,
    );
  }

  Future<bool> addSlot({
    required DateTime date,
    required String time,
  }) async {
    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;
    _errorMessage = null;

    try {
      final newSlot =
          await _scheduleRepository
              .createSchedule(
        date: date,
        time: time,
        status: ScheduleSlotStatus.open,
      );

      if (_isSameDate(
        newSlot.date,
        selectedDate.value,
      )) {
        final updatedSlots =
            List<ScheduleSlot>.from(
          slots.value,
        )
              ..add(newSlot)
              ..sort(_compareSlots);

        slots.value = updatedSlots;
      }

      return true;
    } catch (error) {
      debugPrint(
        'Failed to add schedule slot: $error',
      );

      _errorMessage =
          'Unable to add schedule slot.';

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> updateSlot({
    required ScheduleSlot slot,
    ScheduleSlotStatus? status,
    String? time,
    DateTime? date,
  }) async {
    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;
    _errorMessage = null;

    try {
      final updatedSlot =
          await _scheduleRepository
              .updateSchedule(
        scheduleId: slot.id!,
        status: status,
        time: time,
        date: date,
      );

      final index = slots.value.indexWhere(
        (item) => item.id == slot.id,
      );

      if (index == -1) {
        return false;
      }

      final updatedSlots =
          List<ScheduleSlot>.from(
        slots.value,
      );

      updatedSlots[index] =
          updatedSlot;

      updatedSlots.sort(
        _compareSlots,
      );

      slots.value = updatedSlots;

      return true;
    } catch (error) {
      debugPrint(
        'Failed to update schedule slot: $error',
      );

      _errorMessage =
          'Unable to update schedule.';

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> blockSlot(
    ScheduleSlot slot,
  ) async {
    return updateSlot(
      slot: slot,
      status: ScheduleSlotStatus.blocked,
    );
  }

  Future<bool> unblockSlot(
    ScheduleSlot slot,
  ) async {
    return updateSlot(
      slot: slot,
      status: ScheduleSlotStatus.open,
    );
  }

  Future<bool> deleteSlot(
    ScheduleSlot slot,
  ) async {
    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;
    _errorMessage = null;

    try {
      await _scheduleRepository
          .deleteSchedule(
        slot.id!,
      );

      slots.value = [
        for (final item in slots.value)
          if (item.id != slot.id) item,
      ];

      return true;
    } catch (error) {
      debugPrint(
        'Failed to delete schedule slot: $error',
      );

      _errorMessage =
          'Unable to delete schedule slot.';

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  int _compareSlots(
    ScheduleSlot a,
    ScheduleSlot b,
  ) {
    final aTime = a.time ?? '';
    final bTime = TimeOfDay.now().toString();

    return aTime.compareTo(bTime);
  }

  bool _isSameDate(
    DateTime? first,
    DateTime second,
  ) {
    if (first == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void clearError() {
    _errorMessage = null;
  }

  void dispose() {
    isLoading.dispose();
    isUpdating.dispose();
    selectedDate.dispose();
    slots.dispose();
  }
}