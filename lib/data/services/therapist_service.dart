import 'dart:io';

import 'package:dio/dio.dart';

import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';

class TherapistService {
  TherapistService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get(ApiEndpoints.profile);

    final data = response.data;

    if (data is! Map) {
      throw const FormatException('Invalid profile response.');
    }

    return Map<String, dynamic>.from(data);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String phone,
    required String specialization,
    required String experience,
    required String address,
    required String bio,
    required bool isAvailable,
  }) async {
    final response = await _dio.patch(
      ApiEndpoints.profile,
      data: {
        'phone': phone,
        'specialization': specialization,
        'experience': experience,
        'address': address,
        'bio': bio,
        'is_available': isAvailable,
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw const FormatException('Invalid profile response.');
    }

    return Map<String, dynamic>.from(data);
  }

  Future<bool> updateAvailability(bool isAvailable) async {
    final response = await _dio.patch(
      ApiEndpoints.availability,
      data: {'is_available': isAvailable},
    );

    final data = response.data;

    if (data is! Map || data['is_available'] is! bool) {
      throw const FormatException('Invalid availability response.');
    }

    return data['is_available'] as bool;
  }

  Future<String?> getAvatar() async {
    final response = await _dio.get(ApiEndpoints.avatar);
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Invalid avatar response.');
    }
    return data['avatar'] as String?;
  }

  Future<String?> updateAvatar(File image) async {
    final fileName = image.path.split(RegExp(r'[\\/]')).last;
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    final response = await _dio.patch(ApiEndpoints.avatar, data: formData);
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Invalid avatar response.');
    }
    return data['avatar'] as String?;
  }
}
