import 'package:flutter/material.dart';
import 'package:physioghar/common_widgets/app_card.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/schedule_slot.dart';

class ScheduleSlotCard extends StatelessWidget {
  const ScheduleSlotCard({super.key, required this.slot, this.onTap});

  final ScheduleSlot slot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = slot.status?.value ?? 'unknown';

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingLg,
        vertical: AppSizes.spacingMd,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingLg,
          vertical: AppSizes.spacingMd,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                DateTimeUtils.formatTimeString(slot.time),
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),

            _StatusBadge(status: status),

            const SizedBox(width: AppSizes.spacingSm),

            const Icon(Icons.chevron_right, size: 20, color: AppColors.inkMute),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final backgroundColor = _getStatusBackgroundColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSm,
        vertical: AppSizes.spacingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: AppSizes.spacingXs),

          Text(
            _getStatusLabel(status),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'OPEN';

      case 'booked':
        return 'BOOKED';

      case 'blocked':
        return 'BLOCKED';

      default:
        return 'UNKNOWN';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.pine;

      case 'booked':
        return AppColors.amber;

      case 'blocked':
        return AppColors.danger;

      default:
        return AppColors.inkMute;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.pinePale;

      case 'booked':
        return AppColors.amberPale;

      case 'blocked':
        return AppColors.dangerPale;

      default:
        return AppColors.mist;
    }
  }
}
