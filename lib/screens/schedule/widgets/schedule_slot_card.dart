import 'package:flutter/material.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/schedule_slot.dart';

class ScheduleSlotCard extends StatelessWidget {
  final ScheduleSlot slot;
  final VoidCallback? onTap;

  const ScheduleSlotCard({
    super.key,
    required this.slot,
    this.onTap,
  });


  String _getStatusLabel() {
    switch (slot.status) {
      case ScheduleSlotStatus.open:
        return 'OPEN';

      case ScheduleSlotStatus.booked:
        return 'BOOKED';

      case ScheduleSlotStatus.blocked:
        return 'BLOCKED';
    }
  }

  Color _getStatusColor() {
    switch (slot.status) {
      case ScheduleSlotStatus.open:
        return AppColors.pine;

      case ScheduleSlotStatus.booked:
        return AppColors.amber;

      case ScheduleSlotStatus.blocked:
        return AppColors.danger;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (slot.status) {
      case ScheduleSlotStatus.open:
        return AppColors.pinePale;

      case ScheduleSlotStatus.booked:
        return AppColors.amberPale;

      case ScheduleSlotStatus.blocked:
        return AppColors.dangerPale;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTimeUtils.formatTime(slot.dateTime);
    final statusColor = _getStatusColor();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        AppSizes.cardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
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
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSm,
                  vertical: AppSizes.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: _getStatusBackgroundColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(
                      width: AppSizes.spacingXs,
                    ),

                    Text(
                      _getStatusLabel(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: AppSizes.spacingSm,
              ),

              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.inkMute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}