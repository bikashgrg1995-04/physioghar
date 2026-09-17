
import 'package:flutter/foundation.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/data/repositories/patient_repository.dart';
import 'package:physioghar/data/repositories/session_repository.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/models/patient_note.dart';
import 'package:physioghar/models/session.dart';

class PatientController {
  PatientController({
    PatientRepository? patientRepository,
    SessionRepository? sessionRepository,
  })  : _patientRepository =
            patientRepository ?? PatientRepository(),
        _sessionRepository =
            sessionRepository ?? SessionRepository();

  final PatientRepository _patientRepository;
  final SessionRepository _sessionRepository;

  final isLoading = ValueNotifier<bool>(false);
  final isUpdating = ValueNotifier<bool>(false);

  final patients = ValueNotifier<List<Patient>>([]);
  final notes = ValueNotifier<List<PatientNote>>([]);
  final selectedPatient = ValueNotifier<Patient?>(null);

  Future<void> loadPatients() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result =
          await _patientRepository.getPatients();

      patients.value = result;
    } catch (error) {
      debugPrint(
        'Failed to load patients: $error',
      );

      AppSnackBar.showError(
        'Unable to load patients.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPatient(int patientId) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      // Clear previous patient's notes immediately.
      notes.value = [];

      final result =
          await _patientRepository.getPatient(
        patientId,
      );

      selectedPatient.value = result;

      await loadNotes(patientId);
    } catch (error) {
      debugPrint(
        'Failed to load patient details: $error',
      );

      selectedPatient.value = null;
      notes.value = [];

      AppSnackBar.showError(
        'Unable to load patient details.',
      );
    } finally {
      isLoading.value = false;
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

  Future<void> loadNotes(int patientId) async {
    try {
      final result =
          await _patientRepository.getPatientNotes(
        patientId,
      );

      notes.value = result;
    } catch (error) {
      debugPrint(
        'Failed to load patient notes: $error',
      );

      notes.value = [];

      AppSnackBar.showError(
        'Unable to load patient notes.',
      );
    }
  }

  Future<bool> addNote({
    required int patientId,
    required String content,
  }) async {
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      AppSnackBar.showError(
        'Note cannot be empty.',
      );

      return false;
    }

    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;

    try {
      final newNote =
          await _patientRepository.createPatientNote(
        patientId: patientId,
        content: trimmedContent,
      );

      notes.value = [
        newNote,
        ...notes.value,
      ];

      AppSnackBar.showSuccess(
        'Note added successfully.',
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to add patient note: $error',
      );

      AppSnackBar.showError(
        'Unable to add note.',
      );

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> editNote({
    required int patientId,
    required int noteId,
    required String content,
  }) async {
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      AppSnackBar.showError(
        'Note cannot be empty.',
      );

      return false;
    }

    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;

    try {
      final updatedNote =
          await _patientRepository.updatePatientNote(
        patientId: patientId,
        noteId: noteId,
        content: trimmedContent,
      );

      final currentNotes =
          List<PatientNote>.from(
        notes.value,
      );

      final index = currentNotes.indexWhere(
        (note) => note.id == noteId,
      );

      if (index != -1) {
        currentNotes[index] = updatedNote;

        notes.value = currentNotes;
      }

      AppSnackBar.showSuccess(
        'Note updated successfully.',
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to update patient note: $error',
      );

      AppSnackBar.showError(
        'Unable to update note.',
      );

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> deleteNote({
    required int patientId,
    required int noteId,
  }) async {
    if (isUpdating.value) {
      return false;
    }

    isUpdating.value = true;

    try {
      await _patientRepository.deletePatientNote(
        patientId: patientId,
        noteId: noteId,
      );

      notes.value = notes.value
          .where(
            (note) => note.id != noteId,
          )
          .toList();

      AppSnackBar.showSuccess(
        'Note deleted successfully.',
      );

      return true;
    } catch (error) {
      debugPrint(
        'Failed to delete patient note: $error',
      );

      AppSnackBar.showError(
        'Unable to delete note.',
      );

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void clearNotes() {
    notes.value = [];
  }

  void clearSelectedPatient() {
    selectedPatient.value = null;
    notes.value = [];
  }

  void dispose() {
    isLoading.dispose();
    isUpdating.dispose();
    patients.dispose();
    notes.dispose();
    selectedPatient.dispose();
  }
}

final patientController = PatientController();
