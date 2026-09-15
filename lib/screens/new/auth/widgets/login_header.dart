
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeBack,
                style: GoogleFonts.fraunces(
                  fontSize: (
                    ResponsiveUtils.width(context) * 0.072
                  ).clamp(
                    AppSizes.fontSizeXxl,
                    28.0,
                  ),
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),

              SizedBox(
                height: ResponsiveUtils.height(context) * 0.006,
              ),

              Text(
                AppStrings.loginSubtitle,
                style: GoogleFonts.inter(
                  fontSize: (
                    ResponsiveUtils.width(context) * 0.035
                  ).clamp(
                    AppSizes.fontSizeXs,
                    AppSizes.fontSizeMd,
                  ),
                  height: 1.45,
                  color: AppColors.inkMid,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          width: ResponsiveUtils.width(context) * 0.025,
        ),

        Container(
          width: (
            ResponsiveUtils.width(context) * 0.12
          ).clamp(
            42.0,
            54.0,
          ),
          height: (
            ResponsiveUtils.width(context) * 0.12
          ).clamp(
            42.0,
            54.0,
          ),
          padding: EdgeInsets.all(
            ResponsiveUtils.width(context) * 0.01,
          ),
          decoration: const BoxDecoration(
            color: AppColors.pinePale,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/icons/leaf_icon.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}