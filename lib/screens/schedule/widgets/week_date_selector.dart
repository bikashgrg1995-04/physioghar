import 'package:flutter/material.dart';
import 'package:physioghar/common_widgets/app_date_selector.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';

class WeekDateSelector extends StatelessWidget {
  const WeekDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  List<DateTime> _getNextSevenDays() {
    final today = DateTime.now();

    final startDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return List.generate(
      7,
      (index) => startDate.add(
        Duration(days: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dates = _getNextSevenDays();

    return Column(
      children: [
        Text(
          '${DateTimeUtils.formatMonth(selectedDate)} '
          '${selectedDate.year}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: AppSizes.spacingSm,
        ),
        AppDateSelector(
          dates: dates,
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
        ),
      ],
    );
  }
}