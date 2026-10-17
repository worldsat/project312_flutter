import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom Routine Toggle Switch featuring an embedded icon (check/close) in the knob.
/// Recreates the exact toggle button from Android RoutineSwitch.kt.
class RoutineSwitch extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onCheckedChange;

  const RoutineSwitch({
    super.key,
    required this.checked,
    required this.onCheckedChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCheckedChange(!checked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.fastOutSlowIn,
        width: 54,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: checked
              ? AppColors.electricCyan
              : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
          boxShadow: checked
              ? [
                  BoxShadow(
                    color: AppColors.electricCyan.withValues(alpha: 0.45),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              checked ? Icons.check_rounded : Icons.close_rounded,
              size: 13,
              color: checked
                  ? AppColors.electricCyan
                  : AppColors.onSurfaceVariantSlate,
            ),
          ),
        ),
      ),
    );
  }
}
