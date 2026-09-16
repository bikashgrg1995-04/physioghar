import 'package:dio/dio.dart';

import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';
import 'package:physioghar/models/patient_note.dart';

class PatientService {
  PatientService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<Map<String, dynamic>>> getPatients() async {
    final response = await _dio.get(ApiEndpoints.patients);

    final data = response.data;

    if (data is! List) {
      throw const FormatException('Invalid patients response.');
    }

    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<String, dynamic>> getPatient(int patientId) async {
    final response = await _dio.get('${ApiEndpoints.patients}$patientId/');

    final data = response.data;

    if (data is! Map) {
      throw const FormatException('Invalid patient response.');
    }

    return Map<String, dynamic>.from(data);
  }

  Future<List<PatientNote>> getPatientNotes(int patientId) async {
    final response = await _dio.get(
      '${ApiEndpoints.patients}$patientId/notes/',
    );
    final data = response.data;
    if (data is! List) {
      throw const FormatException('Invalid patient notes response.');
    }
    return data
        .map((item) => PatientNote.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<PatientNote> createPatientNote({
    required int patientId,
    required String content,
  }) async {
    final response = await _dio.post(
      '${ApiEndpoints.patients}$patientId/notes/',
      data: {'content': content.trim()},
    );
    return PatientNote.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<PatientNote> updatePatientNote({
    required int patientId,
    required int noteId,
    required String content,
  }) async {
    final response = await _dio.patch(
      '${ApiEndpoints.patients}$patientId/notes/$noteId/',
      data: {'content': content.trim()},
    );
    return PatientNote.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> deletePatientNote({
    required int patientId,
    required int noteId,
  }) async {
    await _dio.delete('${ApiEndpoints.patients}$patientId/notes/$noteId/');
  }
}
