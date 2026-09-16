import 'package:dio/dio.dart';

import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';

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
}
