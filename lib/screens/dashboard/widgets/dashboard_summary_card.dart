import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconBackgroundColor = AppColors.pinePale,
    this.iconColor = AppColors.pine,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 18,
                ),
              ),

              const SizedBox(
                width: AppSizes.spacingMd,
              ),

              Expanded(
                child: Text(
                  value,
                  style: textTheme.headlineLarge,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: AppSizes.spacingSm,
          ),

          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.inkMute,
              fontSize: AppSizes.fontSizeSm,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}