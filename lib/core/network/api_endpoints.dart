class ApiEndpoints {
  ApiEndpoints._();

  // dynaamiic  basse url
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api/v1',
  );

  // netwwork based  Base URL
  //static const String baseUrl = 'http://192.168.1.69:8000/api/v1';


  // production based Base URL
  // static const String baseUrl =
  //   'https://api.physioghar.com/api/v1';

  // Authentication
  static const String login = '/auth/token/';
  static const String refreshToken = '/auth/token/refresh/';
  static const String logout = '/auth/logout/';

  // Therapist
  static const String profile = '/therapist/profile/';

  //update therapist availability
  static const String availability = '/therapist/availability/';

  //update therapist avatar
  static const String avatar = '/therapist/avatar/';

  // patient list
  static const String patients = '/patients/';

  // schedule base endpoint
  static const String schedules = '/schedules/';

  //session base endpoint
  static const String sessions = '/sessions/';

  //complaint base endpoint
  static const String complaints = '/complaints/';

  //compaint with id to edit/delete
  static String complaintDetail(int id) => '$complaints$id/';
}
