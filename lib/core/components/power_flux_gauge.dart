import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Concentric Dual-Arc Power Flux Gauge specified in DESIGN.md Section 3.5.
/// Features an outer gradient demand arc, an inner ghost secondary ring, and central telemetry.
class PowerFluxGauge extends StatelessWidget {
  final double totalDemandKw;
  final int selfSustainedPercent;
  final double demandFraction;
  final double ghostFraction;
  final bool isOptimized;

  const PowerFluxGauge({
    super.key,
    required this.totalDemandKw,
    required this.selfSustainedPercent,
    required this.demandFraction,
    required this.ghostFraction,
    this.isOptimized = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: demandFraction),
      duration: const Duration(milliseconds: 900),
      curve: Curves.fastOutSlowIn,
      builder: (context, animatedDemand, child) {
        return SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(240, 240),
                painter: _PowerFluxGaugePainter(
                  demandFraction: animatedDemand,
                  ghostFraction: ghostFraction,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TOTAL DEMAND',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.onSurfaceVariantSlate,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        totalDemandKw.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: isOptimized
                              ? AppColors.ecoEmeraldBright
                              : const Color(0xFFE0FDFF),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'kW',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.electricCyanFixedDim,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Self-Sustained Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.energy_savings_leaf_rounded,
                          size: 13,
                          color: AppColors.ecoEmeraldBright,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$selfSustainedPercent% Self-Sustained',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ecoEmeraldBright,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PowerFluxGaugePainter extends CustomPainter {
  final double demandFraction;
  final double ghostFraction;

  _PowerFluxGaugePainter({
    required this.demandFraction,
    required this.ghostFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 10.0;
    const innerStrokeWidth = 4.0;
    final diameter = math.min(size.width, size.height) - strokeWidth;
    final radius = diameter / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // 1. Inactive base circular track (360°)
    final baseTrackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, 0, 2 * math.pi, false, baseTrackPaint);

    // 2. Active Demand Arc with Gradient (rotating starting at -90°)
    final sweepAngle = 2 * math.pi * demandFraction;
    if (sweepAngle > 0.001) {
      final sweepShader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: const [
          AppColors.electricCyan,
          AppColors.electricCyanFixedDim,
          AppColors.ecoEmeraldBright,
          AppColors.electricCyan,
        ],
      ).createShader(arcRect);

      // Outer soft glow aura
      final glowPaint = Paint()
        ..shader = sweepShader
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4.0
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.35);

      canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, glowPaint);

      // Primary sharp arc
      final primaryArcPaint = Paint()
        ..shader = sweepShader
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, primaryArcPaint);
    }

    // 3. Inner ghost secondary ring (Violet / Cyan draw marker)
    final innerRadius = radius - 16.0;
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    final ghostSweepAngle = 2 * math.pi * ghostFraction;

    final ghostPaint = Paint()
      ..color = AppColors.violetAurora.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(innerRect, -math.pi / 2, ghostSweepAngle, false, ghostPaint);
  }

  @override
  bool shouldRepaint(covariant _PowerFluxGaugePainter oldDelegate) {
    return oldDelegate.demandFraction != demandFraction ||
        oldDelegate.ghostFraction != ghostFraction;
  }
}
