
import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/schedule_provider.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test(
    'accepting a booking updates session and schedule state',
    () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      // Read initial session state.
      final initialSessions = container.read(sessionProvider);

      final request = initialSessions.firstWhere(
        (session) => session.id == 'request_session_001',
      );

      expect(request.status, SessionStatus.requested);

      // Accept the booking.
      container
          .read(sessionProvider.notifier)
          .acceptSession(request.id);

      // Session should now be upcoming.
      final updatedSessions = container.read(sessionProvider);

      final updatedSession = updatedSessions.firstWhere(
        (session) => session.id == request.id,
      );

      expect(
        updatedSession.status,
        SessionStatus.upcoming,
      );

      // Schedule should now contain a booked slot
      // for the accepted session.
      final schedule = container.read(scheduleProvider);

      final bookedSlot = schedule.firstWhere(
        (slot) => slot.sessionId == request.id,
      );

      expect(
        bookedSlot.status,
        ScheduleSlotStatus.booked,
      );

      expect(
        bookedSlot.dateTime,
        updatedSession.dateTime,
      );
    },
  );
}