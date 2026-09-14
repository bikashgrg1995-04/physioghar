import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/therapist.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.therapist});

  final Therapist therapist;

  @override
  Widget build(BuildContext context) {
    final isAvailable = therapist.isAvailable;

    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Stack(
        children: [
          // Soft background.
          Positioned.fill(
            child: CustomPaint(painter: _ProfileHeaderWavePainter()),
          ),

          // Decorative leaf.
          Positioned(
            top: 18,
            right: 15,
            child: Opacity(
              opacity: 0.45,
              child: Image.asset(
                'assets/icons/leaf_icon.png',
                width: 58,
                height: 58,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Main content.
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacingLg,
                vertical: AppSizes.spacingLg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ProfileAvatar(avatarUrl: therapist.avatarUrl),
                  const SizedBox(width: AppSizes.spacingLg),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          therapist.name,
                          key: const Key('profile-screen-title'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fraunces(
                            fontSize: AppSizes.fontSizeXxl,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: AppSizes.spacingXs),
                        Text(
                          therapist.specialization,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: AppSizes.fontSizeMd,
                            fontWeight: FontWeight.w500,
                            color: AppColors.inkMid,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingSm),
                        _AvailabilityStatus(isAvailable: isAvailable),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pinePale,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.pine.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: avatarUrl.isNotEmpty
            ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return const _AvatarPlaceholder();
                },
              )
            : const _AvatarPlaceholder(),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/avatar_default_icon.png',

        fit: BoxFit.cover,
      ),

      //Icon(Icons.person_outline, size: 48, color: AppColors.pine),
    );
  }
}

class _AvailabilityStatus extends StatelessWidget {
  const _AvailabilityStatus({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final statusColor = isAvailable ? AppColors.pine : AppColors.inkMid;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.25),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.spacingSm),
        Text(
          isAvailable ? 'Available' : 'Unavailable',
          style: GoogleFonts.inter(
            fontSize: AppSizes.fontSizeLg,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}

class _ProfileHeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Full header background.
    final backgroundPaint = Paint()
      ..color = AppColors.cream
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // 2. Soft mint wave.
    final wavePaint = Paint()
      ..color = AppColors.pinePale.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final wavePath = Path();

    wavePath.moveTo(0, size.height * 0.58);

    wavePath.cubicTo(
      size.width * 0.20,
      size.height * 0.70,
      size.width * 0.38,
      size.height * 0.82,
      size.width * 0.58,
      size.height * 0.66,
    );

    wavePath.cubicTo(
      size.width * 0.75,
      size.height * 0.53,
      size.width * 0.88,
      size.height * 0.44,
      size.width,
      size.height * 0.38,
    );

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);

    // 3. Soft white foreground wave.
    final softWavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.72)
      ..style = PaintingStyle.fill;

    final softWavePath = Path();

    softWavePath.moveTo(0, size.height * 0.68);

    softWavePath.cubicTo(
      size.width * 0.22,
      size.height * 0.78,
      size.width * 0.40,
      size.height * 0.84,
      size.width * 0.60,
      size.height * 0.73,
    );

    softWavePath.cubicTo(
      size.width * 0.78,
      size.height * 0.63,
      size.width * 0.90,
      size.height * 0.57,
      size.width,
      size.height * 0.52,
    );

    softWavePath.lineTo(size.width, size.height);
    softWavePath.lineTo(0, size.height);
    softWavePath.close();

    canvas.drawPath(softWavePath, softWavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
