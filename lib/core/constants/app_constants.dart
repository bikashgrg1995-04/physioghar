class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'PhysioGhar';

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 1000;

  // Network
  static const int connectionTimeoutSeconds = 15;
  static const int receiveTimeoutSeconds = 15;

  // Session
  static const String testSessionTreatment = 'Test Session';
  static const String testSessionLocation = 'Test';

  // Testing
  static const String testingPurposeLabel = 'Testing purpose only';
}