import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/session.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({
    super.key,
    required this.session,
  });

  final Session session;

  @override
  Widget build(BuildContext context) {
    final isCompleted = session.status == SessionStatus.completed;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Session Details',
          style: GoogleFonts.fraunces(
            fontSize: AppSizes.fontSizeXl,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PatientCard(session: session),
              const SizedBox(height: AppSizes.spacingXl),
              _SectionLabel(text: 'SESSION INFORMATION'),
              const SizedBox(height: AppSizes.spacingSm),
              _InfoCard(session: session),
              const SizedBox(height: AppSizes.spacingXl),
              _SectionLabel(text: 'STATUS'),
              const SizedBox(height: AppSizes.spacingSm),
              _StatusCard(status: session.status),
              if (isCompleted) ...[
                const SizedBox(height: AppSizes.spacingXl),
                _SectionLabel(text: 'THERAPIST NOTES'),
                const SizedBox(height: AppSizes.spacingSm),
                _NotesCard(notes: session.notes),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.session,
  });

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.mist),
      ),
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
                  session.patientName,
                  style: GoogleFonts.fraunces(
                    fontSize: AppSizes.fontSizeXl,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                if (session.patientAge != null) ...[
                  const SizedBox(height: AppSizes.spacingXs),
                  Text(
                    'Age ${session.patientAge}',
                    style: GoogleFonts.inter(
                      fontSize: AppSizes.fontSizeMd,
                      color: AppColors.inkMid,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.session,
  });

  final Session session;

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
        children: [
          _InfoRow(
            icon: Icons.medical_services_outlined,
            label: 'Treatment',
            value: session.treatment,
          ),
          const Divider(height: AppSizes.spacingXxl),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateTimeUtils.formatFullDate(session.dateTime),
          ),
          const Divider(height: AppSizes.spacingXxl),
          _InfoRow(
            icon: Icons.access_time_outlined,
            label: 'Time',
            value: DateTimeUtils.formatTime(session.dateTime),
          ),
          const Divider(height: AppSizes.spacingXxl),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: session.location,
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.status,
  });

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor, icon, label) = switch (status) {
      SessionStatus.requested => (
          AppColors.amberPale,
          AppColors.amber,
          Icons.pending_outlined,
          'REQUESTED',
        ),
      SessionStatus.upcoming => (
          AppColors.pinePale,
          AppColors.pine,
          Icons.event_available_outlined,
          'UPCOMING',
        ),
      SessionStatus.completed => (
          AppColors.pinePale,
          AppColors.pine,
          Icons.check_circle_outline,
          'COMPLETED',
        ),
      SessionStatus.cancelled => (
          AppColors.dangerPale,
          AppColors.danger,
          Icons.cancel_outlined,
          'CANCELLED',
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 22,
          ),
          const SizedBox(width: AppSizes.spacingMd),
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(
              fontSize: AppSizes.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({
    required this.notes,
  });

  final String? notes;

  @override
  Widget build(BuildContext context) {
    final hasNotes = notes != null && notes!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.mist),
      ),
      child: Text(
        hasNotes ? notes! : 'No therapist notes added yet.',
        style: GoogleFonts.inter(
          fontSize: AppSizes.fontSizeMd,
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
        Icon(
          icon,
          size: 20,
          color: AppColors.pine,
        ),
        const SizedBox(width: AppSizes.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.ibmPlexMono(
                  fontSize: AppSizes.fontSizeXs,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMute,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeMd,
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
  const _SectionLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.ibmPlexMono(
        fontSize: AppSizes.fontSizeXs,
        fontWeight: FontWeight.w600,
        color: AppColors.inkMute,
        letterSpacing: 0.8,
      ),
    );
  }
}