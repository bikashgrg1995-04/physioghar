import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/data/repositories/auth_repository.dart';
import 'package:physioghar/models/auth_result.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthStatus> {
  late final AuthRepository _authRepository;

  @override
  Future<AuthStatus> build() async {
    _authRepository = AuthRepository();

    final result = await _authRepository.isLoggedIn();

    return result.status;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      await _authRepository.login(email: email, password: password);

      state = const AsyncData(AuthStatus.authenticated);
    } on AuthException catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
  
 Future<void> logout() async {
  state = const AsyncLoading();

  try {
    await _authRepository.logout();

    state = const AsyncData(AuthStatus.unauthenticated);
  } catch (_) {
    state = const AsyncData(AuthStatus.unauthenticated);
  }
}

  Future<void> checkAuthStatus() async {
    state = const AsyncLoading();

    try {
      final result = await _authRepository.isLoggedIn();

      state = AsyncData(result.status);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final passwordVisibilityProvider =
    NotifierProvider<PasswordVisibilityNotifier, bool>(
      PasswordVisibilityNotifier.new,
    );

class PasswordVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }
}
