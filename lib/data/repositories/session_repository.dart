import 'package:physioghar/data/services/session_service.dart';
import 'package:physioghar/models/session.dart';

class SessionRepository {
  SessionRepository({SessionService? sessionService})
    : _sessionService = sessionService ?? SessionService();

  final SessionService _sessionService;

  Future<List<Session>> getSessions({SessionStatus? status, int? patientId}) {
    return _sessionService.getSessions(status: status, patientId: patientId);
  }

  Future<Session> getSession(int sessionId) {
    return _sessionService.getSession(sessionId);
  }

  Future<Session> createSession({
    required int patientId,
    required int scheduleSlotId,
    required String treatment,
    required String location,
    String? notes,
  }) {
    return _sessionService.createSession(
      patientId: patientId,
      scheduleSlotId: scheduleSlotId,
      treatment: treatment,
      location: location,
      notes: notes,
    );
  }

  Future<Session> acceptSession(int sessionId) {
    return _sessionService.acceptSession(sessionId);
  }

  Future<Session> declineSession({
    required int sessionId,
    required String cancellationReason,
  }) {
    return _sessionService.declineSession(
      sessionId: sessionId,
      cancellationReason: cancellationReason,
    );
  }

  Future<Session> rescheduleSession({
    required int sessionId,
    required int scheduleSlotId,
  }) {
    return _sessionService.rescheduleSession(
      sessionId: sessionId,
      scheduleSlotId: scheduleSlotId,
    );
  }

  Future<Session> completeSession({
    required int sessionId,
    required String notes,
  }) {
    return _sessionService.completeSession(sessionId: sessionId, notes: notes);
  }

  Future<Session> cancelSession({
    required int sessionId,
    required String cancellationReason,
  }) {
    return _sessionService.cancelSession(
      sessionId: sessionId,
      cancellationReason: cancellationReason,
    );
  }
}
