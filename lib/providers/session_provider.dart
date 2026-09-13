import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/data/mock_data.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/schedule_provider.dart';

class SessionNotifier extends Notifier<List<Session>> {
  @override
  List<Session> build() {
    final today = DateTime.now();

    final todayDate = DateTime(today.year, today.month, today.day);

    final daysUntilMonday = (DateTime.monday - todayDate.weekday + 7) % 7;

    final monday = todayDate.add(Duration(days: daysUntilMonday));

    final dashboardSessions = MockData.dashboardSessions.map((session) {
      return session.copyWith(
        dateTime: DateTime(
          todayDate.year,
          todayDate.month,
          todayDate.day,
          session.dateTime.hour,
          session.dateTime.minute,
        ),
      );
    });

    // Convert mock schedule session time to the upcoming Monday dynamically.
    final scheduleSessions = MockData.scheduleSessions.map((session) {
      return session.copyWith(
        dateTime: DateTime(
          monday.year,
          monday.month,
          monday.day,
          session.dateTime.hour,
          session.dateTime.minute,
        ),
      );
    });

    // Convert mock booking request time to today's date dynamically.
    final bookingRequests = MockData.bookingRequests.map((session) {
      return session.copyWith(
        dateTime: DateTime(
          todayDate.year,
          todayDate.month,
          todayDate.day,
          session.dateTime.hour,
          session.dateTime.minute,
        ),
      );
    });

    return [...dashboardSessions, ...scheduleSessions, ...bookingRequests];
  }

  // Accept a session and update its status to upcoming. Also, book the corresponding schedule slot for the session.
  void acceptSession(String sessionId) {
    Session? selectedSession;

    for (final session in state) {
      if (session.id == sessionId) {
        selectedSession = session;
        break;
      }
    }

    if (selectedSession == null) {
      return;
    }

    updateSessionStatus(sessionId, SessionStatus.upcoming);

    ref
        .read(scheduleProvider.notifier)
        .bookSlotForSession(sessionId, selectedSession.dateTime);
  }

  void declineSession(String sessionId) {
    updateSessionStatus(sessionId, SessionStatus.cancelled);

    ref.read(scheduleProvider.notifier).releaseSlotForSession(sessionId);
  }

  void completeSession(String sessionId) {
    updateSessionStatus(sessionId, SessionStatus.completed);

    ref.read(scheduleProvider.notifier).releaseSlotForSession(sessionId);
  }

  // Reschedule a session to a new date/time and synchronize the related schedule slot.
  // This method updates the session's date/time and also updates the corresponding schedule slot to reflect the new date/time.
  void rescheduleSession(
  String sessionId,
  DateTime newDateTime,
) {
  final selectedSession = state
      .where((session) => session.id == sessionId)
      .firstOrNull;

  if (selectedSession == null) {
    return;
  }

  state = [
    for (final session in state)
      if (session.id == sessionId)
        session.copyWith(
          dateTime: newDateTime,
          status: SessionStatus.upcoming,
        )
      else
        session,
  ];

  ref.read(scheduleProvider.notifier).rescheduleSlot(
    sessionId,
    newDateTime,
  );
}
  void updateSessionStatus(String sessionId, SessionStatus status) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(status: status)
        else
          session,
    ];
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, List<Session>>(
  SessionNotifier.new,
);
