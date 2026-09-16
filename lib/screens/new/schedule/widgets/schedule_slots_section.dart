import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/screens/new/schedule/schedule_controller.dart';
import 'package:physioghar/screens/new/schedule/widgets/schedule_slot_card.dart';

class ScheduleSlotsSection extends StatelessWidget {
  const ScheduleSlotsSection({
    super.key,
    required this.selectedDate,
    required this.slots,
    required this.controller,
  });

  final DateTime selectedDate;
  final List<ScheduleSlot> slots;
  final ScheduleController controller;

  @override
  Widget build(BuildContext context) {
    final selectedDaySlots = slots
        .where(
          (slot) => DateTimeUtils.isSameDay(
            slot.date ?? DateTime(2000),
            selectedDate,
          ),
        )
        .toList();

    if (selectedDaySlots.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      key: const Key('schedule-slots-list'),
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: selectedDaySlots.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spacingSm),
      itemBuilder: (context, index) {
        final slot = selectedDaySlots[index];

        return ScheduleSlotCard(
          key: Key('schedule-slot-${slot.id}'),
          slot: slot,
          onTap: () {
            _showSlotActions(context, slot);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
        vertical: AppSizes.spacingSm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 28,
            color: AppColors.pine,
          ),
          const SizedBox(width: AppSizes.spacingMd),
          Expanded(
            child: Text(
              'No time slots available. Add an available slot to start managing your schedule.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.inkMute),
            ),
          ),
        ],
      ),
    );
  }

  void _showSlotActions(BuildContext context, ScheduleSlot slot) {
    switch (slot.status) {
      case ScheduleSlotStatus.open:
      case ScheduleSlotStatus.blocked:
        _showManageSlotSheet(context, slot);
        break;

      case ScheduleSlotStatus.booked:
        _showBookedSlotSheet(context, slot);
        break;

      case null:
        _showManageSlotSheet(context, slot);
        break;
    }
  }

  void _showManageSlotSheet(BuildContext context, ScheduleSlot slot) {
    final isBlocked = slot.status == ScheduleSlotStatus.blocked;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBlocked ? 'Unblock Slot' : 'Manage Slot',
                  style: Theme.of(sheetContext).textTheme.headlineLarge,
                ),

                const SizedBox(height: AppSizes.spacingSm),

                Text(
                  isBlocked
                      ? 'Make this time slot available again?'
                      : 'Block this available time slot?',
                  style: Theme.of(sheetContext).textTheme.bodyMedium,
                ),

                const SizedBox(height: AppSizes.spacingXl),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();

                      final success = isBlocked
                          ? await controller.unblockSlot(slot)
                          : await controller.blockSlot(slot);

                      if (!context.mounted) {
                        return;
                      }

                      if (success) {
                        AppSnackBar.showSuccess(
                          isBlocked
                              ? 'Slot unblocked successfully.'
                              : 'Slot blocked successfully.',
                        );
                      } else {
                        AppSnackBar.showError(
                          controller.errorMessage ?? 'Unable to update slot.',
                        );
                      }
                    },
                    child: Text(isBlocked ? 'Unblock Slot' : 'Block Slot'),
                  ),
                ),

                const SizedBox(height: AppSizes.spacingSm),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();

                      _confirmDeleteSlot(context, slot);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete Slot'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteSlot(
    BuildContext context,
    ScheduleSlot slot,
  ) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Slot?',
      message: 'Are you sure you want to delete this schedule slot?',
      confirmText: 'Delete Slot',
      icon: Icons.delete_outline,
      isDestructive: true,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final success = await controller.deleteSlot(slot);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Slot deleted successfully.'
              : controller.errorMessage ?? 'Unable to delete slot.',
        ),
      ),
    );
  }

  void _showBookedSlotSheet(BuildContext context, ScheduleSlot slot) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Booked Slot',
                        style: Theme.of(sheetContext).textTheme.headlineLarge,
                      ),
                    ),
                    _StatusBadge(status: ScheduleSlotStatus.booked),
                  ],
                ),

                const SizedBox(height: AppSizes.spacingLg),

                Text(
                  'Date',
                  style: Theme.of(sheetContext).textTheme.labelSmall,
                ),

                const SizedBox(height: AppSizes.spacingXs),

                Text(
                  slot.date == null
                      ? 'Not provided'
                      : DateTimeUtils.formatFullDate(slot.date!),
                  style: Theme.of(sheetContext).textTheme.bodyMedium,
                ),

                const SizedBox(height: AppSizes.spacingMd),

                Text(
                  'Time',
                  style: Theme.of(sheetContext).textTheme.labelSmall,
                ),

                const SizedBox(height: AppSizes.spacingXs),

                Text(
                  _formatTimeRange(slot),
                  style: Theme.of(sheetContext).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),

                if (slot.sessionId != null) ...[
                  const SizedBox(height: AppSizes.spacingMd),
                  Text(
                    'Session ID',
                    style: Theme.of(sheetContext).textTheme.labelSmall,
                  ),
                  const SizedBox(height: AppSizes.spacingXs),
                  Text(
                    slot.sessionId!,
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                ],

                const SizedBox(height: AppSizes.spacingLg),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimeRange(ScheduleSlot slot) {
    final time = _formatTime(slot.time);

    if (time == '--') {
      return 'Time not provided';
    }

    return time;
  }

  String _formatTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '--';
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return value;
    }

    final hour = int.tryParse(parts[0]);

    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return value;
    }

    final time = TimeOfDay(hour: hour, minute: minute);

    final hourText = time.hourOfPeriod.toString().padLeft(2, '0');

    final minuteText = minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hourText:$minuteText $period';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ScheduleSlotStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: status.color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
