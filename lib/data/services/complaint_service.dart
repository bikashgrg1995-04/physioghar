import 'package:dio/dio.dart';

import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';

class ComplaintService {
  ComplaintService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<Map<String, dynamic>>> getComplaints() async {
    final response = await _dio.get(ApiEndpoints.complaints);

    final data = response.data;

    if (data is! List) {
      throw const FormatException('Invalid complaints response.');
    }

    return data
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  Future<Map<String, dynamic>> createComplaint({
    required String category,
    required String subject,
    required String description,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.complaints,
      data: {
        'category': category,
        'subject': subject,
        'description': description,
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw const FormatException('Invalid complaint response.');
    }

    return Map<String, dynamic>.from(data);
  }

  Future<Map<String, dynamic>> updateComplaint({
  required int id,
  required String category,
  required String subject,
  required String description,
}) async {
  final response = await _dio.patch(
    ApiEndpoints.complaintDetail(id),
    data: {
      'category': category,
      'subject': subject,
      'description': description,
    },
  );

  final data = response.data;

  if (data is! Map) {
    throw const FormatException('Invalid complaint response.');
  }

  return Map<String, dynamic>.from(data);
}
  
  Future<void> deleteComplaint(int id) async {
    await _dio.delete(ApiEndpoints.complaintDetail(id));
  }
}
