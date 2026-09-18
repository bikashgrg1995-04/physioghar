import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/schedule/schedule_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';
import 'package:physioghar/screens/sessions/widgets/complete_session_bottom_sheet.dart';
import 'package:physioghar/screens/sessions/widgets/reschedule_bottom_sheet.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final SessionController _controller = sessionController;
  late final ScheduleController _scheduleController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _scheduleController = ScheduleController();

    _loadSession();
  }

  Future<void> _loadSession() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    await _controller.getSession(widget.sessionId);

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Session Details',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.danger,
          ),
        ),
      ),
      body: ValueListenableBuilder<Session?>(
        valueListenable: _controller.selectedSession,
        builder: (context, session, _) {
          if (_isLoading) {
            return const AppLoading();
          }

          if (session == null) {
            return _buildNotFoundState();
          }

          return _buildSessionBody(session);
        },
      ),
    );
  }

  Widget _buildSessionBody(Session session) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PatientCard(session: session),

            const SizedBox(height: AppSizes.spacingXl),

            const _SectionLabel(text: 'SESSION INFORMATION'),

            const SizedBox(height: AppSizes.spacingSm),

            _InfoCard(session: session),

            const SizedBox(height: AppSizes.spacingXl),

            const _SectionLabel(text: 'STATUS'),

            const SizedBox(height: AppSizes.spacingSm),

            _StatusCard(status: session.status),

            if (session.status == SessionStatus.completed) ...[
              const SizedBox(height: AppSizes.spacingXl),

              const _SectionLabel(text: 'THERAPIST NOTES'),

              const SizedBox(height: AppSizes.spacingSm),

              _NotesCard(notes: session.notes),
            ],

            if (session.status == SessionStatus.cancelled) ...[
              const SizedBox(height: AppSizes.spacingXl),

              const _SectionLabel(text: 'CANCELLATION REASON'),

              const SizedBox(height: AppSizes.spacingSm),

              _NotesCard(
                notes: session.cancellationReason,
                emptyText: 'No cancellation reason provided.',
              ),
            ],

            if (session.status == SessionStatus.upcoming) ...[
              const SizedBox(height: AppSizes.spacingXl),

              _SessionActions(
                session: session,
                controller: _controller,
                scheduleController: _scheduleController,
                onUpdated: _loadSession,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: AppColors.inkMute,
            ),

            const SizedBox(height: AppSizes.spacingMd),

            Text('Session not found', style: context.textTheme.headlineLarge),

            const SizedBox(height: AppSizes.spacingSm),

            Text(
              _controller.errorMessage ?? 'Unable to load session details.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionActions extends StatelessWidget {
  const _SessionActions({
    required this.session,
    required this.controller,
    required this.scheduleController,
    required this.onUpdated,
  });

  final Session session;
  final SessionController controller;
  final ScheduleController scheduleController;
  final Future<void> Function() onUpdated;

  Future<void> _reschedule(BuildContext context) async {
    final updated = await showRescheduleBottomSheet(
      context,
      session: session,
      sessionController: controller,
      scheduleController: scheduleController,
    );

    if (!updated || !context.mounted) {
      return;
    }

    await onUpdated();
  }

  Future<void> _complete(BuildContext context) async {
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
          AppSnackBar.showError(
            controller.errorMessage ?? 'Unable to complete session.',
          );
          return;
        }

        if (!context.mounted) {
          return;
        }

        AppSnackBar.showSuccess('Session completed successfully.');
      },
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final reasonController = TextEditingController();

    try {
      final reason = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Cancel Session?'),
            content: TextField(
              controller: reasonController,
              autofocus: true,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Cancellation reason',
                hintText: 'Why are you cancelling this session?',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Back'),
              ),
              FilledButton(
                onPressed: () {
                  final reason = reasonController.text.trim();

                  if (reason.isEmpty) {
                    return;
                  }

                  Navigator.of(dialogContext).pop(reason);
                },
                child: const Text('Cancel Session'),
              ),
            ],
          );
        },
      );

      if (reason == null || reason.isEmpty || !context.mounted) {
        return;
      }

      final success = await controller.cancelSession(
        sessionId: session.id!,
        cancellationReason: reason,
      );

      if (!success) {
        AppSnackBar.showError(
          controller.errorMessage ?? 'Unable to cancel session.',
        );

        return;
      }

      if (!context.mounted) {
        return;
      }

      AppSnackBar.showSuccess('Session cancelled successfully.');

      Navigator.of(context).pop();
    } finally {
      reasonController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Reschedule',
                variant: AppButtonVariant.secondary,
                onPressed: () => _reschedule(context),
              ),
            ),

            const SizedBox(width: AppSizes.spacingSm),

            Expanded(
              child: AppButton(
                text: 'Complete',
                onPressed: () => _complete(context),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.spacingSm),

        TextButton(
          onPressed: () => _cancel(context),
          child: Text('Cancel Session', style: context.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacingXl),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.pinePale,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.pine,
              size: 28,
            ),
          ),

          const SizedBox(width: AppSizes.spacingMd),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.patientName ?? 'Unknown Patient',
                  style: context.textTheme.headlineLarge,
                ),

                const SizedBox(height: AppSizes.spacingXs),

                Text(
                  session.patientId == null
                      ? 'Patient ID not available'
                      : 'Patient ID: ${session.patientId}',
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacingLg),

      child: Column(
        children: [
          _InfoRow(
            icon: Icons.medical_services_outlined,
            label: 'Treatment',
            value: session.treatment ?? 'Not provided',
          ),

          const Divider(height: AppSizes.spacingXxl),

          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: session.scheduleDate == null
                ? 'Not provided'
                : DateTimeUtils.formatFullDate(session.scheduleDate!),
          ),

          const Divider(height: AppSizes.spacingXxl),

          _InfoRow(
            icon: Icons.access_time_outlined,
            label: 'Time',
            value:
                session.scheduleTime == null ||
                    session.scheduleTime!.trim().isEmpty
                ? 'Not provided'
                : DateTimeUtils.formatTimeString(session.scheduleTime),
          ),

          const Divider(height: AppSizes.spacingXxl),

          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: session.location ?? 'Not provided',
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});

  final SessionStatus? status;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacingLg),

      child: Row(
        children: [
          Icon(config.$2, color: config.$3, size: 22),

          const SizedBox(width: AppSizes.spacingMd),

          Text(
            config.$4,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: AppSizes.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: config.$3,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData, Color, String) _statusConfig(SessionStatus? status) {
    switch (status) {
      case SessionStatus.requested:
        return (
          AppColors.amberPale,
          Icons.pending_outlined,
          AppColors.amber,
          'REQUESTED',
        );

      case SessionStatus.upcoming:
        return (
          AppColors.pinePale,
          Icons.event_available_outlined,
          AppColors.pine,
          'UPCOMING',
        );

      case SessionStatus.completed:
        return (
          AppColors.pinePale,
          Icons.check_circle_outline,
          AppColors.pine,
          'COMPLETED',
        );

      case SessionStatus.cancelled:
        return (
          AppColors.dangerPale,
          Icons.cancel_outlined,
          AppColors.danger,
          'CANCELLED',
        );

      case null:
        return (
          AppColors.mist,
          Icons.help_outline,
          AppColors.inkMute,
          'UNKNOWN',
        );
    }
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({
    required this.notes,
    this.emptyText = 'No therapist notes added yet.',
  });

  final String? notes;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final hasNotes = notes != null && notes!.trim().isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      borderColor: AppColors.mist,
      child: Text(
        hasNotes ? notes!.trim() : emptyText,
        style: context.textTheme.bodyMedium?.copyWith(
          height: 1.5,
          color: hasNotes ? AppColors.inkMid : AppColors.inkMute,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.pine),

        const SizedBox(width: AppSizes.spacingMd),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMute,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppSizes.spacingXs),

              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.inkMute,
        letterSpacing: 0.8,
      ),
    );
  }
}
