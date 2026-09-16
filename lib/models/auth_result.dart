
enum AuthStatus {
  authenticated,
  unauthenticated,
  sessionExpired,
}

class AuthResult {
  const AuthResult({
    required this.status,
  });

  final AuthStatus status;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated;

  bool get isSessionExpired =>
      status == AuthStatus.sessionExpired;
}