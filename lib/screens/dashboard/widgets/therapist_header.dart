import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/providers/therapist_provider.dart';

class TherapistHeader extends ConsumerWidget {
  const TherapistHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final therapist = ref.watch(therapistProvider);
    final today = DateTime.now();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Avatar
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.pinePale,
          child: therapist.avatarUrl.isEmpty
              ? const Icon(Icons.person, size: 30, color: AppColors.pine)
              : ClipOval(
                  child: Image.network(
                    therapist.avatarUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
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

        // Therapist Information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                _getGreeting(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.inkMute,
                  fontSize: AppSizes.fontSizeSm,
                ),
              ),

              const SizedBox(height: AppSizes.spacingTiny),

              // Therapist Name
              Text(
                therapist.name,
                key: const Key('therapist-name'),
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSizes.spacingTiny),

              // Today's Date
              Text(
                _formatDate(today),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.inkMute,
                  fontSize: AppSizes.fontSizeSm,
                ),
              ),

              const SizedBox(height: AppSizes.spacingAvailability),

              // Availability
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Indicator
                  Container(
                    width: AppSizes.spacingSm,
                    height: AppSizes.spacingSm,
                    decoration: BoxDecoration(
                      color: therapist.isAvailable
                          ? AppColors.pine
                          : AppColors.inkMute,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: AppSizes.spacingStatus),

                  // Fixed Status Text Area
                  SizedBox(
                    width: 70,
                    child: Text(
                      therapist.isAvailable ? 'Available' : 'Unavailable',
                      key: const Key('availability-status'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: therapist.isAvailable
                            ? AppColors.pine
                            : AppColors.inkMute,
                        fontSize: AppSizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSizes.spacingSm),

                  // Availability Toggle
                  SizedBox(
                    width: 60,
                    height: 32,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Switch.adaptive(
                        key: const Key('availability-switch'),
                        value: therapist.isAvailable,
                        activeThumbColor: AppColors.pine,
                        activeTrackColor: AppColors.pinePale,
                        inactiveThumbColor: AppColors.inkMute,
                        inactiveTrackColor: AppColors.mist,
                        onChanged: (value) {
                          ref
                              .read(therapistProvider.notifier)
                              .toggleAvailability();
                        },
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
  }
}
