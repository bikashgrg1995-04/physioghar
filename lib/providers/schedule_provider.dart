import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/data/mock_data.dart';
import 'package:physioghar/models/schedule_slot.dart';

class ScheduleNotifier extends Notifier<List<ScheduleSlot>> {
  @override
  List<ScheduleSlot> build() {
    final today = DateTime.now();

    final startDate = DateTime(today.year, today.month, today.day);

    return MockData.scheduleSlots.map((mockSlot) {
      final hour = mockSlot['time'] as int;

      return ScheduleSlot(
        id: 'slot_$hour',
        dateTime: DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          hour,
        ),
        status: mockSlot['status'] as ScheduleSlotStatus,
        sessionId: mockSlot['sessionId']?.toString(),
      );
    }).toList();
  }

  void blockSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId)
          slot.copyWith(status: ScheduleSlotStatus.blocked)
        else
          slot,
    ];
  }

  void unblockSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId)
          slot.copyWith(status: ScheduleSlotStatus.open)
        else
          slot,
    ];
  }

  void addSlot(DateTime dateTime) {
    final alreadyExists = state.any(
      (slot) =>
          DateTimeUtils.isSameDay(slot.dateTime, dateTime) &&
          slot.dateTime.hour == dateTime.hour &&
          slot.dateTime.minute == dateTime.minute,
    );

    if (alreadyExists) {
      return;
    }

    final newSlot = ScheduleSlot(
      id: 'slot_${DateTime.now().microsecondsSinceEpoch}',
      dateTime: dateTime,
      status: ScheduleSlotStatus.open,
    );

    state = [...state, newSlot]
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  void deleteSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id != slotId) slot,
    ];
  }
}

final scheduleProvider = NotifierProvider<ScheduleNotifier, List<ScheduleSlot>>(
  ScheduleNotifier.new,
);
