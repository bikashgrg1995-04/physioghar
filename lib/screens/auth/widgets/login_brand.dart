import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';

class LoginBrand extends StatelessWidget {
  const LoginBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: ResponsiveUtils.width(context) * 0.23,
          height: ResponsiveUtils.width(context) * 0.23,
          constraints: const BoxConstraints(
            minWidth: 72,
            minHeight: 72,
            maxWidth: 96,
            maxHeight: 96,
          ),
          decoration: BoxDecoration(
            color: AppColors.pineLight,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.width(context) * 0.06,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(47, 93, 80, 0.12),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.width(context) * 0.06,
            ),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.width(context) * 0.023),
              child: Image.asset(
                'assets/icons/transparent_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        SizedBox(height: ResponsiveUtils.height(context) * 0.01),

        Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: GoogleFonts.fraunces(
            fontSize: (ResponsiveUtils.width(context) * 0.082).clamp(
              AppSizes.fontSizeXxl,
              AppSizes.fontSizeDisplay,
            ),
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),

        Text(
          AppStrings.appTagline,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: (ResponsiveUtils.width(context) * 0.034).clamp(
              AppSizes.fontSizeXs,
              AppSizes.fontSizeSm + 1,
            ),
            fontWeight: FontWeight.w500,
            color: AppColors.inkMid,
          ),
        ),
      ],
    );
  }
}
