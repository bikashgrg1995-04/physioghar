import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/schedule/schedule_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';
import 'package:physioghar/screens/sessions/widgets/complete_session_bottom_sheet.dart';
import 'package:physioghar/screens/sessions/widgets/reschedule_bottom_sheet.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.controller,
    required this.scheduleController,
  });

  final Session session;
  final SessionController controller;
  final ScheduleController scheduleController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.mist),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),

          const SizedBox(height: AppSizes.spacingMd),

          _buildSessionInfo(context),

          const SizedBox(height: AppSizes.spacingLg),

          _buildActions(context),
        ],
      ),
    );
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
            style: GoogleFonts.fraunces(
              fontSize: AppSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
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
          text: _formatTime(session.scheduleTime),
        ),

        const SizedBox(height: AppSizes.spacingSm),

        _InfoRow(
          icon: Icons.location_on_outlined,
          text: session.location ?? 'Location not provided',
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (session.status) {
      case SessionStatus.requested:
        return _buildRequestedActions(context);

      case SessionStatus.upcoming:
        return _buildUpcomingActions(context);

      case SessionStatus.completed:
        return _buildViewDetailsButton(context);

      case SessionStatus.cancelled:
        return _buildViewDetailsButton(context);

      case null:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRequestedActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Decline',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              _handleDecline(context);
            },
          ),
        ),

        const SizedBox(width: AppSizes.spacingMd),

        Expanded(
          child: AppButton(
            text: 'Accept',
            onPressed: () {
              _handleAccept(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingActions(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: AppButton(
            text: 'View',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRouter.sessionDetail, arguments: session.id);
            },
          ),
        ),

        const SizedBox(width: AppSizes.spacingSm),

        Flexible(
          flex: 4,
          child: AppButton(
            text: 'Reschedule',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              showRescheduleBottomSheet(
                context,
                session: session,
                sessionController: controller,
                scheduleController: scheduleController,
              );
            },
          ),
        ),

        const SizedBox(width: AppSizes.spacingSm),

        Flexible(
          flex: 4,
          child: AppButton(
            text: 'Complete',
            onPressed: () {
              _handleComplete(context);
            },
          ),
        ),
      ],
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

  Future<void> _handleAccept(BuildContext context) async {
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

    final success = await controller.acceptSession(session.id!);

    if (!context.mounted) {
      return;
    }

    if (success) {
      AppSnackBar.showSuccess('Booking request accepted.');
    } else {
      AppSnackBar.showError(
        controller.errorMessage ?? 'Unable to accept booking request.',
      );
    }
  }

  Future<void> _handleDecline(BuildContext context) async {
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

      final success = await controller.declineSession(
        sessionId: session.id!,
        cancellationReason: reason,
      );

      if (!context.mounted) {
        return;
      }

      if (success) {
        AppSnackBar.showSuccess('Booking request declined.');
      } else {
        AppSnackBar.showError(
          controller.errorMessage ?? 'Unable to decline booking request.',
        );
      }
    } finally {
      reasonController.dispose();
    }
  }

  Future<void> _handleComplete(BuildContext context) async {
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
        final success = await controller.completeSession(
          sessionId: session.id!,
          notes: notes,
        );

        if (!success) {
          throw StateError(
            controller.errorMessage ?? 'Unable to complete session.',
          );
        }

        if (!context.mounted) {
          return;
        }

        AppSnackBar.showSuccess('Session completed successfully.');
      },
    );
  }

  String _formatTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Time not provided';
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

    final minuteText = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hourText:$minuteText $period';
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

        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeMd,
              color: AppColors.inkMid,
            ),
          ),
        ),
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
        style: GoogleFonts.ibmPlexMono(
          fontSize: AppSizes.fontSizeXs,
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
