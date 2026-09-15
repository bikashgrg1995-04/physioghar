
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class AppSnackBar {
  AppSnackBar._();

  static final GlobalKey<ScaffoldMessengerState>
      scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.pine,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showError(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.danger,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showInfo(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.inkMid,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final messenger = scaffoldMessengerKey.currentState;

    if (messenger == null) {
      debugPrint(
        'AppSnackBar: ScaffoldMessengerState is not available.',
      );
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                icon,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(
                width: AppSizes.spacingSm,
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(
            AppSizes.spacingLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.cardRadius,
            ),
          ),
          duration: const Duration(
            seconds: 3,
          ),
        ),
      );
  }
}
