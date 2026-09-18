import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.mist,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: AppColors.inkMute,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeMd,
                  color: AppColors.inkMid,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSizes.spacingLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}