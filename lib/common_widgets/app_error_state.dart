import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Unable to load this information.',
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.dangerPale,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 30,
                color: AppColors.danger,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.inkMid,
              ),
            ),

            if (onRetry != null) ...[
              const SizedBox(
                height: AppSizes.spacingLg,
              ),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'Try Again',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}