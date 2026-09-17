import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/session.dart';

class ScheduleItemCard extends StatelessWidget {
  const ScheduleItemCard({
    super.key,
    required this.session,
    this.onTap,
    this.cardKey,
  });

  final Session session;
  final VoidCallback? onTap;
  final Key? cardKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      key: cardKey,
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              SizedBox(
                width: 64,
                child: Text(
                  DateTimeUtils.formatTimeString(
                    session.scheduleTime,
                  ),
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.pine,
                    fontSize: AppSizes.fontSizeSm,
                  ),
                ),
              ),

              const SizedBox(width: AppSizes.spacingMd),

              // Session details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.patientName.toString(),
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppSizes.spacingXs),

                    Text(
                      session.treatment.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.inkMid,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppSizes.spacingXs),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.inkMute,
                        ),
                        const SizedBox(width: AppSizes.spacingXs),
                        Expanded(
                          child: Text(
                            session.location.toString(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.inkMute,
                              fontSize: AppSizes.fontSizeSm,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.spacingSm),

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