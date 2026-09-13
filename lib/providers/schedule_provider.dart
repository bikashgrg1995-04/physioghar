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

bool addSlot(DateTime dateTime) {
  final alreadyExists = state.any(
    (slot) =>
        slot.dateTime.year == dateTime.year &&
        slot.dateTime.month == dateTime.month &&
        slot.dateTime.day == dateTime.day &&
        slot.dateTime.hour == dateTime.hour &&
        slot.dateTime.minute == dateTime.minute,
  );

  if (alreadyExists) {
    return false;
  }

  final newSlot = ScheduleSlot(
    id: 'slot_${DateTime.now().microsecondsSinceEpoch}',
    dateTime: dateTime,
    status: ScheduleSlotStatus.open,
  );

  state = [
    ...state,
    newSlot,
  ]..sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );

  return true;
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
    // Check whether this session already has a slot.
    final existingSessionSlot = state.where((slot) {
      return slot.sessionId == sessionId;
    }).firstOrNull;

    if (existingSessionSlot != null) {
      state = [
        for (final slot in state)
          if (slot.id == existingSessionSlot.id)
            slot.copyWith(status: ScheduleSlotStatus.booked)
          else
            slot,
      ];

      return;
    }

    // Check whether a slot already exists at the requested date/time.
    final existingTimeSlot = state.where((slot) {
      return slot.dateTime.year == dateTime.year &&
          slot.dateTime.month == dateTime.month &&
          slot.dateTime.day == dateTime.day &&
          slot.dateTime.hour == dateTime.hour &&
          slot.dateTime.minute == dateTime.minute;
    }).firstOrNull;

    if (existingTimeSlot != null) {
      // Only OPEN slots can be booked.
      if (existingTimeSlot.status != ScheduleSlotStatus.open) {
        return;
      }

      state = [
        for (final slot in state)
          if (slot.id == existingTimeSlot.id)
            slot.copyWith(
              status: ScheduleSlotStatus.booked,
              sessionId: sessionId,
            )
          else
            slot,
      ];

      return;
    }

    // No slot exists at this time, so create a new BOOKED slot.
    final newSlot = ScheduleSlot(
      id: 'slot_${DateTime.now().microsecondsSinceEpoch}',
      dateTime: dateTime,
      status: ScheduleSlotStatus.booked,
      sessionId: sessionId,
    );

    state = [...state, newSlot]
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  // Release the schedule slot when the related session is
  // declined or completed.
  void releaseSlotForSession(String sessionId) {
    state = [
      for (final slot in state)
        if (slot.sessionId == sessionId)
          slot.copyWith(status: ScheduleSlotStatus.open, sessionId: null)
        else
          slot,
    ];
  }

  // Reschedule a session to a new date/time and synchronize the related schedule slot.
  // This method updates the session's date/time and also updates the corresponding schedule slot to reflect

  void rescheduleSlot(String sessionId, DateTime newDateTime) {
    // Find the slot currently assigned to this session.
    final oldSlot = state.where((slot) {
      return slot.sessionId == sessionId;
    }).firstOrNull;

    // Find an existing slot at the requested date/time.
    final targetSlot = state.where((slot) {
      return slot.dateTime.year == newDateTime.year &&
          slot.dateTime.month == newDateTime.month &&
          slot.dateTime.day == newDateTime.day &&
          slot.dateTime.hour == newDateTime.hour &&
          slot.dateTime.minute == newDateTime.minute;
    }).firstOrNull;

    // The target slot must be OPEN if it already exists.
    if (targetSlot != null && targetSlot.status != ScheduleSlotStatus.open) {
      return;
    }

    state = [
      for (final slot in state)
        // Release the old slot.
        if (oldSlot != null && slot.id == oldSlot.id)
          slot.copyWith(status: ScheduleSlotStatus.open, sessionId: null)
        // Reuse the existing target slot.
        else if (targetSlot != null && slot.id == targetSlot.id)
          slot.copyWith(status: ScheduleSlotStatus.booked, sessionId: sessionId)
        else
          slot,
    ];

    // If there was no existing target slot, create exactly one.
    if (targetSlot == null) {
      final newSlot = ScheduleSlot(
        id: 'slot_${DateTime.now().microsecondsSinceEpoch}',
        dateTime: newDateTime,
        status: ScheduleSlotStatus.booked,
        sessionId: sessionId,
      );

      state = [...state, newSlot]
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
  }
}

final scheduleProvider = NotifierProvider<ScheduleNotifier, List<ScheduleSlot>>(
  ScheduleNotifier.new,
);
