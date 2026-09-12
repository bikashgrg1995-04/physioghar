import 'package:flutter/material.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class ScheduleLegend extends StatelessWidget {
  const ScheduleLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendItem(
          label: 'OPEN',
          color: AppColors.pine,
        ),
        const SizedBox(width: AppSizes.spacingMd),
        _LegendItem(
          label: 'BOOKED',
          color: AppColors.amber,
        ),
        const SizedBox(width: AppSizes.spacingMd),
        _LegendItem(
          label: 'BLOCKED',
          color: AppColors.danger,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSizes.spacingXs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}