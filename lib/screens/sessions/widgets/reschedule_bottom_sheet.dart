
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_date_selector.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/data/providers/schedule_provider.dart';
import 'package:physioghar/data/providers/session_provider.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';

Future<bool> showRescheduleBottomSheet(
  BuildContext context, {
  required Session session,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _RescheduleBottomSheet(
        session: session,
      );
    },
  );

  return result ?? false;
}

class _RescheduleBottomSheet
    extends ConsumerStatefulWidget {
  const _RescheduleBottomSheet({
    required this.session,
  });

  final Session session;

  @override
  ConsumerState<_RescheduleBottomSheet> createState() =>
      _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState
    extends ConsumerState<_RescheduleBottomSheet> {
  late DateTime _selectedDate;

  ScheduleSlot? _selectedSlot;

  @override
  void initState() {
    super.initState();

    final sessionDate =
        widget.session.scheduleDate;

    final today = DateTime.now();

    final startDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    _selectedDate = sessionDate == null
        ? startDate
        : DateTime(
            sessionDate.year,
            sessionDate.month,
            sessionDate.day,
          );

    if (_selectedDate.isBefore(startDate)) {
      _selectedDate = startDate;
    }

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref
          .read(scheduleProvider.notifier)
          .loadSchedules(
            date: _selectedDate,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionState =
        ref.watch(sessionProvider);

    final scheduleState =
        ref.watch(scheduleProvider);

    final slots = scheduleState.slots;

    return SafeArea(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.sizeOf(context).height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.spacingLg,
          AppSizes.spacingMd,
          AppSizes.spacingLg,
          AppSizes.spacingLg,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              AppSizes.cardRadius,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildHandle(),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            _buildHeader(),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            _buildCurrentSchedule(),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            _buildDateSectionLabel(),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            AppDateSelector(
              dates: _buildDates(),
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            _buildSlotSectionLabel(),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Expanded(
              child: _buildSlotContent(
                slots: slots,
                isLoading:
                    scheduleState.isLoading,
                errorMessage:
                    scheduleState.errorMessage,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            _buildConfirmButton(
              isUpdating:
                  sessionState.isUpdating,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotContent({
    required List<ScheduleSlot> slots,
    required bool isLoading,
    required String? errorMessage,
  }) {
    if (isLoading && slots.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null &&
        slots.isEmpty) {
      return _buildScheduleError(
        errorMessage,
      );
    }

    final openSlots =
        _getOpenSlots(slots);

    if (openSlots.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSlotList(openSlots);
  }

  Widget _buildScheduleError(
    String errorMessage,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 40,
              color: AppColors.danger,
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Text(
              'Unable to load slots',
              style:
                  context.textTheme.headlineLarge,
            ),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style:
                  context.textTheme.bodyMedium,
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            AppButton(
              text: 'Retry',
              onPressed: () {
                ref
                    .read(
                      scheduleProvider.notifier,
                    )
                    .loadSchedules(
                      date: _selectedDate,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _buildDates() {
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

  List<ScheduleSlot> _getOpenSlots(
    List<ScheduleSlot> slots,
  ) {
    final now = DateTime.now();

    final result = slots.where((slot) {
      if (slot.status !=
          ScheduleSlotStatus.open) {
        return false;
      }

      final slotDate = slot.date;

      if (slotDate == null ||
          !DateTimeUtils.isSameDay(
            slotDate,
            _selectedDate,
          )) {
        return false;
      }

      final slotDateTime =
          DateTimeUtils.combineDateAndTime(
        slotDate,
        slot.time,
      );

      if (slotDateTime == null) {
        return false;
      }

      if (!slotDateTime.isAfter(now)) {
        return false;
      }

      if (slot.id ==
          widget.session.scheduleSlotId) {
        return false;
      }

      return true;
    }).toList();

    result.sort(
      (a, b) =>
          DateTimeUtils.timeToMinutes(
            a.time,
          ).compareTo(
            DateTimeUtils.timeToMinutes(
              b.time,
            ),
          ),
    );

    return result;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });

    ref
        .read(scheduleProvider.notifier)
        .loadSchedules(
          date: date,
        );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.inkMute,
          borderRadius: BorderRadius.circular(
            AppSizes.buttonRadius,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Reschedule Session',
      style: context.textTheme.headlineLarge,
    );
  }

  Widget _buildCurrentSchedule() {
    return Text(
      '${widget.session.patientName ?? 'Unknown Patient'} • '
      '${_currentDateText()} • '
      '${DateTimeUtils.formatTimeString(
        widget.session.scheduleTime,
      )}',
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: AppSizes.fontSizeSm,
      ),
    );
  }

  String _currentDateText() {
    final date =
        widget.session.scheduleDate;

    if (date == null) {
      return 'Date not provided';
    }

    return DateTimeUtils.formatFullDate(date);
  }

  Widget _buildDateSectionLabel() {
    return Text(
      'SELECT DATE',
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppColors.inkMid,
      ),
    );
  }

  Widget _buildSlotSectionLabel() {
    return Text(
      'AVAILABLE SLOTS',
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppColors.inkMid,
      ),
    );
  }

  Widget _buildSlotList(
    List<ScheduleSlot> openSlots,
  ) {
    return ListView.separated(
      itemCount: openSlots.length,
      separatorBuilder: (_, _) =>
          const SizedBox(
        height: AppSizes.spacingSm,
      ),
      itemBuilder: (context, index) {
        final slot = openSlots[index];

        return _SlotOption(
          slot: slot,
          selected:
              _selectedSlot?.id == slot.id,
          onTap: () {
            setState(() {
              _selectedSlot = slot;
            });
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 40,
              color: AppColors.inkMute,
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Text(
              'No available slots',
              style:
                  context.textTheme.headlineLarge,
            ),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            Text(
              'There are no open slots available '
              'for this date. Please select another date.',
              textAlign: TextAlign.center,
              style:
                  context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton({
    required bool isUpdating,
  }) {
    return AppButton(
      width: double.infinity,
      text: isUpdating
          ? 'Rescheduling...'
          : 'Confirm Reschedule',
      onPressed:
          _selectedSlot == null || isUpdating
              ? null
              : _confirmReschedule,
    );
  }

  Future<void> _confirmReschedule() async {
    final newSlot = _selectedSlot;

    if (newSlot == null ||
        newSlot.id == null) {
      return;
    }

    final confirmed =
        await showConfirmationDialog(
      context,
      title: 'Reschedule Session?',
      message:
          'Are you sure you want to reschedule this session to the selected time?',
      confirmText: 'Reschedule',
      icon: Icons.event_repeat_outlined,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final success = await ref
        .read(sessionProvider.notifier)
        .rescheduleSession(
          sessionId: widget.session.id!,
          scheduleSlotId: newSlot.id!,
        );

    if (!mounted) {
      return;
    }

    if (success) {
     Navigator.of(context).pop(true);
    } else {
      final errorMessage =
          ref.read(sessionProvider).errorMessage;

      AppSnackBar.showError(
        errorMessage ??
            'Unable to reschedule session.',
      );
    }
  }
}

class _SlotOption extends StatelessWidget {
  const _SlotOption({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final ScheduleSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(
        AppSizes.spacingMd,
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSizes.minTapTarget,
        ),
        padding: const EdgeInsets.all(
          AppSizes.spacingMd,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
          border: Border.all(
            color: selected
                ? AppColors.pine
                : AppColors.mist,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _SelectionIndicator(
              selected: selected,
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
                    slot.date == null
                        ? 'Date not provided'
                        : DateTimeUtils
                            .formatFullDate(
                            slot.date!,
                          ),
                    style: context
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize:
                          AppSizes.fontSizeSm,
                    ),
                  ),

                  const SizedBox(
                    height: AppSizes.spacingXs,
                  ),

                  Text(
                    DateTimeUtils
                        .formatTimeString(
                      slot.time,
                    ),
                    style: context
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                      letterSpacing: 0.7,
                      color:
                          AppColors.inkMid,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionIndicator
    extends StatelessWidget {
  const _SelectionIndicator({
    required this.selected,
  });

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? AppColors.pine
              : AppColors.inkMute,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration:
                    const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pine,
                ),
              ),
            )
          : null,
    );
  }
}