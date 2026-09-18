class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final dynamic details;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isValidationError {
    return statusCode == 400 || statusCode == 422;
  }

  bool get isServerError {
    return statusCode != null && statusCode! >= 500;
  }

  @override
  String toString() {
    return 'ApiException('
        'statusCode: $statusCode, '
        'code: $code, '
        'message: $message'
        ')';
  }
}