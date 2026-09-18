import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/providers/session_provider.dart';
import 'package:physioghar/data/providers/therapist_provider.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/models/therapist.dart';

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

class DashboardState {
  const DashboardState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  DashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return const DashboardState();
  }

  // ---------------------------------------------------------------------------
  // Therapist Data
  // ---------------------------------------------------------------------------

  Therapist? get therapist => ref.read(therapistProvider).therapist;

  bool get isAvailable => therapist?.isAvailable ?? false;

  // ---------------------------------------------------------------------------
  // Session Data
  // ---------------------------------------------------------------------------

  List<Session> get sessions => ref.read(sessionProvider).allSessions;

  // ---------------------------------------------------------------------------
  // Dashboard Session Filters
  // ---------------------------------------------------------------------------

  DateTime get today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

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

  List<Session> get upcomingRequests {
    final result = sessions
        .where((session) => session.status == SessionStatus.requested)
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  List<Session> get upcomingSessions {
    final result = sessions
        .where((session) => session.status == SessionStatus.upcoming)
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  List<Session> get completedSessions {
    final result = sessions
        .where((session) => session.status == SessionStatus.completed)
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
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final results = await Future.wait<bool>([
        _loadTherapist(),
        _loadSessions(),
      ]);

      final success = results.every((result) => result);

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load dashboard data.',
        );

        return false;
      }

      state = state.copyWith(isLoading: false, clearError: true);

      return true;
    } catch (error) {
      debugPrint('Failed to load dashboard: $error');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load dashboard data.',
      );

      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Therapist
  // ---------------------------------------------------------------------------

  Future<bool> _loadTherapist() async {
    try {
      await ref.read(therapistProvider.notifier).loadProfile();

      return true;
    } catch (error) {
      debugPrint('Failed to load therapist: $error');

      return false;
    }
  }

  Future<void> updateAvailability(bool value) async {
    await ref.read(therapistProvider.notifier).updateAvailability(value);
  }

  // ---------------------------------------------------------------------------
  // Sessions
  // ---------------------------------------------------------------------------

  Future<bool> _loadSessions() async {
    try {
      return await ref.read(sessionProvider.notifier).loadAllSessions();
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
    return ref.read(sessionProvider.notifier).getSession(sessionId);
  }

  Future<bool> acceptSession(int sessionId) {
    return ref.read(sessionProvider.notifier).acceptSession(sessionId);
  }

  Future<bool> declineSession({
    required int sessionId,
    required String cancellationReason,
  }) {
    return ref
        .read(sessionProvider.notifier)
        .declineSession(
          sessionId: sessionId,
          cancellationReason: cancellationReason,
        );
  }

  Future<bool> rescheduleSession({
    required int sessionId,
    required int scheduleSlotId,
  }) {
    return ref
        .read(sessionProvider.notifier)
        .rescheduleSession(
          sessionId: sessionId,
          scheduleSlotId: scheduleSlotId,
        );
  }

  Future<bool> completeSession({
    required int sessionId,
    required String notes,
  }) {
    return ref
        .read(sessionProvider.notifier)
        .completeSession(sessionId: sessionId, notes: notes);
  }

  Future<bool> cancelSession({
    required int sessionId,
    required String cancellationReason,
  }) {
    return ref
        .read(sessionProvider.notifier)
        .cancelSession(
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

    final aDay = DateTime(aDate.year, aDate.month, aDate.day);

    final bDay = DateTime(bDate.year, bDate.month, bDate.day);

    final dateComparison = aDay.compareTo(bDay);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return _compareTime(a.scheduleTime, b.scheduleTime);
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
    state = state.copyWith(clearError: true);
  }
}
