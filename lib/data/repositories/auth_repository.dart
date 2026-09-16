import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:physioghar/core/storage/secure_storage_service.dart';
import 'package:physioghar/data/services/auth_service.dart';
import 'package:physioghar/models/auth_result.dart';

class AuthRepository {
  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<void> login({required String email, required String password}) async {
    debugPrint('========== AUTH REPOSITORY ==========');

    final data = await _authService.login(email: email, password: password);

    final accessToken = data['access'];
    final refreshToken = data['refresh'];

    debugPrint(
      'Access token received: '
      '${accessToken is String && accessToken.isNotEmpty}',
    );

    debugPrint(
      'Refresh token received: '
      '${refreshToken is String && refreshToken.isNotEmpty}',
    );

    if (accessToken is! String || accessToken.isEmpty) {
      throw const AuthException('Access token was not returned by the server.');
    }

    if (refreshToken is! String || refreshToken.isEmpty) {
      throw const AuthException(
        'Refresh token was not returned by the server.',
      );
    }

    await SecureStorageService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    debugPrint('Tokens saved to secure storage.');
    debugPrint('====================================');
  }

  Future<AuthResult> isLoggedIn() async {
    final accessToken = await SecureStorageService.getAccessToken();

    final refreshToken = await SecureStorageService.getRefreshToken();

    // No stored tokens.
    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      debugPrint('Auth check: No stored tokens.');

      return const AuthResult(status: AuthStatus.unauthenticated);
    }

    try {
      final accessExpired = JwtDecoder.isExpired(accessToken);

      final refreshExpired = JwtDecoder.isExpired(refreshToken);

      debugPrint('Access token expired: $accessExpired');

      debugPrint('Refresh token expired: $refreshExpired');

      // Refresh token itself has expired.
      // Session is no longer recoverable.
      if (refreshExpired) {
        await SecureStorageService.clearTokens();

        debugPrint('Auth check: Refresh token expired.');

        return const AuthResult(status: AuthStatus.sessionExpired);
      }

      // Access token is still valid.
      if (!accessExpired) {
        debugPrint('Auth check: Access token is valid.');

        return const AuthResult(status: AuthStatus.authenticated);
      }

      // Access token expired but refresh token is valid.
      debugPrint(
        'Auth check: Access token expired. '
        'Attempting refresh...',
      );

      final data = await _authService.refreshToken(refreshToken: refreshToken);

      final newAccessToken = data['access'];

      if (newAccessToken is! String || newAccessToken.isEmpty) {
        await SecureStorageService.clearTokens();

        debugPrint(
          'Auth check: Refresh failed. '
          'No new access token.',
        );

        return const AuthResult(status: AuthStatus.sessionExpired);
      }

      await SecureStorageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );

      debugPrint('Auth check: Access token refreshed successfully.');

      return const AuthResult(status: AuthStatus.authenticated);
    } catch (error) {
      debugPrint('Auth check failed: $error');

      await SecureStorageService.clearTokens();

      return const AuthResult(status: AuthStatus.sessionExpired);
    }
  }

  Future<void> logout() async {
    debugPrint('========== AUTH REPOSITORY LOGOUT ==========');

    final refreshToken = await SecureStorageService.getRefreshToken();

    debugPrint(
      'Stored refresh token available: '
      '${refreshToken != null && refreshToken.isNotEmpty}',
    );

    if (refreshToken == null || refreshToken.isEmpty) {
      await SecureStorageService.clearTokens();

      debugPrint('No refresh token found. Local tokens cleared.');
      debugPrint('============================================');

      return;
    }

    try {
      await _authService.logout(refreshToken: refreshToken);

      debugPrint('Backend logout completed successfully.');
    } on DioException catch (error) {
      debugPrint('Backend logout failed.');
      debugPrint('Status: ${error.response?.statusCode}');
      debugPrint('Message: ${error.message}');

      // Continue clearing local tokens.
    } finally {
      await SecureStorageService.clearTokens();

      final accessToken = await SecureStorageService.getAccessToken();

      final savedRefreshToken = await SecureStorageService.getRefreshToken();

      debugPrint(
        'Access token cleared: '
        '${accessToken == null || accessToken.isEmpty}',
      );

      debugPrint(
        'Refresh token cleared: '
        '${savedRefreshToken == null || savedRefreshToken.isEmpty}',
      );

      debugPrint('============================================');
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
