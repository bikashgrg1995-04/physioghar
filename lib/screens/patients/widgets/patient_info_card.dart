import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/models/patient.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({
    super.key,
    required this.patient,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final name =
        patient.name?.trim().isNotEmpty == true
            ? patient.name!.trim()
            : 'Not provided';

    final age = patient.age != null
        ? '${patient.age} years'
        : 'Not provided';

    final gender =
        patient.gender?.trim().isNotEmpty == true
            ? patient.gender!.trim()
            : 'Not provided';

    final phone =
        patient.phone?.trim().isNotEmpty == true
            ? patient.phone!.trim()
            : 'Not provided';

    final email =
        patient.email?.trim().isNotEmpty == true
            ? patient.email!.trim()
            : 'Not provided';

    final address =
        patient.address?.trim().isNotEmpty == true
            ? patient.address!.trim()
            : 'Not provided';

    return AppCard(
      padding: const EdgeInsets.all(
        AppSizes.spacingLg,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.person_outline,
            title: 'Patient Information',
          ),

          const SizedBox(
            height: AppSizes.spacingLg,
          ),

          _InfoRow(
            label: 'Name',
            value: name,
          ),

          _InfoRow(
            label: 'Age',
            value: age,
          ),

          _InfoRow(
            label: 'Gender',
            value: gender,
          ),

          _InfoRow(
            label: 'Phone',
            value: phone,
          ),

          _InfoRow(
            label: 'Email',
            value: email,
          ),

          _InfoRow(
            label: 'Address',
            value: address,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.minTapTarget,
          height: AppSizes.minTapTarget,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.pinePale,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.pine,
            size: 21,
          ),
        ),

        const SizedBox(
          width: AppSizes.spacingSm,
        ),

        Expanded(
          child: Text(
            title,
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: AppSizes.fontSizeLg,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast
            ? 0
            : AppSizes.spacingSm,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: AppSizes.fontSizeSm,
                color: AppColors.inkMute,
              ),
            ),
          ),

          const SizedBox(
            width: AppSizes.spacingSm,
          ),

          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: AppSizes.fontSizeSm,
                color: AppColors.ink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}