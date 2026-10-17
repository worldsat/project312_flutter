import 'dart:ui';
import 'package:flutter/material.dart';
import '../../features/overview/models/overview_models.dart';
import '../theme/app_colors.dart';

/// NexusBottomNavBar: Floating frosted glassmorphic navigation bar.
class NexusBottomNavBar extends StatelessWidget {
  final NavDestination currentDestination;
  final ValueChanged<NavDestination> onDestinationSelected;

  const NexusBottomNavBar({
    super.key,
    required this.currentDestination,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: bottomInset > 0 ? bottomInset : 12.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64.0,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.glassBorderStart,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.50),
                  blurRadius: 36,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: NavDestination.values.map((destination) {
                final isSelected = destination == currentDestination;

                final iconData = switch (destination) {
                  NavDestination.overview => Icons.dashboard_rounded,
                  NavDestination.rooms => Icons.meeting_room_rounded,
                  NavDestination.routines => Icons.auto_mode_rounded,
                  NavDestination.energy => Icons.energy_savings_leaf_rounded,
                  NavDestination.settings => Icons.settings_rounded,
                };

                return Expanded(
                  child: InkWell(
                    onTap: () => onDestinationSelected(destination),
                    borderRadius: BorderRadius.circular(999),
                    splashColor: AppColors.electricCyan.withValues(alpha: 0.12),
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconData,
                          size: 22,
                          color: isSelected ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    color: AppColors.electricCyan.withValues(alpha: 0.60),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          destination.label,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
