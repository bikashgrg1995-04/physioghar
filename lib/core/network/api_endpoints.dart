class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'http://192.168.1.69:8000/api/v1';

  // Authentication
  static const String login = '/auth/token/';
  static const String refreshToken = '/auth/token/refresh/';
  static const String logout = '/auth/logout/';

  // Therapist
  static const String profile = '/therapist/profile/';
  static const String availability = '/therapist/availability/';

  static const String avatar = '/therapist/avatar/';
}
