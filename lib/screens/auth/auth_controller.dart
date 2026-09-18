import 'package:flutter/material.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/core/utils/validators.dart';
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
    final validationError = Validators.email(email);
    if (validationError != null) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  String? validatePassword(String? value) {
    return Validators.required(value, field: 'Password');
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();

    isLoading.value = true;

    try {
      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      isLoggedIn.value = true;

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(AppRouter.navigation);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showSuccess(AppStrings.loginSuccess);
      });
    } on AuthException catch (error) {
      if (!context.mounted) {
        return;
      }

      AppSnackBar.showError(error.message);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackBar.showError(AppStrings.genericError);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackBar.showInfo(AppStrings.enterEmailFirst);

      return;
    }

    if (validateEmail(email) != null) {
      AppSnackBar.showError(AppStrings.invalidEmailAddress);

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
    if (confirmed != true || !context.mounted) {
      return;
    }

    AppSnackBar.showInfo(AppStrings.serviceUnavailable);
  }

  Future<void> logout(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Logout',
      message: AppStrings.logoutConfirmation,
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout_rounded,
      isDestructive: true,
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    isLoading.value = true;

    try {
      await _authRepository.logout();

      isLoggedIn.value = false;

      if (!context.mounted) {
        return;
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

      // Wait until the new LoginScreen Scaffold is mounted.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showSuccess(AppStrings.logoutSuccess);
      });
    } catch (_) {
      isLoggedIn.value = false;

      if (!context.mounted) {
        return;
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showInfo(AppStrings.logoutDeviceInfo);
      });
    } finally {
      isLoading.value = false;
    }
  }

  Future<AuthResult> checkAuthStatus() async {
    isLoading.value = true;

    try {
      final result = await _authRepository.isLoggedIn();

      isLoggedIn.value = result.isAuthenticated;

      return result;
    } catch (_) {
      isLoggedIn.value = false;

      return const AuthResult(status: AuthStatus.sessionExpired);
    } finally {
      isLoading.value = false;
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
