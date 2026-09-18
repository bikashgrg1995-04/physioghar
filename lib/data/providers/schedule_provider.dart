import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/repositories/schedule_repository.dart';
import 'package:physioghar/models/schedule_slot.dart';

final scheduleProvider = NotifierProvider<ScheduleNotifier, ScheduleState>(
  ScheduleNotifier.new,
);

class ScheduleState {
  const ScheduleState({
    this.isLoading = false,
    this.isUpdating = false,
    required this.selectedDate,
    this.slots = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final bool isUpdating;
  final DateTime selectedDate;
  final List<ScheduleSlot> slots;
  final String? errorMessage;

  ScheduleState copyWith({
    bool? isLoading,
    bool? isUpdating,
    DateTime? selectedDate,
    List<ScheduleSlot>? slots,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      selectedDate: selectedDate ?? this.selectedDate,
      slots: slots ?? this.slots,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ScheduleNotifier extends Notifier<ScheduleState> {
  late final ScheduleRepository _scheduleRepository;

  @override
  ScheduleState build() {
    _scheduleRepository = ScheduleRepository();

    return ScheduleState(selectedDate: DateTime.now());
  }


  Future<bool> loadSchedules({DateTime? date}) async {
    if (state.isLoading) {
      return false;
    }

    final dateToLoad = date ?? state.selectedDate;

    state = state.copyWith(
      selectedDate: dateToLoad,
      isLoading: true,
      clearError: true,
    );

    try {
      final result = await _scheduleRepository.getSchedules(date: dateToLoad);

      state = state.copyWith(isLoading: false, slots: result, clearError: true);

      return true;
    } catch (error) {
      debugPrint('Failed to load schedules: $error');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load schedule.',
      );

      return false;
    }
  }


  Future<bool> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date, clearError: true);

    return loadSchedules(date: date);
  }


  Future<bool> addSlot({required DateTime date, required String time}) async {
    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final newSlot = await _scheduleRepository.createSchedule(
        date: date,
        time: time,
        status: ScheduleSlotStatus.open,
      );

      if (_isSameDate(newSlot.date, state.selectedDate)) {
        final updatedSlots = List<ScheduleSlot>.from(state.slots)
          ..add(newSlot)
          ..sort(_compareSlots);

        state = state.copyWith(slots: updatedSlots);
      }

      return true;
    } catch (error) {
      debugPrint('Failed to add schedule slot: $error');

      state = state.copyWith(errorMessage: 'Unable to add schedule slot.');

      return false;
    } finally {
      state = state.copyWith(isUpdating: false);
    }
  }

  Future<bool> updateSlot({
    required ScheduleSlot slot,
    ScheduleSlotStatus? status,
    String? time,
    DateTime? date,
  }) async {
    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final updatedSlot = await _scheduleRepository.updateSchedule(
        scheduleId: slot.id!,
        status: status,
        time: time,
        date: date,
      );

      final index = state.slots.indexWhere((item) => item.id == slot.id);

      if (index == -1) {
        return false;
      }

      final updatedSlots = state.slots
          .where((item) => item.id != slot.id)
          .toList();

      if (_isSameDate(updatedSlot.date, state.selectedDate)) {
        updatedSlots.add(updatedSlot);
      }

      updatedSlots.sort(_compareSlots);

      state = state.copyWith(slots: updatedSlots);

      return true;
    } catch (error) {
      debugPrint('Failed to update schedule slot: $error');

      state = state.copyWith(errorMessage: 'Unable to update schedule.');

      return false;
    } finally {
      state = state.copyWith(isUpdating: false);
    }
  }

  Future<bool> blockSlot(ScheduleSlot slot) async {
    return updateSlot(slot: slot, status: ScheduleSlotStatus.blocked);
  }

  Future<bool> unblockSlot(ScheduleSlot slot) async {
    return updateSlot(slot: slot, status: ScheduleSlotStatus.open);
  }

  Future<bool> deleteSlot(ScheduleSlot slot) async {
    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      await _scheduleRepository.deleteSchedule(slot.id!);

      final updatedSlots = state.slots
          .where((item) => item.id != slot.id)
          .toList();

      state = state.copyWith(
        isUpdating: false,
        slots: updatedSlots,
        clearError: true,
      );

      return true;
    } catch (error) {
      debugPrint('Failed to delete schedule slot: $error');

      state = state.copyWith(
        isUpdating: false,
        errorMessage: 'Unable to delete schedule slot.',
      );

      return false;
    }
  }


  int _compareSlots(ScheduleSlot a, ScheduleSlot b) {
    final aTime = a.time ?? '';
    final bTime = b.time ?? '';

    return aTime.compareTo(bTime);
  }

  bool _isSameDate(DateTime? first, DateTime second) {
    if (first == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
