import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/repositories/session_repository.dart';
import 'package:physioghar/models/session.dart';

final sessionProvider =
    NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

class SessionState {
  const SessionState({
    this.isLoading = false,
    this.isUpdating = false,
    this.allSessions = const [],
    this.sessions = const [],
    this.selectedStatus = SessionStatus.requested,
    this.selectedSession,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isUpdating;

  final List<Session> allSessions;
  final List<Session> sessions;

  final SessionStatus selectedStatus;
  final Session? selectedSession;

  final String? errorMessage;

  SessionState copyWith({
    bool? isLoading,
    bool? isUpdating,
    List<Session>? allSessions,
    List<Session>? sessions,
    SessionStatus? selectedStatus,
    Session? selectedSession,
    bool clearSelectedSession = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SessionState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      allSessions: allSessions ?? this.allSessions,
      sessions: sessions ?? this.sessions,
      selectedStatus:
          selectedStatus ?? this.selectedStatus,
      selectedSession: clearSelectedSession
          ? null
          : selectedSession ?? this.selectedSession,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  late final SessionRepository _sessionRepository;

  @override
  SessionState build() {
    _sessionRepository = SessionRepository();

    return const SessionState();
  }

  Future<bool> loadSessions({
    SessionStatus? status,
    int? patientId,
  }) async {
    if (state.isLoading) {
      return false;
    }

    final effectiveStatus =
        status ?? state.selectedStatus;

    state = state.copyWith(
      isLoading: true,
      selectedStatus: effectiveStatus,
      sessions: const [],
      clearError: true,
    );

    try {
      final result =
          await _sessionRepository.getSessions(
        status: effectiveStatus,
        patientId: patientId,
      );

      final sortedSessions = List<Session>.from(result)
        ..sort(_compareSessions);

      state = state.copyWith(
        isLoading: false,
        sessions: sortedSessions,
        clearError: true,
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to load sessions: $error',
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Unable to load sessions.',
      );

      return false;
    }
  }

  Future<bool> loadAllSessions({
    int? patientId,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final result =
          await _sessionRepository.getSessions(
        patientId: patientId,
      );

      final sortedSessions = List<Session>.from(result)
        ..sort(_compareSessions);

      state = state.copyWith(
        isLoading: false,
        allSessions: sortedSessions,
        clearError: true,
      );

      _filterSessionsByStatus();

      return true;
    } catch (error) {
      debugPrint(
        'Failed to load all sessions: $error',
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Unable to load sessions.',
      );

      return false;
    }
  }

  Future<Session?> getSession(
    int sessionId,
  ) async {
    state = state.copyWith(
      clearError: true,
    );

    try {
      final result =
          await _sessionRepository.getSession(
        sessionId,
      );

      state = state.copyWith(
        selectedSession: result,
        clearError: true,
      );

      return result;
    } catch (error) {
      debugPrint(
        'Failed to load session details: $error',
      );

      state = state.copyWith(
        clearSelectedSession: true,
        errorMessage:
            'Unable to load session details.',
      );

      return null;
    }
  }

  Future<bool> selectStatus(
    SessionStatus status,
  ) async {
    state = state.copyWith(
      selectedStatus: status,
    );

    return loadSessions(
      status: status,
    );
  }

  // For test purpose only.
  Future<bool> createSession({
    required int patientId,
    required int scheduleSlotId,
    required String treatment,
    required String location,
    String? notes,
  }) async {
    return _performUpdate(() async {
      final newSession =
          await _sessionRepository.createSession(
        patientId: patientId,
        scheduleSlotId: scheduleSlotId,
        treatment: treatment,
        location: location,
        notes: notes,
      );

      _updateLocalSession(newSession);

      return true;
    });
  }

  Future<bool> acceptSession(
    int sessionId,
  ) async {
    return _performUpdate(() async {
      final updatedSession =
          await _sessionRepository.acceptSession(
        sessionId,
      );

      _updateLocalSession(updatedSession);

      return true;
    });
  }

  Future<bool> declineSession({
    required int sessionId,
    required String cancellationReason,
  }) async {
    return _performUpdate(() async {
      final updatedSession =
          await _sessionRepository.declineSession(
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
      final updatedSession =
          await _sessionRepository.rescheduleSession(
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
      final updated =
          await _sessionRepository.completeSession(
        sessionId: sessionId,
        notes: notes,
      );

      if (state.selectedSession?.id == updated.id) {
        state = state.copyWith(
          selectedSession: updated,
        );
      }

      _updateLocalSession(updated);

      return true;
    });
  }

  Future<bool> cancelSession({
    required int sessionId,
    required String cancellationReason,
  }) async {
    return _performUpdate(() async {
      final updated =
          await _sessionRepository.cancelSession(
        sessionId: sessionId,
        cancellationReason: cancellationReason,
      );

      if (state.selectedSession?.id == updated.id) {
        state = state.copyWith(
          selectedSession: updated,
        );
      }

      _updateLocalSession(updated);

      return true;
    });
  }

  Future<bool> _performUpdate(
    Future<bool> Function() action,
  ) async {
    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(
      isUpdating: true,
      clearError: true,
    );

    try {
      return await action();
    } catch (error) {
      debugPrint(
        'Failed to update session: $error',
      );

      state = state.copyWith(
        isUpdating: false,
        errorMessage:
            'Unable to update session.',
      );

      return false;
    } finally {
      if (state.isUpdating) {
        state = state.copyWith(
          isUpdating: false,
        );
      }
    }
  }

  void _updateLocalSession(
    Session updatedSession,
  ) {
    // Update currently opened detail session.
    if (state.selectedSession?.id ==
        updatedSession.id) {
      state = state.copyWith(
        selectedSession: updatedSession,
      );
    }

    // Update all sessions used by Dashboard.
    final updatedAllSessions =
        List<Session>.from(state.allSessions);

    final allIndex =
        updatedAllSessions.indexWhere(
      (item) => item.id == updatedSession.id,
    );

    if (allIndex != -1) {
      updatedAllSessions[allIndex] =
          updatedSession;
    } else {
      updatedAllSessions.add(updatedSession);
    }

    updatedAllSessions.sort(_compareSessions);

    // Update currently filtered sessions.
    final updatedSessions =
        List<Session>.from(state.sessions);

    final index =
        updatedSessions.indexWhere(
      (item) => item.id == updatedSession.id,
    );

    final currentStatus =
        state.selectedStatus;

    if (updatedSession.status != currentStatus) {
      if (index != -1) {
        updatedSessions.removeAt(index);
      }
    } else if (index != -1) {
      updatedSessions[index] =
          updatedSession;
    } else {
      updatedSessions.add(updatedSession);
    }

    updatedSessions.sort(_compareSessions);

    state = state.copyWith(
      allSessions: updatedAllSessions,
      sessions: updatedSessions,
    );
  }

  void _filterSessionsByStatus() {
    final filtered = state.allSessions
        .where(
          (session) =>
              session.status ==
              state.selectedStatus,
        )
        .toList();

    filtered.sort(_compareSessions);

    state = state.copyWith(
      sessions: filtered,
    );
  }

  int _compareSessions(
    Session a,
    Session b,
  ) {
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

    final dateComparison =
        aDate.compareTo(bDate);

    if (dateComparison != 0) {
      return dateComparison;
    }

    final aTime =
        _timeToMinutes(a.scheduleTime);

    final bTime =
        _timeToMinutes(b.scheduleTime);

    return aTime.compareTo(bTime);
  }

  int _timeToMinutes(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
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
    state = state.copyWith(
      clearError: true,
    );
  }

  void clearSelectedSession() {
    state = state.copyWith(
      clearSelectedSession: true,
    );
  }
}