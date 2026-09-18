
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/repositories/patient_repository.dart';
import 'package:physioghar/data/repositories/session_repository.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/models/patient_note.dart';
import 'package:physioghar/models/session.dart';

final patientProvider =
    NotifierProvider<PatientNotifier, PatientState>(
  PatientNotifier.new,
);

class PatientState {
  const PatientState({
    this.isLoading = false,
    this.isUpdating = false,
    this.patients = const [],
    this.notes = const [],
    this.selectedPatient,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isUpdating;
  final List<Patient> patients;
  final List<PatientNote> notes;
  final Patient? selectedPatient;
  final String? errorMessage;

  PatientState copyWith({
    bool? isLoading,
    bool? isUpdating,
    List<Patient>? patients,
    List<PatientNote>? notes,
    Patient? selectedPatient,
    bool clearSelectedPatient = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PatientState(
      isLoading:
          isLoading ?? this.isLoading,
      isUpdating:
          isUpdating ?? this.isUpdating,
      patients:
          patients ?? this.patients,
      notes:
          notes ?? this.notes,
      selectedPatient:
          clearSelectedPatient
              ? null
              : selectedPatient ??
                  this.selectedPatient,
      errorMessage:
          clearError
              ? null
              : errorMessage ??
                  this.errorMessage,
    );
  }
}

class PatientNotifier
    extends Notifier<PatientState> {
  late final PatientRepository _patientRepository;
  late final SessionRepository _sessionRepository;

  @override
  PatientState build() {
    _patientRepository =
        PatientRepository();

    _sessionRepository =
        SessionRepository();

    return const PatientState();
  }

  Future<void> loadPatients() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final result =
          await _patientRepository.getPatients();

      state = state.copyWith(
        isLoading: false,
        patients: result,
        clearError: true,
      );
    } catch (error) {
      debugPrint(
        'Failed to load patients: $error',
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Unable to load patients.',
      );
    }
  }

  Future<void> loadPatient(
    int patientId,
  ) async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      notes: const [],
      clearSelectedPatient: true,
      clearError: true,
    );

    try {
      final result =
          await _patientRepository.getPatient(
        patientId,
      );

      state = state.copyWith(
        selectedPatient: result,
      );

      await loadNotes(patientId);
    } catch (error) {
      debugPrint(
        'Failed to load patient details: $error',
      );

      state = state.copyWith(
        clearSelectedPatient: true,
        notes: const [],
        errorMessage:
            'Unable to load patient details.',
      );
    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  Future<List<Session>> loadPatientSessions(
    int patientId,
  ) async {
    try {
      return await _sessionRepository.getSessions(
        patientId: patientId,
      );
    } catch (error) {
      debugPrint(
        'Failed to load patient sessions: $error',
      );

      return [];
    }
  }

  Future<void> loadNotes(
    int patientId,
  ) async {
    try {
      final result =
          await _patientRepository.getPatientNotes(
        patientId,
      );

      state = state.copyWith(
        notes: result,
        clearError: true,
      );
    } catch (error) {
      debugPrint(
        'Failed to load patient notes: $error',
      );

      state = state.copyWith(
        notes: const [],
        errorMessage:
            'Unable to load patient notes.',
      );
    }
  }

  Future<bool> addNote({
    required int patientId,
    required String content,
  }) async {
    final trimmedContent =
        content.trim();

    if (trimmedContent.isEmpty) {
      state = state.copyWith(
        errorMessage:
            'Note cannot be empty.',
      );

      return false;
    }

    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(
      isUpdating: true,
      clearError: true,
    );

    try {
      final newNote =
          await _patientRepository
              .createPatientNote(
        patientId: patientId,
        content: trimmedContent,
      );

      state = state.copyWith(
        isUpdating: false,
        notes: [
          newNote,
          ...state.notes,
        ],
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to add patient note: $error',
      );

      state = state.copyWith(
        isUpdating: false,
        errorMessage:
            'Unable to add note.',
      );

      return false;
    }
  }

  Future<bool> editNote({
    required int patientId,
    required int noteId,
    required String content,
  }) async {
    final trimmedContent =
        content.trim();

    if (trimmedContent.isEmpty) {
      state = state.copyWith(
        errorMessage:
            'Note cannot be empty.',
      );

      return false;
    }

    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(
      isUpdating: true,
      clearError: true,
    );

    try {
      final updatedNote =
          await _patientRepository
              .updatePatientNote(
        patientId: patientId,
        noteId: noteId,
        content: trimmedContent,
      );

      final currentNotes =
          List<PatientNote>.from(
        state.notes,
      );

      final index =
          currentNotes.indexWhere(
        (note) => note.id == noteId,
      );

      if (index != -1) {
        currentNotes[index] =
            updatedNote;
      }

      state = state.copyWith(
        isUpdating: false,
        notes: currentNotes,
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to update patient note: $error',
      );

      state = state.copyWith(
        isUpdating: false,
        errorMessage:
            'Unable to update note.',
      );

      return false;
    }
  }

  Future<bool> deleteNote({
    required int patientId,
    required int noteId,
  }) async {
    if (state.isUpdating) {
      return false;
    }

    state = state.copyWith(
      isUpdating: true,
      clearError: true,
    );

    try {
      await _patientRepository
          .deletePatientNote(
        patientId: patientId,
        noteId: noteId,
      );

      state = state.copyWith(
        isUpdating: false,
        notes: state.notes
            .where(
              (note) => note.id != noteId,
            )
            .toList(),
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to delete patient note: $error',
      );

      state = state.copyWith(
        isUpdating: false,
        errorMessage:
            'Unable to delete note.',
      );

      return false;
    }
  }

  void clearNotes() {
    state = state.copyWith(
      notes: const [],
    );
  }

  void clearSelectedPatient() {
    state = state.copyWith(
      clearSelectedPatient: true,
      notes: const [],
    );
  }

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }
}