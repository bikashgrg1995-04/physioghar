
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/models/patient.dart';

class PatientHeader extends StatelessWidget {
  const PatientHeader({
    super.key,
    required this.patient,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final name =
        patient.name?.trim().isNotEmpty == true
            ? patient.name!.trim()
            : 'Unknown patient';

    final initial =
        name == 'Unknown patient'
            ? '?'
            : name[0].toUpperCase();

    final ageText = patient.age != null
        ? '${patient.age} years'
        : 'Age not provided';

    final genderText =
        patient.gender?.trim().isNotEmpty == true
            ? patient.gender!.trim()
            : 'Gender not provided';

    final conditionText =
        patient.condition?.trim().isNotEmpty == true
            ? patient.condition!.trim()
            : 'Condition not provided';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSizes.spacingLg,
      ),
      decoration: BoxDecoration(
        color: AppColors.pine,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Row(
        children: [
          _Avatar(
            initial: initial,
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
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.displayMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: AppSizes.fontSizeXl,
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                Text(
                  '$ageText • $genderText',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withValues(
                      alpha: 0.82,
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                Text(
                  conditionText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: AppSizes.fontSizeSm,
                    color: AppColors.white.withValues(
                      alpha: 0.72,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initial,
  });

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.pineLight,
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: context.textTheme.displayMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}