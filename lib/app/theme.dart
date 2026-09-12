import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.cream,

    fontFamily: GoogleFonts.inter().fontFamily,

    colorScheme: const ColorScheme.light(
      primary: AppColors.pine,
      secondary: AppColors.amber,
      surface: AppColors.cream,
      error: AppColors.danger,
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.fraunces(
        fontSize: AppSizes.fontSizeDisplay,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: AppSizes.fontSizeXxl,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      headlineLarge: GoogleFonts.fraunces(
        fontSize: AppSizes.fontSizeXl,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeLg,
        color: AppColors.ink,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeMd,
        color: AppColors.inkMid,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeMd,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    ),
  );
}