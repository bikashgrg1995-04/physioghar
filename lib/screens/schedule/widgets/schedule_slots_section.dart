import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/providers/schedule_provider.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/schedule/widgets/schedule_slot_card.dart';

class ScheduleSlotsSection extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const ScheduleSlotsSection({super.key, required this.selectedDate});

  @override
  ConsumerState<ScheduleSlotsSection> createState() =>
      _ScheduleSlotsSectionState();
}

class _ScheduleSlotsSectionState extends ConsumerState<ScheduleSlotsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slots = ref.watch(scheduleProvider);

    final selectedDaySlots =
        slots
            .where(
              (slot) =>
                  DateTimeUtils.isSameDay(slot.dateTime, widget.selectedDate),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (selectedDaySlots.isEmpty) {
      return _buildEmptyState(context);
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(10),
      thickness: 4,
      child: ListView.separated(
        key: const Key('schedule-slots-list'),
        controller: _scrollController,
        primary: false,
        itemCount: selectedDaySlots.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spacingSm),
        itemBuilder: (context, index) {
          final slot = selectedDaySlots[index];

          return ScheduleSlotCard(
            key: Key('schedule-slot-${slot.id}'),
            slot: slot,
            onTap: () => _showSlotActions(context, slot),
          );
        },
      ),
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
    final sessions = ref.read(sessionProvider);

    final matchingSessions = sessions
        .where((session) => session.id == slot.sessionId)
        .toList();

    final session = matchingSessions.isEmpty ? null : matchingSessions.first;

    // BOOKED slot
    if (slot.status == ScheduleSlotStatus.booked) {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        backgroundColor: AppColors.cream,
        builder: (sheetContext) {
          if (session == null) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacingXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.mist,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.event_busy_outlined,
                        color: AppColors.inkMute,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMd),
                    Text(
                      'Session details not found',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSizes.spacingXs),
                    Text(
                      'This booked slot is not linked to a session.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingLg),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacingXl,
                AppSizes.spacingSm,
                AppSizes.spacingXl,
                AppSizes.spacingXl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booked Session',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: AppSizes.spacingXs),
                            Text(
                              'Session details',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingMd,
                          vertical: AppSizes.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.amberPale,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'BOOKED',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.spacingLg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      border: Border.all(color: AppColors.mist),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.pinePale,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppColors.pine,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.patientName,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AppSizes.spacingXs),
                              Text(
                                session.treatment,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingLg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.spacingLg),
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    ),
                    child: Column(
                      children: [
                        _SessionInfoRow(
                          icon: Icons.access_time_outlined,
                          label: 'Time',
                          value: DateTimeUtils.formatTime(slot.dateTime),
                        ),
                        const SizedBox(height: AppSizes.spacingMd),
                        _SessionInfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: session.location,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.of(context).pushNamed(
                          AppRouter.sessionDetail,
                          arguments: session,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('View Session'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      return;
    }

    final isBlocked = slot.status == ScheduleSlotStatus.blocked;

    // OPEN / BLOCKED slot
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBlocked ? 'Unblock Slot' : 'Manage Slot',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSizes.spacingSm),
                Text(
                  isBlocked
                      ? 'Make this time slot available again?'
                      : 'Block this available time slot?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final notifier = ref.read(scheduleProvider.notifier);

                      if (isBlocked) {
                        notifier.unblockSlot(slot.id);
                      } else {
                        notifier.blockSlot(slot.id);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(isBlocked ? 'Unblock Slot' : 'Block Slot'),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingSm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Slot?'),
          content: Text(
            'Are you sure you want to delete '
            '${DateTimeUtils.formatTime(slot.dateTime)}? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete Slot'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    ref.read(scheduleProvider.notifier).deleteSlot(slot.id);
  }
}

class _SessionInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SessionInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.pinePale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.pine),
        ),
        const SizedBox(width: AppSizes.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
