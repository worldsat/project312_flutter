import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 24-hr / Period Consumption Dynamics custom Bézier spline visualizer.
/// Displays peak telemetry callout and multi-gradient neon flow wave.
class ConsumptionDynamicsGraph extends StatefulWidget {
  final String peakLabel;

  const ConsumptionDynamicsGraph({
    super.key,
    required this.peakLabel,
  });

  @override
  State<ConsumptionDynamicsGraph> createState() =>
      _ConsumptionDynamicsGraphState();
}

class _ConsumptionDynamicsGraphState extends State<ConsumptionDynamicsGraph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.30).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(double.infinity, 110),
                painter: _ConsumptionDynamicsPainter(
                  peakPulseFactor: _pulseAnimation.value,
                ),
              );
            },
          ),
          // Peak Floating Pill Callout
          Positioned(
            top: 2,
            right: 48,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.alertCrimson.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.priority_high_rounded,
                    size: 12,
                    color: AppColors.alertCrimson,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    widget.peakLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onBackgroundSlate50,
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

class _ConsumptionDynamicsPainter extends CustomPainter {
  final double peakPulseFactor;

  _ConsumptionDynamicsPainter({
    required this.peakPulseFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Reference dashed grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1.0;

    _drawDashedLine(canvas, Offset(0, h * 0.25), Offset(w, h * 0.25), gridPaint);
    _drawDashedLine(canvas, Offset(0, h * 0.65), Offset(w, h * 0.65), gridPaint);

    // 2. Exact Bézier Wave Curve mapped from spec
    // M 0,85 C 40,82 60,65 90,62 C 120,59 140,80 170,45 C 200,10 230,20 260,35 C 290,50 305,30 320,28
    final sx = w / 320.0;
    final sy = h / 100.0;

    final curvePath = Path();
    curvePath.moveTo(0 * sx, 85 * sy);
    curvePath.cubicTo(
      40 * sx,
      82 * sy,
      60 * sx,
      65 * sy,
      90 * sx,
      62 * sy,
    );
    curvePath.cubicTo(
      120 * sx,
      59 * sy,
      140 * sx,
      80 * sy,
      170 * sx,
      45 * sy,
    );
    curvePath.cubicTo(
      200 * sx,
      10 * sy,
      230 * sx,
      20 * sy,
      260 * sx,
      35 * sy,
    );
    curvePath.cubicTo(
      290 * sx,
      50 * sy,
      305 * sx,
      30 * sy,
      320 * sx,
      28 * sy,
    );

    // 3. Translucent Under-Fill Area
    final areaPath = Path.from(curvePath);
    areaPath.lineTo(w, h);
    areaPath.lineTo(0, h);
    areaPath.close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.electricCyan.withValues(alpha: 0.35),
          AppColors.electricCyan.withValues(alpha: 0.10),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(areaPath, areaPaint);

    // 4. Neon Gradient Stroke
    final strokePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.ecoEmeraldBright,
          AppColors.electricCyan,
          AppColors.violetAurora,
          AppColors.electricCyan,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(curvePath, strokePaint);

    // 5. Peak Indicator Node at x = 200 * sx, y = 10 * sy
    final peakX = 200.0 * sx;
    final peakY = 10.0 * sy;
    final center = Offset(peakX, peakY);

    // Outer glow ring
    final glowPaint = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, 10.0 * peakPulseFactor, glowPaint);

    // Inner solid core
    final corePaint = Paint()
      ..color = AppColors.electricCyan
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5.0, corePaint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    double dashWidth = 8,
    double dashSpace = 6,
  }) {
    double currentX = start.dx;
    final y = start.dy;
    while (currentX < end.dx) {
      canvas.drawLine(
        Offset(currentX, y),
        Offset(math.min(currentX + dashWidth, end.dx), y),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _ConsumptionDynamicsPainter oldDelegate) {
    return oldDelegate.peakPulseFactor != peakPulseFactor;
  }
}
