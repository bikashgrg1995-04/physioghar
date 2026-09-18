import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';

class SessionsHeader extends StatelessWidget {
  const SessionsHeader({
    super.key,
    this.onAdd,
  });

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacingLg,
        AppSizes.spacingXl,
        AppSizes.spacingMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Sessions',
                  key: const Key(
                    'sessions-screen-title',
                  ),
                 style: context.textTheme.displayMedium,
                ),
                const SizedBox(
                  height: AppSizes.spacingXs,
                ),
                Text(
                  'Manage your bookings & appointments',
                 style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          if (onAdd != null) ...[
            const SizedBox(
              width: AppSizes.spacingMd,
            ),
            IconButton(
              tooltip: 'Add test session',
              onPressed: onAdd,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.pinePale,
                foregroundColor: AppColors.pine,
                minimumSize: const Size(
                  AppSizes.minTapTarget,
                  AppSizes.minTapTarget,
                ),
              ),
              icon: const Icon(
                Icons.add,
                size: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}