import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/therapist.dart';

class TherapistDetailsCard extends StatelessWidget {
  const TherapistDetailsCard({
    super.key,
    required this.therapist,
    required this.onEdit,
  });

  final Therapist therapist;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingXl),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.mist),
      ),
      child: Stack(
        children: [
        const Positioned.fill(child: _DetailsWaveBackground()),

          Positioned(
            bottom: 60,
            right: 30,
            child: Opacity(
              opacity: 0.45,
              child: Image.asset('assets/images/app_branding.png', height: 60),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  AppSizes.spacingLg, vertical: AppSizes.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Therapist Details',
                      style: GoogleFonts.fraunces(
                        fontSize: AppSizes.fontSizeXl,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      tooltip: 'Edit profile',
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spacingSm),

                _DetailRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: therapist.email ?? '',
                ),

                const SizedBox(height: AppSizes.spacingMd),

                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: therapist.phone ?? '',
                ),

                const SizedBox(height: AppSizes.spacingMd),

                _DetailRow(
                  icon: Icons.work_outline,
                  label: 'Experience',
                  value: therapist.experience ?? '',
                ),

                // const SizedBox(height: AppSizes.spacingMd),

                // _DetailRow(
                //   icon: Icons.medical_services_outlined,
                //   label: 'Specialization',
                //   value: therapist.specialization ?? '',
                // ),

                const SizedBox(height: AppSizes.spacingMd),

                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: therapist.address ?? '',
                ),

                if ((therapist.bio ?? '').isNotEmpty) ...[
                  const SizedBox(height: AppSizes.spacingMd),
                  _DetailRow(
                    icon: Icons.notes_outlined,
                    label: 'Bio',
                    value: therapist.bio ?? '',
                  ),
                ],

                const SizedBox(height: AppSizes.spacingLg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
        Container(
          width: AppSizes.minTapTarget,
          height: AppSizes.minTapTarget,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.pinePale.withValues(alpha: 0.55),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 19, color: AppColors.pine),
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
                  letterSpacing: 0.5,
                  color: AppColors.inkMute,
                ),
              ),

              const SizedBox(height: AppSizes.spacingXs),

              Text(
                value.isEmpty ? 'Not provided' : value,
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeSm,
                  fontWeight: FontWeight.w500,
                  color: value.isEmpty ? AppColors.inkMute : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _DetailsWaveBackground extends StatelessWidget {
  const _DetailsWaveBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DetailsWavePainter());
  }
}

class _DetailsWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.pinePale.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width * 0.55, 0);

    path.cubicTo(
      size.width * 0.72,
      size.height * 0.08,
      size.width * 0.82,
      size.height * 0.18,
      size.width,
      size.height * 0.12,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    final bottomPaint = Paint()
      ..color = AppColors.pinePale.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;

    final bottomPath = Path();

    bottomPath.moveTo(0, size.height * 0.88);

    bottomPath.cubicTo(
      size.width * 0.20,
      size.height * 0.78,
      size.width * 0.40,
      size.height * 0.92,
      size.width * 0.62,
      size.height * 0.84,
    );

    bottomPath.cubicTo(
      size.width * 0.78,
      size.height * 0.78,
      size.width * 0.90,
      size.height * 0.72,
      size.width,
      size.height * 0.76,
    );

    bottomPath.lineTo(size.width, size.height);
    bottomPath.lineTo(0, size.height);
    bottomPath.close();

    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}