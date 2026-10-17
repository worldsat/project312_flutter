import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Frosted Obsidian Glassmorphic Container as specified in DESIGN.md Section 3.3.
/// Features a vertical dark gradient, frosted blur filter, and delicate 1dp linear gradient rim border.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double cornerRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onClick;
  final Gradient? backgroundGradient;
  final Gradient? borderGradient;
  final double blurSigma;

  const GlassContainer({
    super.key,
    required this.child,
    this.cornerRadius = 24.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onClick,
    this.backgroundGradient,
    this.borderGradient,
    this.blurSigma = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final bgGrad = backgroundGradient ??
        LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceContainerLow.withValues(alpha: 0.75),
            AppColors.surfaceObsidian.withValues(alpha: 0.85),
          ],
        );

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius),
            gradient: bgGrad,
            border: Border.all(
              color: AppColors.glassBorderStart,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onClick != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cornerRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(cornerRadius),
          onTap: onClick,
          splashColor: Colors.white.withValues(alpha: 0.08),
          highlightColor: Colors.white.withValues(alpha: 0.04),
          child: content,
        ),
      );
    }

    return content;
  }
}
