import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/therapist.dart';
import 'package:physioghar/screens/new/profile/therapist_controller.dart';
import 'package:physioghar/screens/new/schedule/schedule_controller.dart';
import 'package:physioghar/screens/new/schedule/widgets/add_slot_bottom_sheet.dart';
import 'package:physioghar/screens/new/schedule/widgets/availability_status_card.dart';
import 'package:physioghar/screens/new/schedule/widgets/schedule_legend.dart';
import 'package:physioghar/screens/new/schedule/widgets/schedule_slots_section.dart';
import 'package:physioghar/screens/new/schedule/widgets/selected_date_header.dart';
import 'package:physioghar/screens/new/schedule/widgets/week_date_selector.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final ScheduleController _controller;
  final TherapistController _therapistController = therapistController;

  @override
  void initState() {
    super.initState();

    _controller = ScheduleController();

    // Load schedule once.
    _controller.loadSchedules();

    // Initial therapist data should be loaded
    //// once from the shared controller.
    if (_therapistController.therapist.value == null) {
      _therapistController.loadProfile();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDateSelected(DateTime date) {
    _controller.selectDate(date);
  }

  void _showAddSlotBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return AddSlotBottomSheet(
          selectedDate: _controller.selectedDate.value,
          controller: _controller,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDate,
      builder: (context, selectedDate, _) {
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

                ValueListenableBuilder<Therapist?>(
                  valueListenable: _therapistController.therapist,
                  builder: (context, therapist, _) {
                    final isAvailable = therapist?.isAvailable ?? false;

                    return ValueListenableBuilder<bool>(
                      valueListenable: _therapistController.isUpdating,
                      builder: (context, isUpdating, _) {
                        return AvailabilityStatusCard(
                          isAvailable: isAvailable,
                          isUpdating: isUpdating,
                          onChanged: (value) {
                            _therapistController.updateAvailability(value);
                          },
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spacingXl),

                WeekDateSelector(
                  selectedDate: selectedDate,
                  onDateSelected: _onDateSelected,
                ),

                const SizedBox(height: AppSizes.spacingXl),

                SelectedDateHeader(date: selectedDate),

                const SizedBox(height: AppSizes.spacingMd),

                const ScheduleLegend(),

                const SizedBox(height: AppSizes.spacingMd),

                Expanded(
                  child: ValueListenableBuilder<List<ScheduleSlot>>(
                    valueListenable: _controller.slots,
                    builder: (context, slots, _) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _controller.isLoading,
                        builder: (context, isLoading, _) {
                          if (isLoading && slots.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ScheduleSlotsSection(
                            selectedDate: selectedDate,
                            slots: slots,
                            controller: _controller,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSizes.spacingLg),

                Center(
                  child: AppButton(
                    text: 'Add Available Slot',
                    icon: const Icon(Icons.add),
                    onPressed: _showAddSlotBottomSheet,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
