
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/patient.dart';

class PreviousSessionsCard extends StatelessWidget {
  const PreviousSessionsCard({
    super.key,
    required this.patient,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREVIOUS SESSIONS',
            style: GoogleFonts.ibmPlexMono(
              fontSize: AppSizes.fontSizeXs,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMute,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSizes.spacingMd),
          if (patient.previousSessions.isEmpty)
            Text(
              'No previous sessions',
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.inkMid,
              ),
            )
          else
            ...patient.previousSessions.map(
              (session) => _SessionItem(
                session: session,
              ),
            ),
        ],
      ),
    );
  }
}

class _SessionItem extends StatelessWidget {
  const _SessionItem({
    required this.session,
  });

  final String session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSizes.spacingMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: AppColors.pine,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSizes.spacingMd),
          Expanded(
            child: Text(
              session,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.ink,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}