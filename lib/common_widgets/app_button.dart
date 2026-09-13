
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

enum AppButtonVariant {
  primary,
  secondary,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Widget? icon;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSizes.minTapTarget,
      child: isPrimary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: icon ?? const SizedBox.shrink(),
              label: _buildLabel(),
              style: _primaryStyle(),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: icon ?? const SizedBox.shrink(),
              label: _buildLabel(),
              style: _secondaryStyle(),
            ),
    );
  }

  Widget _buildLabel() {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeSm,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  ButtonStyle _primaryStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.pine,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.buttonRadius,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
      ),
    );
  }

  ButtonStyle _secondaryStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.pine,
      side: const BorderSide(
        color: AppColors.pine,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.buttonRadius,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSm,
      ),
    );
  }
}
