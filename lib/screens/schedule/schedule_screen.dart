
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_error_state.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/data/providers/schedule_provider.dart';
import 'package:physioghar/data/providers/therapist_provider.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/screens/schedule/widgets/add_slot_bottom_sheet.dart';
import 'package:physioghar/screens/schedule/widgets/availability_status_card.dart';
import 'package:physioghar/screens/schedule/widgets/schedule_legend.dart';
import 'package:physioghar/screens/schedule/widgets/schedule_slots_section.dart';
import 'package:physioghar/screens/schedule/widgets/selected_date_header.dart';
import 'package:physioghar/screens/schedule/widgets/week_date_selector.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() =>
      _ScheduleScreenState();
}

class _ScheduleScreenState
    extends ConsumerState<ScheduleScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref
          .read(scheduleProvider.notifier)
          .loadSchedules();
    });

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      final therapist =
          ref.read(therapistProvider).therapist;

      if (therapist == null) {
        ref
            .read(therapistProvider.notifier)
            .loadProfile();
      }
    });
  }

  void _onDateSelected(DateTime date) {
    ref
        .read(scheduleProvider.notifier)
        .selectDate(date);
  }

  void _showAddSlotBottomSheet(
    DateTime selectedDate,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return AddSlotBottomSheet(
          selectedDate: selectedDate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState =
        ref.watch(scheduleProvider);

    final therapistState =
        ref.watch(therapistProvider);

    final selectedDate =
        scheduleState.selectedDate;

    final slots =
        scheduleState.slots;

    final isLoading =
        scheduleState.isLoading;

    final errorMessage =
        scheduleState.errorMessage;

    final therapist =
        therapistState.therapist;

    final isAvailable =
        therapist?.isAvailable ?? false;

    final isUpdating =
        therapistState.isUpdating;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              key: const Key(
                'schedule-screen-title',
              ),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium,
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            AvailabilityStatusCard(
              isAvailable: isAvailable,
              isUpdating: isUpdating,
              onChanged: (value) {
                ref
                    .read(
                      therapistProvider.notifier,
                    )
                    .updateAvailability(value);
              },
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            WeekDateSelector(
              selectedDate: selectedDate,
              onDateSelected: _onDateSelected,
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            SelectedDateHeader(
              date: selectedDate,
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            const ScheduleLegend(),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Expanded(
              child: _buildScheduleContent(
                selectedDate: selectedDate,
                slots: slots,
                isLoading: isLoading,
                errorMessage: errorMessage,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            Center(
              child: AppButton(
                text: 'Add Available Slot',
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showAddSlotBottomSheet(
                    selectedDate,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleContent({
    required DateTime selectedDate,
    required List<ScheduleSlot> slots,
    required bool isLoading,
    required String? errorMessage,
  }) {
    if (isLoading && slots.isEmpty) {
      return const AppLoading();
    }

    if (errorMessage != null &&
        slots.isEmpty) {
      return AppErrorState(
        title: 'Unable to load schedule',
        message: errorMessage,
        onRetry: () {
          ref
              .read(scheduleProvider.notifier)
              .loadSchedules(
                date: selectedDate,
              );
        },
      );
    }

    return ScheduleSlotsSection(
      selectedDate: selectedDate,
      slots: slots,
    );
  }
}