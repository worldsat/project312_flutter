import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom Canvas Bézier curve visualizer for the Energy Vector section.
/// Faithful reproduction of the SVG telemetry wave from DESIGN.md and screen.png.
class EnergyVectorGraph extends StatefulWidget {
  final double height;

  const EnergyVectorGraph({
    super.key,
    this.height = 64.0,
  });

  @override
  State<EnergyVectorGraph> createState() => _EnergyVectorGraphState();
}

class _EnergyVectorGraphState extends State<EnergyVectorGraph> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: widget.height,
          child: CustomPaint(
            painter: _EnergyVectorPainter(
              pulseFactor: _pulseAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class _EnergyVectorPainter extends CustomPainter {
  final double pulseFactor;

  const _EnergyVectorPainter({required this.pulseFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Reference dashed grid lines
    _drawDashedLine(canvas, Offset(0, h * 0.25), Offset(w, h * 0.25));
    _drawDashedLine(canvas, Offset(0, h * 0.65), Offset(w, h * 0.65));

    // 2. Control points mapped from the design spec (normalized)
    final y0 = h * (45.0 / 60.0);
    final y1 = h * (30.0 / 60.0);
    final y2 = h * (20.0 / 60.0);
    final y3 = h * (32.0 / 60.0);
    final yEnd = h * (12.0 / 60.0);

    final curvePath = Path()
      ..moveTo(0, y0)
      ..cubicTo(w * 0.125, h * (38.0 / 60.0), w * 0.18, y1, w * 0.25, y1)
      ..cubicTo(w * 0.35, y1, w * 0.42, y2, w * 0.50, y2)
      ..cubicTo(w * 0.60, y2, w * 0.68, y3, w * 0.75, y3)
      ..cubicTo(w * 0.85, y3, w * 0.92, yEnd, w, yEnd);

    // 3. Area gradient under curve
    final areaPath = Path.from(curvePath)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.electricCyan.withValues(alpha: 0.28),
          AppColors.electricCyan.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(areaPath, areaPaint);

    // 4. Glowing Stroke
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [
          Color(0xE600F2FE),
          Color(0xF37701D0),
          AppColors.ecoEmeraldBright,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(curvePath, strokePaint);

    // 5. Active Marker ("Now")
    final markerCenter = Offset(w, yEnd);

    // Outer glowing halo
    final outerHaloPaint = Paint()
      ..color = AppColors.ecoEmeraldBright.withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(markerCenter, 10.0 * pulseFactor, outerHaloPaint);

    // Inner glowing core
    final innerCorePaint = Paint()
      ..color = AppColors.ecoEmeraldBright
      ..style = PaintingStyle.fill;
    canvas.drawCircle(markerCenter, 4.5, innerCorePaint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    const dashWidth = 12.0;
    const dashSpace = 10.0;
    double currentX = p1.dx;

    while (currentX < p2.dx) {
      canvas.drawLine(
        Offset(currentX, p1.dy),
        Offset(math.min(currentX + dashWidth, p2.dx), p1.dy),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyVectorPainter oldDelegate) {
    return oldDelegate.pulseFactor != pulseFactor;
  }
}
