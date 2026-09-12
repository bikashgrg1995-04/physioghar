import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/providers/therapist_provider.dart';

class AvailabilityStatusCard extends ConsumerWidget {
  const AvailabilityStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final therapist = ref.watch(therapistProvider);

    final isAvailable = therapist.isAvailable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLg),
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
          const SizedBox(width: AppSizes.spacingSm),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable
                      ? 'Available'
                      : 'Unavailable',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
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
            onChanged: (_) {
              ref
                  .read(therapistProvider.notifier)
                  .toggleAvailability();
            },
          ),
        ],
      ),
    );
  }
}