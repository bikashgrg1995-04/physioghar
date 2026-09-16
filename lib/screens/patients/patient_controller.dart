
import 'package:flutter/foundation.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/data/repositories/patient_repository.dart';
import 'package:physioghar/models/new/patient.dart';

class PatientController {
  PatientController({
    PatientRepository? patientRepository,
  }) : _patientRepository =
            patientRepository ?? PatientRepository();

  final PatientRepository _patientRepository;

  final isLoading = ValueNotifier<bool>(false);

  final patients = ValueNotifier<List<Patient>>([]);

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

  Future<void> loadPatient(
    int patientId,
  ) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result =
          await _patientRepository.getPatient(
        patientId,
      );

      selectedPatient.value = result;
    } catch (error) {
      debugPrint(
        'Failed to load patient details: $error',
      );

      selectedPatient.value = null;

      AppSnackBar.showError(
        'Unable to load patient details.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSelectedPatient() {
    selectedPatient.value = null;
  }

  void dispose() {
    isLoading.dispose();
    patients.dispose();
    selectedPatient.dispose();
  }
}