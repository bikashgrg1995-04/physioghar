import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelText = 'Cancel',
  String confirmText = 'Confirm',
  IconData icon = Icons.help_outline,
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
        ),
        contentPadding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ConfirmationIcon(
              icon: icon,
              isDestructive: isDestructive,
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(
                fontSize: AppSizes.fontSizeXl,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.inkMid,
                height: 1.4,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppSizes.minTapTarget,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.pine,
                        side: const BorderSide(
                          color: AppColors.pine,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.buttonRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: GoogleFonts.inter(
                          fontSize: AppSizes.fontSizeMd,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: AppSizes.spacingMd,
                ),

                Expanded(
                  child: AppButton(
                    text: confirmText,
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class _ConfirmationIcon extends StatelessWidget {
  const _ConfirmationIcon({
    required this.icon,
    required this.isDestructive,
  });

  final IconData icon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDestructive
        ? AppColors.dangerPale
        : AppColors.pinePale;

    final iconColor = isDestructive
        ? AppColors.danger
        : AppColors.pine;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 26,
      ),
    );
  }
}