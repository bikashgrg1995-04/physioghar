import 'package:flutter/material.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/data/repositories/auth_repository.dart';
import 'package:physioghar/models/auth_result.dart';

class AuthController {
  AuthController({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  final AuthRepository _authRepository;

  // Reactive auth state.
  final isLoading = ValueNotifier<bool>(false);
  final isLoggedIn = ValueNotifier<bool>(false);

  // Login form state.
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = ValueNotifier<bool>(true);

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return AppStrings.emailRequired;
    }

    if (!email.contains('@')) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    return null;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;

    debugPrint(
      'Password visibility: '
      '${obscurePassword.value ? 'hidden' : 'visible'}',
    );
  }

  Future<void> login(BuildContext context) async {
    if (isLoading.value) {
      debugPrint('Login ignored: authentication already in progress.');
      return;
    }

    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      debugPrint('Login validation failed.');
      return;
    }

    isLoading.value = true;

    debugPrint('========== LOGIN FLOW ==========');
    debugPrint('Login started for: ${emailController.text.trim()}');

    try {
      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      isLoggedIn.value = true;

      debugPrint('Login repository completed successfully.');

      debugPrint('Authentication state: ${isLoggedIn.value}');

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(AppRouter.navigation);

      debugPrint('Navigated to main navigation.');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showSuccess('Login successful.');

        debugPrint('Login success snackbar shown.');
      });
    } on AuthException catch (error) {
      debugPrint('Login AuthException: ${error.message}');

      if (!context.mounted) {
        return;
      }

      AppSnackBar.showError(error.message);
    } catch (error) {
      debugPrint('Login unexpected error: $error');

      if (!context.mounted) {
        return;
      }

      AppSnackBar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;

      debugPrint('Login loading finished.');

      debugPrint('================================');
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();

    debugPrint('========== FORGOT PASSWORD ==========');

    final email = emailController.text.trim();

    debugPrint('Forgot password requested for: $email');

    if (email.isEmpty) {
      debugPrint('Forgot password validation failed: email is empty.');

      AppSnackBar.showInfo('Enter your email address first.');

      return;
    }

    if (validateEmail(email) != null) {
      debugPrint('Forgot password validation failed: invalid email.');

      AppSnackBar.showError('Please enter a valid email address.');

      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: AppStrings.forgotPasswordTitle,
      message: 'Send password reset instructions to $email?',
      confirmText: 'Continue',
      cancelText: 'Cancel',
      icon: Icons.lock_reset_outlined,
    );

    debugPrint('Forgot password confirmation: $confirmed');

    if (confirmed != true || !context.mounted) {
      debugPrint('Forgot password cancelled.');

      return;
    }

    debugPrint('Forgot password request confirmed.');

    // Backend forgot-password endpoint is not implemented yet.
    debugPrint('Forgot password API is not implemented yet.');

    AppSnackBar.showInfo('This service isn’t available yet.');

    debugPrint('====================================');
  }

  Future<void> logout(BuildContext context) async {
    if (isLoading.value) {
      debugPrint('Logout ignored: authentication already in progress.');
      return;
    }

    debugPrint('========== LOGOUT FLOW ==========');
    debugPrint('Logout button pressed.');

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout_rounded,
      isDestructive: true,
    );

    debugPrint('Logout confirmation: $confirmed');

    if (confirmed != true || !context.mounted) {
      debugPrint('Logout cancelled.');
      return;
    }

    isLoading.value = true;

    debugPrint('Starting logout request...');

    try {
      await _authRepository.logout();

      isLoggedIn.value = false;

      debugPrint('Logout repository completed.');

      if (!context.mounted) {
        return;
      }

      debugPrint('Navigating to login screen.');

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

      // Wait until the new LoginScreen Scaffold is mounted.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showSuccess('Logged out successfully.');

        debugPrint('Logout success snackbar shown.');
      });
    } catch (error) {
      isLoggedIn.value = false;

      debugPrint('Logout error: $error');

      if (!context.mounted) {
        return;
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showInfo('You have been logged out from this device.');
      });
    } finally {
      isLoading.value = false;

      debugPrint('Logout loading finished.');
      debugPrint('================================');
    }
  }

  Future<AuthResult> checkAuthStatus() async {
    if (isLoading.value) {
      debugPrint('Auth check ignored: authentication already in progress.');
       return const AuthResult(
      status: AuthStatus.unauthenticated,
    );
    }

    isLoading.value = true;

    debugPrint('========== AUTH CHECK ==========');

    try {
      final result = await _authRepository.isLoggedIn();

      isLoggedIn.value = result.isAuthenticated;

      debugPrint('Authentication state: ${isLoggedIn.value}');
      debugPrint( 'Auth status: ${result.status}', );
      return result;
    } catch (error) {
      isLoggedIn.value = false;

      debugPrint('Auth check failed: $error');
      return const AuthResult( status: AuthStatus.sessionExpired, );
    } finally {
      isLoading.value = false;

      debugPrint('Auth check loading finished.');
      debugPrint('================================');
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    isLoading.dispose();
    isLoggedIn.dispose();
    obscurePassword.dispose();
  }
}
