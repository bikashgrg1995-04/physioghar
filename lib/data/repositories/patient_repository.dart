import 'package:physioghar/data/services/patient_service.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/models/patient_note.dart';

class PatientRepository {
  PatientRepository({PatientService? patientService})
    : _patientService = patientService ?? PatientService();

  final PatientService _patientService;

  Future<List<Patient>> getPatients() async {
    final data = await _patientService.getPatients();

    return data.map((json) => Patient.fromJson(json)).toList();
  }

  Future<Patient> getPatient(int patientId) async {
    final data = await _patientService.getPatient(patientId);

    return Patient.fromJson(data);
  }

  Future<List<PatientNote>> getPatientNotes(int patientId) {
    return _patientService.getPatientNotes(patientId);
  }

  Future<PatientNote> createPatientNote({
    required int patientId,
    required String content,
  }) {
    return _patientService.createPatientNote(
      patientId: patientId,
      content: content,
    );
  }

  Future<PatientNote> updatePatientNote({
    required int patientId,
    required int noteId,
    required String content,
  }) {
    return _patientService.updatePatientNote(
      patientId: patientId,
      noteId: noteId,
      content: content,
    );
  }

  Future<void> deletePatientNote({
    required int patientId,
    required int noteId,
  }) {
    return _patientService.deletePatientNote(
      patientId: patientId,
      noteId: noteId,
    );
  }
}
