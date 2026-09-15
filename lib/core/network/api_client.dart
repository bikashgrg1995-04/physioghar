import 'package:dio/dio.dart';
import 'package:physioghar/core/network/api_endpoints.dart';

import 'package:physioghar/core/storage/secure_storage_service.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          QueuedInterceptorsWrapper(onRequest: _onRequest, onError: _onError),
        );

  static Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Auth endpoints must not receive an old access token.
      if (_isAuthEndpoint(options.path)) {
        handler.next(options);
        return;
      }

      final accessToken = await SecureStorageService.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (error) {
      handler.next(options);
    }
  }

  static Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final response = error.response;
    final request = error.requestOptions;

    // Only handle expired/invalid access-token responses.
    if (response?.statusCode != 401) {
      handler.next(error);
      return;
    }

    // Never refresh a failed login or refresh request.
    if (_isAuthEndpoint(request.path)) {
      await SecureStorageService.clearTokens();
      handler.next(error);
      return;
    }

    // Prevent infinite retry loops.
    final alreadyRetried = request.extra['_retried'] == true;

    if (alreadyRetried) {
      await SecureStorageService.clearTokens();
      handler.next(error);
      return;
    }

    try {
      final newAccessToken = await _refreshAccessToken();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await SecureStorageService.clearTokens();
        handler.next(error);
        return;
      }

      request
        ..headers['Authorization'] = 'Bearer $newAccessToken'
        ..extra['_retried'] = true;

      final retryResponse = await dio.fetch(request);

      handler.resolve(retryResponse);
    } on DioException catch (refreshError) {
      await SecureStorageService.clearTokens();

      if (refreshError.response?.statusCode == 401) {
        handler.next(
          DioException(
            requestOptions: request,
            error: 'Session expired.',
            type: DioExceptionType.badResponse,
            response: refreshError.response,
          ),
        );
        return;
      }

      handler.next(refreshError);
    } catch (_) {
      await SecureStorageService.clearTokens();
      handler.next(error);
    }
  }

  static Future<String?> _refreshAccessToken() async {
    final refreshToken = await SecureStorageService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    // Use a separate Dio instance so the refresh request
    // does not enter the same authentication interceptor.
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    try {
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken},
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        return null;
      }

      final newAccessToken = data['access'];

      if (newAccessToken is! String || newAccessToken.isEmpty) {
        return null;
      }

      await SecureStorageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );

      return newAccessToken;
    } on DioException {
      return null;
    } finally {
      refreshDio.close(force: true);
    }
  }

  static bool _isAuthEndpoint(String path) {
    return path == ApiEndpoints.login || path == ApiEndpoints.refreshToken;
  }

  static bool isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }

  static bool isForbidden(DioException error) {
    return error.response?.statusCode == 403;
  }

  static bool isNotFound(DioException error) {
    return error.response?.statusCode == 404;
  }

  static bool isServerError(DioException error) {
    final statusCode = error.response?.statusCode;

    return statusCode != null && statusCode >= 500;
  }

  static bool isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  static String getErrorMessage(DioException error) {
    if (isNetworkError(error)) {
      return 'Unable to connect to the server.';
    }

    switch (error.response?.statusCode) {
      case 400:
        return _extractMessage(
          error.response?.data,
          fallback: 'Invalid request.',
        );

      case 401:
        return 'Invalid credentials or session expired.';

      case 403:
        return 'You do not have permission to perform this action.';

      case 404:
        return 'The requested resource was not found.';

      case 422:
        return _extractMessage(
          error.response?.data,
          fallback: 'Please check the provided information.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String _extractMessage(dynamic data, {required String fallback}) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];

      if (detail is String && detail.isNotEmpty) {
        return detail;
      }

      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      final error = data['error'];

      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    return fallback;
  }
}
