import 'package:flutter/material.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';

class WeekDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

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
    final week = _getNextSevenDays();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${DateTimeUtils.formatMonth(selectedDate)} '
              '${selectedDate.year}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(
          height: AppSizes.spacingSm,
        ),
        Row(
          children: week.map((date) {
            final isSelected = DateTimeUtils.isSameDay(
              date,
              selectedDate,
            );

            return Expanded(
              child: GestureDetector(
                onTap: () => onDateSelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.pine
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateTimeUtils.formatWeekdayShort(date),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
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
          }).toList(),
        ),
      ],
    );
  }
}