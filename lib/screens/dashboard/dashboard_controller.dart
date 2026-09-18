import 'package:flutter/foundation.dart';

import 'package:physioghar/models/session.dart';
import 'package:physioghar/models/therapist.dart';
import 'package:physioghar/screens/profile/therapist_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';

class DashboardController {
  DashboardController({
    required this._therapistController,
    required this._sessionController,
  });

  // ---------------------------------------------------------------------------
  // Shared Controllers
  // ---------------------------------------------------------------------------

  final TherapistController _therapistController;
  final SessionController _sessionController;

  TherapistController get therapistController => _therapistController;

  SessionController get sessionController => _sessionController;

  // ---------------------------------------------------------------------------
  // Dashboard State
  // ---------------------------------------------------------------------------

  final isLoading = ValueNotifier<bool>(false);

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ---------------------------------------------------------------------------
  // Therapist Data
  // ---------------------------------------------------------------------------

  Therapist? get therapist => _therapistController.therapist.value;

  bool get isAvailable => therapist?.isAvailable ?? false;

  // ---------------------------------------------------------------------------
  // All Session Data in dashboard
  // ---------------------------------------------------------------------------

  List<Session> get sessions => _sessionController.allSessions.value;
  // ---------------------------------------------------------------------------
  // Dashboard Session Filters
  // ---------------------------------------------------------------------------

  DateTime get today {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  /// Upcoming sessions scheduled for today.
  List<Session> get todaySessions {
    final result = sessions
        .where(
          (session) =>
              session.status == SessionStatus.upcoming &&
              _isSameDay(session.scheduleDate, today),
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  /// Sessions waiting for therapist approval.
  List<Session> get upcomingRequests {
    final result = sessions
        .where(
          (session) => session.status == SessionStatus.requested,
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  /// Accepted upcoming sessions.
  List<Session> get upcomingSessions {
    final result = sessions
        .where(
          (session) => session.status == SessionStatus.upcoming,
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  /// Completed sessions.
  List<Session> get completedSessions {
    final result = sessions
        .where(
          (session) => session.status == SessionStatus.completed,
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  // ---------------------------------------------------------------------------
  // Dashboard Counts
  // ---------------------------------------------------------------------------

  int get todaySessionsCount => todaySessions.length;

  int get upcomingRequestsCount => upcomingRequests.length;

  int get completedSessionsCount => completedSessions.length;

  // ---------------------------------------------------------------------------
  // Load Dashboard
  // ---------------------------------------------------------------------------

  Future<bool> loadDashboard() async {
    if (isLoading.value) {
      return false;
    }

    isLoading.value = true;
    _errorMessage = null;

    try {
      final results = await Future.wait<bool>([
        _loadTherapist(),
        _loadSessions(),
      ]);

      final success = results.every((result) => result);

      if (!success) {
        _errorMessage = 'Unable to load dashboard data.';
      }

      return success;
    } catch (error) {
      debugPrint('Failed to load dashboard: $error');

      _errorMessage = 'Unable to load dashboard data.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Therapist
  // ---------------------------------------------------------------------------

  Future<bool> _loadTherapist() async {
    try {
      await _therapistController.loadProfile();

      return true;
    } catch (error) {
      debugPrint('Failed to load therapist: $error');

      return false;
    }
  }

  Future<void> updateAvailability(bool value) async {
    await _therapistController.updateAvailability(value);
  }

  // ---------------------------------------------------------------------------
  // Sessions
  // ---------------------------------------------------------------------------

  Future<bool> _loadSessions() async {
    try {
      return await _sessionController.loadAllSessions();
    } catch (error) {
      debugPrint('Failed to load sessions: $error');

      return false;
    }
  }

  Session? findSession(int sessionId) {
    for (final session in sessions) {
      if (session.id == sessionId) {
        return session;
      }
    }

    return null;
  }

  Future<Session?> getSession(int sessionId) {
    return _sessionController.getSession(sessionId);
  }

  Future<bool> acceptSession(int sessionId) {
    return _sessionController.acceptSession(sessionId);
  }

  Future<bool> declineSession({
    required int sessionId,
    required String cancellationReason,
  }) {
    return _sessionController.declineSession(
      sessionId: sessionId,
      cancellationReason: cancellationReason,
    );
  }

  Future<bool> rescheduleSession({
    required int sessionId,
    required int scheduleSlotId,
  }) {
    return _sessionController.rescheduleSession(
      sessionId: sessionId,
      scheduleSlotId: scheduleSlotId,
    );
  }

  Future<bool> completeSession({
    required int sessionId,
    required String notes,
  }) {
    return _sessionController.completeSession(
      sessionId: sessionId,
      notes: notes,
    );
  }

  Future<bool> cancelSession({
    required int sessionId,
    required String cancellationReason,
  }) {
    return _sessionController.cancelSession(
      sessionId: sessionId,
      cancellationReason: cancellationReason,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool _isSameDay(DateTime? first, DateTime second) {
    if (first == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  int _compareSessions(Session a, Session b) {
    final aDate = a.scheduleDate;
    final bDate = b.scheduleDate;

    if (aDate == null && bDate == null) {
      return _compareTime(a.scheduleTime, b.scheduleTime);
    }

    if (aDate == null) {
      return 1;
    }

    if (bDate == null) {
      return -1;
    }

    final aDay = DateTime(
      aDate.year,
      aDate.month,
      aDate.day,
    );

    final bDay = DateTime(
      bDate.year,
      bDate.month,
      bDate.day,
    );

    final dateComparison = aDay.compareTo(bDay);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return _compareTime(
      a.scheduleTime,
      b.scheduleTime,
    );
  }

  int _compareTime(String? first, String? second) {
    final firstMinutes = _timeToMinutes(first);
    final secondMinutes = _timeToMinutes(second);

    return firstMinutes.compareTo(secondMinutes);
  }

  int _timeToMinutes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 999999;
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return 999999;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return 999999;
    }

    return hour * 60 + minute;
  }

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------

  void clearError() {
    _errorMessage = null;
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  void dispose() {
    // Do NOT dispose therapistController or sessionController here.
    // They are shared/global controllers and are owned elsewhere.

    isLoading.dispose();
  }
}