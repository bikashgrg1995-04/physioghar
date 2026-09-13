import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';

class SessionTabs extends StatelessWidget {
  final TabController controller;

  const SessionTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return TabBar(
      controller: controller,
      isScrollable: isMobile,
      tabAlignment: isMobile
          ? TabAlignment.start
          : TabAlignment.fill,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppSizes.spacingXl
            : AppSizes.spacingXxl,
      ),
      labelPadding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppSizes.spacingMd
            : AppSizes.spacingLg,
      ),
      indicatorColor: AppColors.pine,
      indicatorWeight: 2.5,
      dividerColor: Colors.transparent,
      labelColor: AppColors.pine,
      unselectedLabelColor: AppColors.inkMute,
      labelStyle: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeMd,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeMd,
        fontWeight: FontWeight.w500,
      ),
      tabs: const [
        Tab(text: 'Requests'),
        Tab(text: 'Upcoming'),
        Tab(text: 'Completed'),
        Tab(text: 'Cancelled'),
      ],
    );
  }
}