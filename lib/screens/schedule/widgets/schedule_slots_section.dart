
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/data/providers/schedule_provider.dart';
import 'package:physioghar/data/providers/session_provider.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/schedule/widgets/schedule_slot_card.dart';

class ScheduleSlotsSection extends ConsumerWidget {
  const ScheduleSlotsSection({
    super.key,
    required this.selectedDate,
    required this.slots,
  });

  final DateTime selectedDate;
  final List<ScheduleSlot> slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      separatorBuilder: (_, _) => const SizedBox(
        height: AppSizes.spacingSm,
      ),
      itemBuilder: (context, index) {
        final slot = selectedDaySlots[index];

        return ScheduleSlotCard(
          key: Key('schedule-slot-${slot.id}'),
          slot: slot,
          onTap: () {
            _showSlotActions(
              context,
              ref,
              slot,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 28,
            color: AppColors.pine,
          ),
          const SizedBox(
            width: AppSizes.spacingMd,
          ),
          Expanded(
            child: Text(
              'No time slots available. Add an available slot to start managing your schedule.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: AppColors.inkMute,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSlotActions(
    BuildContext context,
    WidgetRef ref,
    ScheduleSlot slot,
  ) {
    switch (slot.status) {
      case ScheduleSlotStatus.open:
      case ScheduleSlotStatus.blocked:
        _showManageSlotSheet(
          context,
          ref,
          slot,
        );
        break;

      case ScheduleSlotStatus.booked:
        _showBookedSlotSheet(
          context,
          ref,
          slot,
        );
        break;

      case null:
        _showManageSlotSheet(
          context,
          ref,
          slot,
        );
        break;
    }
  }

  void _showManageSlotSheet(
    BuildContext context,
    WidgetRef ref,
    ScheduleSlot slot,
  ) {
    final isBlocked =
        slot.status == ScheduleSlotStatus.blocked;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSizes.spacingXl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isBlocked
                      ? 'Unblock Slot'
                      : 'Manage Slot',
                  style: Theme.of(sheetContext)
                      .textTheme
                      .headlineLarge,
                ),

                const SizedBox(
                  height: AppSizes.spacingSm,
                ),

                Text(
                  isBlocked
                      ? 'Make this time slot available again?'
                      : 'Block this available time slot?',
                  style: Theme.of(sheetContext)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(
                  height: AppSizes.spacingXl,
                ),

                AppButton(
                  width: double.infinity,
                  text: isBlocked
                      ? 'Unblock Slot'
                      : 'Block Slot',
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();

                    final success = isBlocked
                        ? await ref
                            .read(
                              scheduleProvider
                                  .notifier,
                            )
                            .unblockSlot(slot)
                        : await ref
                            .read(
                              scheduleProvider
                                  .notifier,
                            )
                            .blockSlot(slot);

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
                      final errorMessage = ref
                          .read(scheduleProvider)
                          .errorMessage;

                      AppSnackBar.showError(
                        errorMessage ??
                            'Unable to update slot.',
                      );
                    }
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingSm,
                ),

                AppButton(
                  width: double.infinity,
                  text: 'Delete Slot',
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  variant:
                      AppButtonVariant.secondary,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();

                    _confirmDeleteSlot(
                      context,
                      ref,
                      slot,
                    );
                  },
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
    WidgetRef ref,
    ScheduleSlot slot,
  ) async {
    final confirmed =
        await showConfirmationDialog(
      context,
      title: 'Delete Slot?',
      message:
          'Are you sure you want to delete this schedule slot?',
      confirmText: 'Delete Slot',
      icon: Icons.delete_outline,
      isDestructive: true,
    );

    if (confirmed != true ||
        !context.mounted) {
      return;
    }

    final success = await ref
        .read(scheduleProvider.notifier)
        .deleteSlot(slot);

    if (!context.mounted) {
      return;
    }

    if (success) {
      AppSnackBar.showSuccess(
        'Slot deleted successfully.',
      );
    } else {
      final errorMessage = ref
          .read(scheduleProvider)
          .errorMessage;

      AppSnackBar.showError(
        errorMessage ??
            'Unable to delete slot.',
      );
    }
  }

  Future<void> _showBookedSlotSheet(
    BuildContext context,
    WidgetRef ref,
    ScheduleSlot slot,
  ) async {
    final navigator = Navigator.of(context);

    Session? session;

    if (slot.sessionId != null) {
      final sessions =
          ref.read(sessionProvider).sessions;

      for (final item in sessions) {
        if (item.id == slot.sessionId) {
          session = item;
          break;
        }
      }

      session ??= await ref
          .read(sessionProvider.notifier)
          .getSession(slot.sessionId!);
    }

    if (!context.mounted) {
      return;
    }

    final shouldOpenDetails =
        await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cream,
      builder: (sheetContext) {
        if (session == null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSizes.spacingXl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.dangerPale,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: AppColors.danger,
                      size: 28,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingLg,
                  ),
                  const Text(
                    'Session not found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingSm,
                  ),
                  const Text(
                    'Unable to load the session details for this booked slot.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.inkMid,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingXl,
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingXl,
            ),
            child: SizedBox(
              height: ResponsiveUtils.heightPercent(
                context,
                0.5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booked Session',
                              style: Theme.of(
                                sheetContext,
                              )
                                  .textTheme
                                  .headlineLarge,
                            ),
                            const SizedBox(
                              height: AppSizes.spacingXs,
                            ),
                            Text(
                              'Session details',
                              style: Theme.of(
                                sheetContext,
                              )
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(
                        status: session
                            .status
                            .toString()
                            .split('.')
                            .last,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: AppSizes.spacingSm,
                  ),

                  _buildPatientCard(
                    sheetContext,
                    session,
                  ),

                  const SizedBox(
                    height: AppSizes.spacingSm,
                  ),

                  _buildSessionInfoCard(
                    sheetContext,
                    slot,
                    session,
                  ),

                  const SizedBox(
                    height: AppSizes.spacingXl,
                  ),

                  AppButton(
                    width: double.infinity,
                    text: 'View Session',
                    icon: const Icon(
                      Icons.arrow_forward,
                    ),
                    onPressed: () {
                      Navigator.of(
                        sheetContext,
                      ).pop(true);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!context.mounted ||
        shouldOpenDetails != true ||
        session?.id == null) {
      return;
    }

    navigator.pushNamed(
      AppRouter.sessionDetail,
      arguments: session!.id,
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    Session session,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSizes.spacingMd,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        border: Border.all(
          color: AppColors.mist,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
          const SizedBox(
            width: AppSizes.spacingMd,
          ),
          Expanded(
            child: Text(
              session.patientName ?? 'Unknown',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfoCard(
    BuildContext context,
    ScheduleSlot slot,
    Session session,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSizes.spacingLg,
      ),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Column(
        children: [
          _SessionInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateTimeUtils.formatDate(
              slot.dateTime,
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
          _SessionInfoRow(
            icon: Icons.access_time_outlined,
            label: 'Time',
            value: DateTimeUtils.formatTime(
              slot.dateTime,
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
          _SessionInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: session.location ?? '',
          ),
        ],
      ),
    );
  }
}

class _SessionInfoRow extends StatelessWidget {
  const _SessionInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
          child: Icon(
            icon,
            size: 20,
            color: AppColors.pine,
          ),
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
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall,
              ),
              const SizedBox(
                height: AppSizes.spacingXs,
              ),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        status == 'requested'
            ? AppColors.pinePale
            : status == 'upcoming'
                ? AppColors.amberPale
                : status == 'completed'
                    ? AppColors.mist
                    : AppColors.dangerPale;

    final textColor =
        status == 'requested'
            ? AppColors.pine
            : status == 'upcoming'
                ? AppColors.amber
                : status == 'completed'
                    ? AppColors.inkMid
                    : AppColors.danger;

    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSizes.minTapTarget,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          AppSizes.buttonRadius,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}