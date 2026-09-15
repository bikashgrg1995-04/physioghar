class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'http://192.168.1.69:8000/api/v1';

  // Authentication
  static const String login = '/auth/token/';

  // refresh token url
  static const String refreshToken = '/auth/token/refresh/';

  //logout
  static const String logout = '/auth/logout/';
}
