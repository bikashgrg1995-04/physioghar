import 'package:flutter/foundation.dart';

import 'package:physioghar/data/repositories/session_repository.dart';
import 'package:physioghar/models/session.dart';

class SessionController {
  SessionController({SessionRepository? sessionRepository})
    : _sessionRepository = sessionRepository ?? SessionRepository();

  final SessionRepository _sessionRepository;

  final isLoading = ValueNotifier<bool>(false);
  final isUpdating = ValueNotifier<bool>(false);

  final sessions = ValueNotifier<List<Session>>([]);

  final selectedStatus = ValueNotifier<SessionStatus>(SessionStatus.requested);

  final selectedSession = ValueNotifier<Session?>(null);

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> loadSessions({SessionStatus? status}) async {
    if (isLoading.value) {
      return false;
    }

    isLoading.value = true;
    _errorMessage = null;

    try {
      final result = await _sessionRepository.getSessions(status: status);

      sessions.value = result;

      return true;
    } catch (error) {
      debugPrint('Failed to load sessions: $error');

      _errorMessage = 'Unable to load sessions.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Session?> getSession(int sessionId) async {
    try {
      _errorMessage = null;
      final result = await _sessionRepository.getSession(sessionId);
      selectedSession.value = result;
      return result;
    } catch (error) {
      debugPrint('Failed to load session details: $error');
      _errorMessage = 'Unable to load session details.';
      selectedSession.value = null;
      return null;
    }
  }

  Future<bool> selectStatus(SessionStatus status) async {
    selectedStatus.value = status;

    return loadSessions(status: status);
  }

  Future<bool> acceptSession(int sessionId) async {
    return _performUpdate(() async {
      final updatedSession = await _sessionRepository.acceptSession(sessionId);

      _updateLocalSession(updatedSession);

      return true;
    });
  }

  Future<bool> declineSession({
    required int sessionId,
    required String cancellationReason,
  }) async {
    return _performUpdate(() async {
      final updatedSession = await _sessionRepository.declineSession(
        sessionId: sessionId,
        cancellationReason: cancellationReason,
      );

      _updateLocalSession(updatedSession);

      return true;
    });
  }

  Future<bool> rescheduleSession({
    required int sessionId,
    required int scheduleSlotId,
  }) async {
    return _performUpdate(() async {
      final updatedSession = await _sessionRepository.rescheduleSession(
        sessionId: sessionId,
        scheduleSlotId: scheduleSlotId,
      );

      _updateLocalSession(updatedSession);

      return true;
    });
  }

  Future<bool> completeSession({
    required int sessionId,
    required String notes,
  }) async {
    return _performUpdate(() async {
      final updated = await _sessionRepository.completeSession(
        sessionId: sessionId,
        notes: notes,
      );

      // Update the currently opened detail session.
      if (selectedSession.value?.id == updated.id) {
        selectedSession.value = updated;
      }

      // Update the shared sessions list.
      // If the current tab is Upcoming,
      // _updateLocalSession() will remove it.
      _updateLocalSession(updated);

      return true;
    });
  }

  Future<bool> cancelSession({
    required int sessionId,
    required String cancellationReason,
  }) async {
    return _performUpdate(() async {
      final updated = await _sessionRepository.cancelSession(
        sessionId: sessionId,
        cancellationReason: cancellationReason,
      );

      // Update currently opened detail.
      if (selectedSession.value?.id == updated.id) {
        selectedSession.value = updated;
      }

      // Update shared session list.
      // Upcoming -> Cancelled means
      // the session is removed from Upcoming.
      _updateLocalSession(updated);

      return true;
    });
  }

  Future<bool> _performUpdate(Future<bool> Function() action) async {
    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;
    _errorMessage = null;

    try {
      return await action();
    } catch (error) {
      debugPrint('Session update failed: $error');

      _errorMessage = 'Unable to update session.';

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void _updateLocalSession(Session updatedSession) {
    // Update the currently opened detail session.
    if (selectedSession.value?.id == updatedSession.id) {
      selectedSession.value = updatedSession;
    }

    // Update the session list.
    final currentStatus = selectedStatus.value;

    final updatedSessions = List<Session>.from(sessions.value);

    final index = updatedSessions.indexWhere(
      (item) => item.id == updatedSession.id,
    );

    if (updatedSession.status != currentStatus) {
      if (index != -1) {
        updatedSessions.removeAt(index);
      }
    } else {
      if (index != -1) {
        updatedSessions[index] = updatedSession;
      } else {
        updatedSessions.add(updatedSession);
      }
    }

    updatedSessions.sort(_compareSessions);

    sessions.value = updatedSessions;
  }

  int _compareSessions(Session a, Session b) {
    final aDate = a.scheduleDate;
    final bDate = b.scheduleDate;

    if (aDate == null && bDate == null) {
      return 0;
    }

    if (aDate == null) {
      return 1;
    }

    if (bDate == null) {
      return -1;
    }

    final dateComparison = aDate.compareTo(bDate);

    if (dateComparison != 0) {
      return dateComparison;
    }

    final aTime = _timeToMinutes(a.scheduleTime);

    final bTime = _timeToMinutes(b.scheduleTime);

    return aTime.compareTo(bTime);
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

  void clearError() {
    _errorMessage = null;
  }

  void dispose() {
    isLoading.dispose();
    isUpdating.dispose();
    sessions.dispose();
    selectedStatus.dispose();
  }
}

final sessionController = SessionController();
