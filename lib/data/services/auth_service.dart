import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:physioghar/core/network/api_client.dart';
import 'package:physioghar/core/network/api_endpoints.dart';

class AuthService {
  AuthService({
    Dio? client,
  }) : _client = client ?? ApiClient.dio;

  final Dio _client;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    debugPrint('========== LOGIN REQUEST ==========');
    debugPrint('Email: ${email.trim()}');
    debugPrint('Endpoint: ${ApiEndpoints.login}');

    final response = await _client.post(
      ApiEndpoints.login,
      data: {
        'email': email.trim(),
        'password': password,
      },
    );

    debugPrint('Login status: ${response.statusCode}');
    debugPrint('Login response received: ${response.data is Map}');
    debugPrint('===================================');

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid login response.',
      );
    }

    return data;
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    debugPrint('========== TOKEN REFRESH ==========');
    debugPrint(
      'Refresh token available: ${refreshToken.isNotEmpty}',
    );

    final response = await _client.post(
      ApiEndpoints.refreshToken,
      data: {
        'refresh': refreshToken,
      },
    );

    debugPrint(
      'Refresh status: ${response.statusCode}',
    );
    debugPrint(
      'New access token received: '
      '${response.data is Map<String, dynamic>}',
    );
    debugPrint('===================================');

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid refresh-token response.',
      );
    }

    return data;
  }

  Future<void> logout({
    required String refreshToken,
  }) async {
    debugPrint('========== LOGOUT REQUEST ==========');
    debugPrint('Endpoint: ${ApiEndpoints.logout}');
    debugPrint(
      'Refresh token available: ${refreshToken.isNotEmpty}',
    );

    final response = await _client.post(
      ApiEndpoints.logout,
      data: {
        'refresh': refreshToken,
      },
    );

    debugPrint(
      'Logout status: ${response.statusCode}',
    );
    debugPrint(
      'Logout response: ${response.data}',
    );
    debugPrint('====================================');
  }
}