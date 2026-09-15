
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';

enum DecorativeWaveVariant {
  top,
  bottom,
  soft,
  layered,
}

class DecorativeWave extends StatelessWidget {
  const DecorativeWave({
    super.key,
    this.variant = DecorativeWaveVariant.top,
    this.height = 180,
    this.opacity = 0.55,
    this.color = AppColors.pinePale,
  });

  final DecorativeWaveVariant variant;
  final double height;
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _DecorativeWavePainter(
          variant: variant,
          color: color,
          opacity: opacity,
        ),
      ),
    );
  }
}

class _DecorativeWavePainter extends CustomPainter {
  const _DecorativeWavePainter({
    required this.variant,
    required this.color,
    required this.opacity,
  });

  final DecorativeWaveVariant variant;
  final Color color;
  final double opacity;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    switch (variant) {
      case DecorativeWaveVariant.top:
        _drawTopWave(canvas, size);
        break;

      case DecorativeWaveVariant.bottom:
        _drawBottomWave(canvas, size);
        break;

      case DecorativeWaveVariant.soft:
        _drawSoftWave(canvas, size);
        break;

      case DecorativeWaveVariant.layered:
        _drawLayeredWave(canvas, size);
        break;
    }
  }

  void _drawTopWave(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(0, size.height * 0.32)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.02,
        size.width * 0.40,
        size.height * 0.55,
        size.width * 0.64,
        size.height * 0.30,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.12,
        size.width * 0.92,
        size.height * 0.30,
        size.width,
        size.height * 0.16,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawBottomWave(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.48,
        size.width * 0.42,
        size.height * 0.92,
        size.width * 0.68,
        size.height * 0.64,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.49,
        size.width * 0.92,
        size.height * 0.68,
        size.width,
        size.height * 0.56,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawSoftWave(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(0, size.height * 0.46)
      ..cubicTo(
        size.width * 0.16,
        size.height * 0.18,
        size.width * 0.32,
        size.height * 0.72,
        size.width * 0.50,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.12,
        size.width * 0.82,
        size.height * 0.52,
        size.width,
        size.height * 0.30,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawLayeredWave(
    Canvas canvas,
    Size size,
  ) {
    final backPaint = Paint()
      ..color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final frontPaint = Paint()
      ..color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final backPath = Path()
      ..moveTo(0, size.height * 0.30)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.02,
        size.width * 0.42,
        size.height * 0.62,
        size.width * 0.66,
        size.height * 0.28,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.08,
        size.width * 0.92,
        size.height * 0.28,
        size.width,
        size.height * 0.14,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    final frontPath = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.18,
        size.width * 0.38,
        size.height * 0.78,
        size.width * 0.60,
        size.height * 0.44,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.20,
        size.width * 0.90,
        size.height * 0.48,
        size.width,
        size.height * 0.30,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(backPath, backPaint);
    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(
    covariant _DecorativeWavePainter oldDelegate,
  ) {
    return oldDelegate.variant != variant ||
        oldDelegate.color != color ||
        oldDelegate.opacity != opacity;
  }
}