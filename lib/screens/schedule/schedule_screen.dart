import 'package:flutter/material.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/screens/schedule/widgets/add_slot_bottom_sheet.dart';
import 'package:physioghar/screens/schedule/widgets/availability_status_card.dart';
import 'package:physioghar/screens/schedule/widgets/schedule_legend.dart';
import 'package:physioghar/screens/schedule/widgets/schedule_slots_section.dart';
import 'package:physioghar/screens/schedule/widgets/selected_date_header.dart';
import 'package:physioghar/screens/schedule/widgets/week_date_selector.dart';
import 'package:physioghar/common_widgets/app_button.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _selectedDate;

  void _showAddSlotBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return AddSlotBottomSheet(
          selectedDate: _selectedDate,
          onSlotAdded: () {
            AppSnackBar.showSuccess(
              context,
              'Available slot added successfully.',
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    _selectedDate = DateTime(today.year, today.month, today.day);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              key: const Key('schedule-screen-title'),
              style: Theme.of(context).textTheme.displayMedium,
            ),

            const SizedBox(height: AppSizes.spacingLg),

            const AvailabilityStatusCard(),

            const SizedBox(height: AppSizes.spacingXl),

            WeekDateSelector(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            


            const SizedBox(height: AppSizes.spacingXl),

            SelectedDateHeader(date: _selectedDate),

            const SizedBox(height: AppSizes.spacingMd),

            const ScheduleLegend(),

            const SizedBox(height: AppSizes.spacingMd),

            Expanded(child: ScheduleSlotsSection(selectedDate: _selectedDate)),

            const SizedBox(height: AppSizes.spacingLg),

            AppButton(
              text: 'Add Available Slot',
              icon: const Icon(Icons.add),
              onPressed: _showAddSlotBottomSheet,
            ),
          ],
        ),
      ),
    );
  }
}
