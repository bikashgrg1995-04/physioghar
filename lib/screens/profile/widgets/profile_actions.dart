import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({
    super.key,
    required this.onSettings,
    required this.onReportIssue,
    required this.onLogout,
  });

  final VoidCallback onSettings;
  final VoidCallback onReportIssue;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.fontSizeXl
      ),
      child: Column(
        children: [
          _ProfileActionButton(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Manage your preferences',
            onPressed: onSettings,
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
          _ProfileActionButton(
          icon: Icons.report_problem_outlined,
          title: 'Report an Issue',
          subtitle: 'Report a problem to PhysioGhar',
          onPressed: onReportIssue,
        ),
        const SizedBox(
          height: AppSizes.spacingMd,
        ),
          _ProfileActionButton(
            icon: Icons.logout_outlined,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onPressed: onLogout,
            isDanger: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.isDanger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDanger
        ? AppColors.dangerPale
        : AppColors.pinePale;

    final foregroundColor = isDanger
        ? AppColors.danger
        : AppColors.pine;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(
        AppSizes.cardRadius,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: AppSizes.minTapTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLg,
            vertical: AppSizes.spacingMd,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: foregroundColor,
              ),
              const SizedBox(
                width: AppSizes.spacingMd,
              ),
              
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: foregroundColor.withValues(
                  alpha: 0.65,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}