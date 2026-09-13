import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/models/schedule_slot.dart';

class ScheduleNotifier extends Notifier<List<ScheduleSlot>> {
  @override
  List<ScheduleSlot> build() {
    final today = DateTime.now();

    final startDate = DateTime(today.year, today.month, today.day);

    // Find the next Monday within today + next 6 days.
    final daysUntilMonday = (DateTime.monday - startDate.weekday + 7) % 7;

    final monday = startDate.add(Duration(days: daysUntilMonday));

    DateTime mondayAt(int hour) {
      return DateTime(monday.year, monday.month, monday.day, hour);
    }

    return [
      // Monday - mock schedule data
      ScheduleSlot(
        id: 'slot_001',
        dateTime: mondayAt(9),
        status: ScheduleSlotStatus.open,
      ),
      ScheduleSlot(
        id: 'slot_002',
        dateTime: mondayAt(10),
        status: ScheduleSlotStatus.booked,
        sessionId: 'schedule_session_001',
      ),
      ScheduleSlot(
        id: 'slot_003',
        dateTime: mondayAt(11),
        status: ScheduleSlotStatus.open,
      ),
      ScheduleSlot(
        id: 'slot_004',
        dateTime: mondayAt(12),
        status: ScheduleSlotStatus.blocked,
      ),
      ScheduleSlot(
        id: 'slot_005',
        dateTime: mondayAt(13),
        status: ScheduleSlotStatus.blocked,
      ),
    ];
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

  // Update the status of a slot to booked when a session is booked for that slot.
  //specially, when request is accepted, the slot should be marked as booked.

  void bookSlotForSession(String sessionId, DateTime dateTime) {
    final existingSlot = state.where((slot) {
      return slot.sessionId == sessionId;
    }).firstOrNull;

    if (existingSlot != null) {
      state = [
        for (final slot in state)
          if (slot.id == existingSlot.id)
            slot.copyWith(status: ScheduleSlotStatus.booked)
          else
            slot,
      ];

      return;
    }

    // If the session does not already have a schedule slot,
    // create a booked slot for the session.
    final newSlot = ScheduleSlot(
      id: 'slot_${DateTime.now().microsecondsSinceEpoch}',
      dateTime: dateTime,
      status: ScheduleSlotStatus.booked,
      sessionId: sessionId,
    );

    state = [...state, newSlot]
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}

final scheduleProvider = NotifierProvider<ScheduleNotifier, List<ScheduleSlot>>(
  ScheduleNotifier.new,
);
