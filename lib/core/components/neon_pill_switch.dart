import 'package:flutter/material.dart';
import '../../features/overview/models/overview_models.dart';
import '../theme/app_colors.dart';

/// Interactive Neon Pill Switch conforming to Section 3.4 of DESIGN.md.
/// Features animated knob transition, glowing colored track when ON, and recessed dark look when OFF.
class NeonPillSwitch extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onCheckedChange;
  final QuickActionAccent accent;
  final double width;
  final double height;
  final double knobSize;

  const NeonPillSwitch({
    super.key,
    required this.checked,
    required this.onCheckedChange,
    this.accent = QuickActionAccent.cyan,
    this.width = 48.0,
    this.height = 26.0,
    this.knobSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final activeTrackColor = switch (accent) {
      QuickActionAccent.cyan => AppColors.electricCyan,
      QuickActionAccent.purple => AppColors.violetContainerVibrant,
      QuickActionAccent.emerald => AppColors.ecoEmerald,
    };

    final trackColor = checked ? activeTrackColor : AppColors.surfaceContainerHighest;
    final knobColor = checked ? AppColors.electricCyanDark : const Color(0xFF849495);

    return GestureDetector(
      onTap: () => onCheckedChange(!checked),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(999),
          boxShadow: checked
              ? [
                  BoxShadow(
                    color: activeTrackColor.withValues(alpha: 0.40),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: knobSize,
            height: knobSize,
            decoration: BoxDecoration(
              color: knobColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
