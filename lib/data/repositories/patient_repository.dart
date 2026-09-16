
import 'package:physioghar/data/services/patient_service.dart';
import 'package:physioghar/models/patient.dart';

class PatientRepository {
  PatientRepository({
    PatientService? patientService,
  }) : _patientService =
            patientService ?? PatientService();

  final PatientService _patientService;

  Future<List<Patient>> getPatients() async {
    final data = await _patientService.getPatients();

    return data
        .map(
          (json) => Patient.fromJson(json),
        )
        .toList();
  }

  Future<Patient> getPatient(
    int patientId,
  ) async {
    final data = await _patientService.getPatient(
      patientId,
    );

    return Patient.fromJson(data);
  }
}