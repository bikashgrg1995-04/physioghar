import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/therapist.dart';
import 'package:physioghar/screens/profile/therapist_controller.dart';

class TherapistHeader extends StatelessWidget {
  const TherapistHeader({
    super.key,
    required this.controller,
  });

  final TherapistController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Therapist?>(
      valueListenable: controller.therapist,
      builder: (context, therapist, _) {
        final today = DateTime.now();

        final name = therapist?.name?.trim().isNotEmpty == true
            ? therapist!.name!.trim()
            : 'Therapist';

        final avatarUrl = therapist?.avatar;
        final isAvailable = therapist?.isAvailable ?? false;

        return ValueListenableBuilder<bool>(
          valueListenable: controller.isUpdating,
          builder: (context, isUpdating, _) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.pinePale,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 30,
                          color: AppColors.pine,
                        )
                      : ClipOval(
                          child: Image.network(
                            avatarUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return const Icon(
                                Icons.person,
                                size: 30,
                                color: AppColors.pine,
                              );
                            },
                          ),
                        ),
                ),

                const SizedBox(width: AppSizes.spacingMd),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTimeUtils.getGreeting(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.inkMute,
                              fontSize: AppSizes.fontSizeSm,
                            ),
                      ),

                      const SizedBox(height: AppSizes.spacingTiny),

                      Text(
                        name,
                        key: const Key('therapist-name'),
                        style: Theme.of(context).textTheme.headlineLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: AppSizes.spacingTiny),

                      Text(
                        DateTimeUtils.formatFullDate(today),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.inkMute,
                              fontSize: AppSizes.fontSizeSm,
                            ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: AppSizes.spacingSm,
                            height: AppSizes.spacingSm,
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? AppColors.pine
                                  : AppColors.inkMute,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(
                            width: AppSizes.spacingStatus,
                          ),

                          Text(
                            isAvailable ? 'Available' : 'Unavailable',
                            key: const Key('availability-status'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isAvailable
                                      ? AppColors.pine
                                      : AppColors.inkMute,
                                  fontSize: AppSizes.fontSizeSm,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          const SizedBox(
                            width: AppSizes.spacingSm,
                          ),

                          SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Switch.adaptive(
                                key: const Key('availability-switch'),
                                value: isAvailable,
                                activeThumbColor: AppColors.pine,
                                activeTrackColor: AppColors.pinePale,
                                inactiveThumbColor: AppColors.inkMute,
                                inactiveTrackColor: AppColors.mist,
                                onChanged: isUpdating
                                    ? null
                                    : controller.updateAvailability,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}