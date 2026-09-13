import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/screens/sessions/widgets/reschedule_bottom_sheet.dart';

class SessionCard extends ConsumerWidget {
  const SessionCard({super.key, required this.session});

  final Session session;

  bool _isPastSession() {
    return !session.dateTime.isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          _buildHeader(),
          const SizedBox(height: AppSizes.spacingMd),
          _buildPatientInfo(),
          const SizedBox(height: AppSizes.spacingMd),
          _buildSessionInfo(),
          const SizedBox(height: AppSizes.spacingLg),
          _buildActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            session.patientName,
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

  Widget _buildPatientInfo() {
    if (session.patientAge == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        const Icon(Icons.person_outline, size: 18, color: AppColors.inkMid),
        const SizedBox(width: AppSizes.spacingSm),
        Text(
          'Age ${session.patientAge}',
          style: GoogleFonts.inter(
            fontSize: AppSizes.fontSizeMd,
            color: AppColors.inkMid,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionInfo() {
    return Column(
      children: [
        _InfoRow(
          icon: Icons.medical_services_outlined,
          text: session.treatment,
        ),
        const SizedBox(height: AppSizes.spacingSm),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          text: DateTimeUtils.formatFullDate(session.dateTime),
        ),
        const SizedBox(height: AppSizes.spacingSm),
        _InfoRow(
          icon: Icons.access_time_outlined,
          text: DateTimeUtils.formatTime(session.dateTime),
        ),
        const SizedBox(height: AppSizes.spacingSm),
        _InfoRow(icon: Icons.location_on_outlined, text: session.location),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(sessionProvider.notifier);

    switch (session.status) {
      case SessionStatus.requested:
        final isPast = _isPastSession();

        if (isPast) {
          return Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Decline',
                  variant: AppButtonVariant.secondary,
                  onPressed: () async {
                    final confirmed = await showConfirmationDialog(
                      context,
                      title: 'Decline Booking?',
                      message: 'Are you sure you want to decline this booking request?',
                      confirmText: 'Decline',
                      icon: Icons.close_outlined,
                      isDestructive: true,
                    );

                    if (confirmed != true) {
                      return;
                    }

                    notifier.declineSession(session.id);

                    if (!context.mounted) {
                      return;
                    }

                    AppSnackBar.showSuccess(
                      context,
                      'Booking request declined.',
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              Expanded(
                child: AppButton(
                  text: 'Reschedule',
                  onPressed: () {
                    showRescheduleBottomSheet(
                      context,
                      session: session,
                      onReschedule: () {
                        AppSnackBar.showSuccess(
                          context,
                          'Booking rescheduled and accepted successfully.',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Decline',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  final confirmed = await showConfirmationDialog(
                    context,
                    title: 'Decline Booking?',
                    message: 'Are you sure you want to decline this booking request?',
                    confirmText: 'Decline',
                    icon: Icons.close_outlined,
                    isDestructive: true,
                  );

                  if (confirmed != true) {
                    return;
                  }

                  notifier.declineSession(session.id);

                  if (!context.mounted) {
                    return;
                  }

                  AppSnackBar.showSuccess(context, 'Booking request declined.');
                },
              ),
            ),
            const SizedBox(width: AppSizes.spacingMd),
            Expanded(
              child: AppButton(
                text: 'Accept',
                onPressed: () async {
                  final confirmed = await showConfirmationDialog(
                    context,
                    title: 'Accept Booking?',
                    message:
                        'Are you sure you want to accept this booking request?',
                    confirmText: 'Accept',
                    icon: Icons.check_circle_outline,
                  );

                  if (confirmed != true) {
                    return;
                  }

                  notifier.acceptSession(session.id);

                  if (!context.mounted) {
                    return;
                  }

                  AppSnackBar.showSuccess(context, 'Booking request accepted.');
                },
              ),
            ),
          ],
        );
      case SessionStatus.upcoming:
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
                    onReschedule: () {
                      AppSnackBar.showSuccess(
                        context,
                        'Session rescheduled successfully.',
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: AppSizes.spacingSm),
            Flexible(
              flex: 4,
              child: AppButton(
                text: 'Complete',
                onPressed: () async {
                  final confirmed = await showConfirmationDialog(
                    context,
                    title: 'Complete Session?',
                    message: 'Are you sure you want to mark this session as completed?',
                    confirmText: 'Complete',
                    icon: Icons.check_circle_outline,
                  );
                  if (confirmed != true) {
                    return;
                  }
                  notifier.completeSession(session.id);
                  if (!context.mounted) {
                    return;
                  }
                  AppSnackBar.showSuccess(
                    context,
                    'Session completed successfully.',
                  );
                },
              ),
            ),
          ],
        );

      case SessionStatus.completed:
        return AppButton(
          text: 'View Session',
          variant: AppButtonVariant.secondary,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AppRouter.sessionDetail, arguments: session.id);
          },
        );

      case SessionStatus.cancelled:
        return AppButton(
          text: 'View Details',
          variant: AppButtonVariant.secondary,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AppRouter.sessionDetail, arguments: session.id);
          },
        );
    }
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

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (status) {
      case SessionStatus.requested:
        label = 'NEW';
        backgroundColor = AppColors.amberPale;
        foregroundColor = AppColors.amber;
        break;

      case SessionStatus.upcoming:
        label = 'UPCOMING';
        backgroundColor = AppColors.pinePale;
        foregroundColor = AppColors.pine;
        break;

      case SessionStatus.completed:
        label = 'COMPLETED';
        backgroundColor = AppColors.pinePale;
        foregroundColor = AppColors.pine;
        break;

      case SessionStatus.cancelled:
        label = 'CANCELLED';
        backgroundColor = AppColors.dangerPale;
        foregroundColor = AppColors.danger;
        break;
    }

    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexMono(
          fontSize: AppSizes.fontSizeXs,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
