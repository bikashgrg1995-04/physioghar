
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class AvailabilityStatusCard extends StatelessWidget {
  const AvailabilityStatusCard({
    super.key,
    required this.isAvailable,
    required this.onChanged,
    this.isUpdating = false,
  });

  final bool isAvailable;
  final ValueChanged<bool> onChanged;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSizes.spacingLg,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.pinePale
            : AppColors.mist,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.pine
                  : AppColors.inkMute,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(
            width: AppSizes.spacingSm,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable
                      ? 'Available'
                      : 'Unavailable',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),
                ),
                Text(
                  isAvailable
                      ? "You're currently available"
                      : "You're currently unavailable",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),

          Switch(
            value: isAvailable,
            onChanged:
                isUpdating ? null : onChanged,
          ),
        ],
      ),
    );
  }
}
