import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/data/mock_data.dart';
import 'package:physioghar/models/session.dart';

class SessionNotifier extends Notifier<List<Session>> {
  @override
  List<Session> build() {
    return MockData.sessions;
  }

  void acceptSession(String sessionId) {
    updateSessionStatus(
      sessionId,
      SessionStatus.upcoming,
    );
  }

  void declineSession(String sessionId) {
    updateSessionStatus(
      sessionId,
      SessionStatus.cancelled,
    );
  }

  void completeSession(String sessionId) {
    updateSessionStatus(
      sessionId,
      SessionStatus.completed,
    );
  }

  void rescheduleSession(
    String sessionId,
    DateTime newDateTime,
  ) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(
            dateTime: newDateTime,
          )
        else
          session,
    ];
  }

  void updateSessionStatus(
    String sessionId,
    SessionStatus status,
  ) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(status: status)
        else
          session,
    ];
  }
}

final sessionProvider =
    NotifierProvider<SessionNotifier, List<Session>>(
  SessionNotifier.new,
);