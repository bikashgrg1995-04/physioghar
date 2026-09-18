
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/app/router.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/common_widgets/app_text_field.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/core/utils/validators.dart';
import 'package:physioghar/data/providers/auth_provider.dart';
import 'package:physioghar/data/repositories/auth_repository.dart';
import 'package:physioghar/models/auth_result.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  String? _validateEmail(String? value) {
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

  String? _validatePassword(String? value) {
    return Validators.required(
      value,
      field: 'Password',
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    WidgetRef ref,
  ) async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    await ref.read(authProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
  }

  Future<void> _handleForgotPassword(
    BuildContext context,
  ) async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackBar.showInfo(
        AppStrings.enterEmailFirst,
      );
      return;
    }

    if (_validateEmail(email) != null) {
      AppSnackBar.showError(
        AppStrings.invalidEmailAddress,
      );
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

    AppSnackBar.showInfo(
      AppStrings.serviceUnavailable,
    );
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authState = ref.watch(authProvider);

    final isLoading = authState.isLoading;
    final obscurePassword =
        ref.watch(passwordVisibilityProvider);

    ref.listen<AsyncValue<AuthStatus>>(
      authProvider,
      (previous, next) {
        next.whenOrNull(
          data: (status) {
            if (!context.mounted) {
              return;
            }

            if (status == AuthStatus.authenticated) {
              AppSnackBar.showSuccess(
                AppStrings.loginSuccess,
              );

              Navigator.of(context).pushReplacementNamed(
                AppRouter.navigation,
              );
            }
          },
          error: (error, _) {
            if (!context.mounted) {
              return;
            }

            if (error is AuthException) {
              AppSnackBar.showError(
                error.message,
              );
            } else {
              AppSnackBar.showError(
                AppStrings.genericError,
              );
            }
          },
        );
      },
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: emailController,
            label: AppStrings.email,
            hintText: AppStrings.emailHint,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !isLoading,
            validator: _validateEmail,
          ),
          SizedBox(
            height: ResponsiveUtils.height(context) * 0.012,
          ),
          AppTextField(
            controller: passwordController,
            label: AppStrings.password,
            hintText: AppStrings.passwordHint,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            enabled: !isLoading,
            onSubmitted: (_) {
              _handleLogin(context, ref);
            },
            suffixIcon: IconButton(
              tooltip: obscurePassword
                  ? 'Show password'
                  : 'Hide password',
              onPressed: isLoading
                  ? null
                  : () {
                      ref
                          .read(
                            passwordVisibilityProvider
                                .notifier,
                          )
                          .toggle();
                    },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.inkMute,
              ),
            ),
            validator: _validatePassword,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      _handleForgotPassword(context);
                    },
              style: TextButton.styleFrom(
                minimumSize: const Size(
                  AppSizes.minTapTarget,
                  AppSizes.minTapTarget,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal:
                      ResponsiveUtils.width(context) * 0.01,
                ),
              ),
              child: Text(
                AppStrings.forgotPassword,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                      color: AppColors.pine,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          AppButton(
            width: double.infinity,
            text: AppStrings.login,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(
                    Icons.arrow_forward_rounded,
                    size: 19,
                  ),
            onPressed: isLoading
                ? null
                : () {
                    _handleLogin(context, ref);
                  },
          ),
          SizedBox(
            height: ResponsiveUtils.height(context) * 0.012,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 15,
                color: AppColors.pineLight,
              ),
              SizedBox(
                width:
                    ResponsiveUtils.width(context) * 0.01,
              ),
              Flexible(
                child: Text(
                  AppStrings.accountProtected,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: AppColors.inkMute,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}