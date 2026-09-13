import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';

class AppDateSelector extends StatelessWidget {
  const AppDateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(
          width: AppSizes.spacingSm,
        ),
        itemBuilder: (context, index) {
          final date = dates[index];

          return _DateItem(
            date: date,
            isSelected: DateTimeUtils.isSameDay(
              date,
              selectedDate,
            ),
            onTap: () => onDateSelected(date),
          );
        },
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
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
          width: 58,
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spacingSm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.pine
                : Colors.white,
            borderRadius: BorderRadius.circular(
              AppSizes.cardRadius,
            ),
            border: Border.all(
              color: isSelected
                  ? AppColors.pine
                  : AppColors.mist,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _weekdayLabel(date),
                style: GoogleFonts.ibmPlexMono(
                  fontSize: AppSizes.fontSizeXs,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppColors.inkMute,
                ),
              ),
              const SizedBox(
                height: AppSizes.spacingXs,
              ),
              Text(
                '${date.day}',
                style: GoogleFonts.fraunces(
                  fontSize: AppSizes.fontSizeLg,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _weekdayLabel(DateTime date) {
    const weekdays = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];

    return weekdays[date.weekday - 1];
  }
}