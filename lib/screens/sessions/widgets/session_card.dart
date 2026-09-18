import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/data/providers/schedule_provider.dart';
import 'package:physioghar/data/providers/session_provider.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/sessions/widgets/complete_session_bottom_sheet.dart';
import 'package:physioghar/screens/sessions/widgets/reschedule_bottom_sheet.dart';

class SessionCard extends ConsumerWidget {
  const SessionCard({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      borderColor: AppColors.mist,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),

          const SizedBox(height: AppSizes.spacingMd),

          _buildSessionInfo(context),

          const SizedBox(height: AppSizes.spacingLg),

          _buildActions(context, ref),
        ],
      ),
    );
  }

  Future<void> _refreshSchedule(WidgetRef ref) async {
    final selectedDate = ref.read(scheduleProvider).selectedDate;

    await ref.read(scheduleProvider.notifier).loadSchedules(date: selectedDate);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            session.patientName ?? 'Unknown Patient',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: AppSizes.spacingSm),

        _StatusBadge(status: session.status),
      ],
    );
  }

  Widget _buildSessionInfo(BuildContext context) {
    return Column(
      children: [
        _InfoRow(
          icon: Icons.medical_services_outlined,
          text: session.treatment ?? 'Treatment not provided',
        ),

        const SizedBox(height: AppSizes.spacingSm),

        _InfoRow(
          icon: Icons.calendar_today_outlined,
          text: session.scheduleDate == null
              ? 'Date not provided'
              : DateTimeUtils.formatFullDate(session.scheduleDate!),
        ),

        const SizedBox(height: AppSizes.spacingSm),

        _InfoRow(
          icon: Icons.access_time_outlined,
          text: DateTimeUtils.formatTimeString(session.scheduleTime),
        ),

        const SizedBox(height: AppSizes.spacingSm),

        _InfoRow(
          icon: Icons.location_on_outlined,
          text: session.location ?? 'Location not provided',
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    switch (session.status) {
      case SessionStatus.requested:
        return _buildRequestedActions(context, ref);

      case SessionStatus.upcoming:
        return _buildUpcomingActions(context, ref);

      case SessionStatus.completed:
        return _buildViewDetailsButton(context);

      case SessionStatus.cancelled:
        return _buildViewDetailsButton(context);

      case null:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRequestedActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Decline',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              _handleDecline(context, ref);
            },
          ),
        ),

        const SizedBox(width: AppSizes.spacingMd),

        Expanded(
          child: AppButton(
            text: 'Accept',
            onPressed: () {
              _handleAccept(context, ref);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingActions(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                text: 'View',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRouter.sessionDetail, arguments: session.id);
                },
              ),

              const SizedBox(height: AppSizes.spacingSm),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Reschedule',
                      variant: AppButtonVariant.secondary,
                      onPressed: () {
                        _handleReschedule(context, ref);
                      },
                    ),
                  ),

                  const SizedBox(width: AppSizes.spacingSm),

                  Expanded(
                    child: AppButton(
                      text: 'Complete',
                      onPressed: () {
                        _handleComplete(context, ref);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'View',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRouter.sessionDetail, arguments: session.id);
                },
              ),
            ),

            const SizedBox(width: AppSizes.spacingSm),

            Expanded(
              child: AppButton(
                text: 'Reschedule',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  _handleReschedule(context, ref);
                },
              ),
            ),

            const SizedBox(width: AppSizes.spacingSm),

            Expanded(
              child: AppButton(
                text: 'Complete',
                onPressed: () {
                  _handleComplete(context, ref);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return AppButton(
      width: double.infinity,
      text: 'View Details',
      variant: AppButtonVariant.secondary,
      onPressed: () {
        Navigator.of(context)
            .pushNamed(AppRouter.sessionDetail, arguments: session.id);
      },
    );
  }

  Future<void> _handleAccept(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Accept Booking?',
      message: 'Are you sure you want to accept this booking request?',
      confirmText: 'Accept',
      icon: Icons.check_circle_outline,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final success = await ref
        .read(sessionProvider.notifier)
        .acceptSession(session.id!);

    await _refreshSchedule(ref);

    if (!context.mounted) {
      return;
    }

    if (success) {
      AppSnackBar.showSuccess('Booking request accepted.');
    } else {
      final errorMessage = ref.read(sessionProvider).errorMessage;

      AppSnackBar.showError(
        errorMessage ?? 'Unable to accept booking request.',
      );
    }
  }

  Future<void> _handleDecline(BuildContext context, WidgetRef ref) async {
    final reasonController = TextEditingController();

    try {
      final reason = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Decline Booking?'),
            content: TextField(
              controller: reasonController,
              autofocus: true,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Cancellation reason',
                hintText: 'Why are you declining this request?',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final reason = reasonController.text.trim();

                  if (reason.isEmpty) {
                    return;
                  }

                  Navigator.of(dialogContext).pop(reason);
                },
                child: const Text('Decline'),
              ),
            ],
          );
        },
      );

      if (reason == null || reason.isEmpty || !context.mounted) {
        return;
      }

      final success = await ref
          .read(sessionProvider.notifier)
          .declineSession(sessionId: session.id!, cancellationReason: reason);

      if (!context.mounted) {
        return;
      }

      if (success) {
        AppSnackBar.showSuccess('Booking request declined.');

        await _refreshSchedule(ref);
      } else {
        final errorMessage = ref.read(sessionProvider).errorMessage;

        AppSnackBar.showError(
          errorMessage ?? 'Unable to decline booking request.',
        );
      }
    } finally {
      reasonController.dispose();
    }
  }

  Future<void> _handleComplete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Complete Session?',
      message: 'You need to add session notes before completing this session.',
      confirmText: 'Continue',
      icon: Icons.check_circle_outline,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    showCompleteSessionBottomSheet(
      context,
      session: session,
      onComplete: (notes) async {
        final success = await ref
            .read(sessionProvider.notifier)
            .completeSession(sessionId: session.id!, notes: notes);

        if (!success) {
          final errorMessage = ref.read(sessionProvider).errorMessage;

          throw StateError(errorMessage ?? 'Unable to complete session.');
        }

        await _refreshSchedule(ref);

        if (!context.mounted) {
          return;
        }

        AppSnackBar.showSuccess('Session completed successfully.');
      },
    );
  }

  Future<void> _handleReschedule(BuildContext context, WidgetRef ref) async {
    final result = await showRescheduleBottomSheet(context, session: session);

    if (!context.mounted || result != true) {
      return;
    }

    // The bottom sheet loads the newly selected date into
    // scheduleProvider before returning.
    await _refreshSchedule(ref);

    if (!context.mounted) {
      return;
    }

    AppSnackBar.showSuccess('Session rescheduled successfully.');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.inkMute),

        const SizedBox(width: AppSizes.spacingSm),

        Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SessionStatus? status;

  @override
  Widget build(BuildContext context) {
    final currentStatus = status;

    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: _backgroundColor(currentStatus),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Text(
        currentStatus?.label ?? 'UNKNOWN',
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: _foregroundColor(currentStatus),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _foregroundColor(SessionStatus? status) {
    switch (status) {
      case SessionStatus.requested:
        return AppColors.amber;

      case SessionStatus.upcoming:
        return AppColors.pine;

      case SessionStatus.completed:
        return AppColors.pine;

      case SessionStatus.cancelled:
        return AppColors.danger;

      case null:
        return AppColors.inkMute;
    }
  }

  Color _backgroundColor(SessionStatus? status) {
    switch (status) {
      case SessionStatus.requested:
        return AppColors.amberPale;

      case SessionStatus.upcoming:
        return AppColors.pinePale;

      case SessionStatus.completed:
        return AppColors.pinePale;

      case SessionStatus.cancelled:
        return AppColors.dangerPale;

      case null:
        return AppColors.mist;
    }
  }
}
