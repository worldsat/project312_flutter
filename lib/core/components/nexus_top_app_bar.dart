import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// NexusTopAppBar: Frosted glassmorphic header matching Nexus Habitat specifications.
class NexusTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String habitatName;
  final String statusText;
  final String temperatureText;
  final String powerDemandText;
  final bool hasUnreadNotification;
  final VoidCallback? onNotificationClick;
  final VoidCallback? onAvatarClick;

  const NexusTopAppBar({
    super.key,
    this.habitatName = "Nexus Habitat",
    this.statusText = "Optimal",
    this.temperatureText = "24°C",
    this.powerDemandText = "1.2 kW",
    this.hasUnreadNotification = true,
    this.onNotificationClick,
    this.onAvatarClick,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 80.0 + topPadding,
          padding: EdgeInsets.only(top: topPadding, left: 16, right: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceObsidian.withValues(alpha: 0.75),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.glassBorderEnd,
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Brand Node Icon & Habitat Title
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.70),
                        border: Border.all(
                          color: AppColors.outlineGlass,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricCyan.withValues(alpha: 0.20),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.hub_rounded,
                        color: AppColors.electricCyan,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  habitatName,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.onBackgroundSlate50,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.ecoEmeraldBright,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.ecoEmeraldBright,
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                statusText,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onSurfaceVariantSlate,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "•",
                                style: TextStyle(color: AppColors.onSurfaceVariantSlate, fontSize: 10),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.thermostat_rounded,
                                size: 13,
                                color: AppColors.electricCyan,
                              ),
                              Text(
                                temperatureText,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.electricCyanFixedDim,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Power chip + Notification Bell + Profile Avatar
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Power Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.outlineGlass.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          size: 15,
                          color: AppColors.ecoEmeraldBright,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          powerDemandText,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onBackgroundSlate50,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Notifications Button
                  Stack(
                    children: [
                      IconButton(
                        onPressed: onNotificationClick,
                        icon: const Icon(
                          Icons.notifications_rounded,
                          color: AppColors.onSurfaceVariantSlate,
                          size: 22,
                        ),
                        splashRadius: 22,
                      ),
                      if (hasUnreadNotification)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.electricCyan,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.electricCyan,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Avatar Button
                  GestureDetector(
                    onTap: onAvatarClick,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.electricCyan,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricCyan.withValues(alpha: 0.35),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.electricCyanDark,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
