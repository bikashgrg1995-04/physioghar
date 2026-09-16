
import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/new/patient.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  final Patient patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            AppSizes.spacingLg,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              AppSizes.cardRadius,
            ),
            border: Border.all(
              color: AppColors.mist,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _PatientAvatar(
                    name: patient.name,
                  ),

                  const SizedBox(
                    width: AppSizes.spacingMd,
                  ),

                  Expanded(
                    child: _PatientIdentity(
                      name: patient.name,
                      age: patient.age,
                      gender: patient.gender,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              _ConditionSummary(
                condition: patient.condition,
                phone: patient.phone,
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              AppButton(
                text: 'View Patient',
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 18,
                ),
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  const _PatientAvatar({
    required this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    final value = name?.trim() ?? '';

    final initial = value.isEmpty
        ? '?'
        : value[0].toUpperCase();

    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.pinePale,
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(
              color: AppColors.pine,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _PatientIdentity extends StatelessWidget {
  const _PatientIdentity({
    required this.name,
    required this.age,
    required this.gender,
  });

  final String? name;
  final int? age;
  final String? gender;

  @override
  Widget build(BuildContext context) {
    final displayName =
        name?.trim().isNotEmpty == true
            ? name!.trim()
            : 'Unknown patient';

    final ageText =
        age != null ? '$age years' : 'Age not provided';

    final genderText =
        gender?.trim().isNotEmpty == true
            ? gender!.trim()
            : 'Gender not provided';

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),

        const SizedBox(
          height: AppSizes.spacingXs,
        ),

        Text(
          '$ageText • $genderText',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color: AppColors.inkMid,
              ),
        ),
      ],
    );
  }
}

class _ConditionSummary extends StatelessWidget {
  const _ConditionSummary({
    required this.condition,
    required this.phone,
  });

  final String? condition;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final conditionText =
        condition?.trim().isNotEmpty == true
            ? condition!.trim()
            : 'Condition not provided';

    final phoneText =
        phone?.trim().isNotEmpty == true
            ? phone!.trim()
            : 'Phone not provided';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSizes.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(
          AppSizes.spacingSm,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'CONDITION',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  color: AppColors.inkMute,
                  letterSpacing: 0.8,
                ),
          ),

          const SizedBox(
            height: AppSizes.spacingXs,
          ),

          Text(
            conditionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(
            height: AppSizes.spacingSm,
          ),

          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.inkMid,
              ),
              const SizedBox(
                width: AppSizes.spacingXs,
              ),
              Expanded(
                child: Text(
                  phoneText,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: AppColors.inkMid,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}