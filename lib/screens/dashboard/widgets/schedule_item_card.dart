import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/session.dart';

class ScheduleItemCard extends StatelessWidget {
  const ScheduleItemCard({
    super.key,
    required this.session,
    this.onTap,
  });

  final Session session;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final patientName =
        session.patientName?.trim().isNotEmpty == true
            ? session.patientName!.trim()
            : 'Unknown patient';

    final treatment =
        session.treatment?.trim().isNotEmpty == true
            ? session.treatment!.trim()
            : 'Treatment not specified';

    final location =
        session.location?.trim().isNotEmpty == true
            ? session.location!.trim()
            : 'Location not specified';

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(
        AppSizes.spacingMd,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
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

          const SizedBox(
            width: AppSizes.spacingMd,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                Text(
                  treatment,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkMid,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.inkMute,
                    ),

                    const SizedBox(
                      width: AppSizes.spacingXs,
                    ),

                    Expanded(
                      child: Text(
                        location,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.inkMute,
                          fontSize: AppSizes.fontSizeSm,
                        ),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (onTap != null) ...[
            const SizedBox(
              width: AppSizes.spacingSm,
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.inkMute,
            ),
          ],
        ],
      ),
    );
  }
}