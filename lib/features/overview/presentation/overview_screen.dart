import 'package:flutter/material.dart';
import '../../../core/components/energy_vector_graph.dart';
import '../../../core/components/equalizer_bars.dart';
import '../../../core/components/glass_container.dart';
import '../../../core/components/neon_pill_switch.dart';
import '../../../core/theme/app_colors.dart';
import '../models/overview_models.dart';

/// OverviewScreen: Complete Flutter conversion of OverviewScreen.kt.
/// Pixel-perfect reproduction of Nexus Habitat Smart Home Overview.
class OverviewScreen extends StatelessWidget {
  final OverviewState state;
  final ValueChanged<OverviewAction> onAction;

  const OverviewScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Main Scrollable Content
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Habitat Telemetry Hero Card
            _TelemetryHeroCard(telemetry: state.telemetry),
            const SizedBox(height: 22),

            // System Mode Selector
            _SystemModesSection(
              currentMode: state.currentMode,
              onModeSelected: (mode) => onAction(ChangeModeAction(mode)),
            ),
            const SizedBox(height: 22),

            // Instant Actions 2x2 Grid
            _InstantActionsSection(
              actions: state.instantActions,
              onToggleAction: (id) => onAction(ToggleInstantActionAction(id)),
            ),
            const SizedBox(height: 22),

            // Energy Consumption Mini Visualizer
            _EnergyVectorSection(energyVector: state.energyVector),
            const SizedBox(height: 22),

            // Active Devices 2x2 Grid
            _ActiveDevicesSection(
              devices: state.activeDevices,
              onDeviceToggle: (id) => onAction(ToggleDevicePowerAction(id)),
              onDeviceLevelChange: (id, lvl) => onAction(SetDeviceLevelAction(id, lvl)),
            ),
          ],
        ),

        // 3. Floating In-Place Feedback Banner
        if (state.feedbackMessage != null)
          Positioned(
            left: 20,
            right: 20,
            bottom: 84,
            child: _FeedbackToast(
              message: state.feedbackMessage!,
              onDismiss: () => onAction(const ClearFeedbackAction()),
            ),
          ),
      ],
    );
  }
}



/// Hero Telemetry Card for Sector Alpha.
class _TelemetryHeroCard extends StatefulWidget {
  final HabitatTelemetry telemetry;

  const _TelemetryHeroCard({required this.telemetry});

  @override
  State<_TelemetryHeroCard> createState() => _TelemetryHeroCardState();
}

class _TelemetryHeroCardState extends State<_TelemetryHeroCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
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
    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          // Top-right Cyber Cyan Glass Glow Flare matching spec
          Positioned(
            right: -20,
            top: -20,
            width: 160,
            height: 160,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.electricCyan.withValues(alpha: 0.22),
                      AppColors.electricCyan.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Status badge and Sensor count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.electricCyan.withValues(alpha: _pulseAnimation.value),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "HABITAT TELEMETRY ACTIVE",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      color: AppColors.electricCyanFixedDim,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.telemetry.sectorName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackgroundSlate50,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Sensor count pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sensors_rounded,
                          size: 15,
                          color: AppColors.ecoEmeraldDim,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.telemetry.activeSensorsCount} Active",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackgroundSlate50,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3-Column Metric Readouts Grid
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.thermostat_rounded,
                      iconTint: AppColors.electricCyan,
                      iconBg: AppColors.electricCyan.withValues(alpha: 0.16),
                      value: "${widget.telemetry.ambientTemp}°",
                      label: "Ambient",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.water_drop_rounded,
                      iconTint: AppColors.electricCyanFixed,
                      iconBg: AppColors.electricCyanFixed.withValues(alpha: 0.16),
                      value: "${widget.telemetry.humidityPercent}%",
                      label: "Humidity",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.air_rounded,
                      iconTint: AppColors.ecoEmeraldBright,
                      iconBg: AppColors.ecoEmeraldBright.withValues(alpha: 0.18),
                      value: "AQI ${widget.telemetry.aqi}",
                      valueColor: AppColors.ecoEmeraldBright,
                      label: widget.telemetry.aqiStatus,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sub-bar status pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.ecoEmeraldDim,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            "Biometric air scrubbers running",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.telemetry.airPurityPercent}% Purity",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.electricCyan,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final Color iconTint;
  final Color iconBg;
  final String value;
  final String label;
  final Color valueColor;

  const _MetricTile({
    required this.icon,
    required this.iconTint,
    required this.iconBg,
    required this.value,
    required this.label,
    this.valueColor = AppColors.onBackgroundSlate50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineGlass.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBg,
            ),
            child: Icon(icon, color: iconTint, size: 18),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariantSlate,
                ),
          ),
        ],
      ),
    );
  }
}

/// System Modes Horizontal Scrollable Chips.
class _SystemModesSection extends StatelessWidget {
  final SystemMode currentMode;
  final ValueChanged<SystemMode> onModeSelected;

  const _SystemModesSection({
    required this.currentMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "System Modes",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundSlate50,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Dynamic Shift",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariantSlate,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: SystemMode.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final mode = SystemMode.values[index];
              final isActive = mode == currentMode;

              final iconData = switch (mode) {
                SystemMode.home => Icons.thermostat_rounded,
                SystemMode.away => Icons.directions_walk_rounded,
                SystemMode.nightProtocol => Icons.bedtime_rounded,
                SystemMode.cinemaMode => Icons.movie_rounded,
                SystemMode.partyAura => Icons.auto_awesome_rounded,
              };

              return GestureDetector(
                onTap: () => onModeSelected(mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.electricCyan.withValues(alpha: 0.22)
                        : AppColors.surfaceContainerHigh.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isActive
                          ? AppColors.electricCyan.withValues(alpha: 0.60)
                          : AppColors.outlineGlass.withValues(alpha: 0.10),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.electricCyan,
                          ),
                        )
                      else ...[
                        Icon(iconData, size: 16, color: AppColors.onSurfaceVariantSlate),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        mode.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                              color: isActive ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Instant Actions 2x2 Glassmorphic Control Cards.
class _InstantActionsSection extends StatelessWidget {
  final List<QuickActionItem> actions;
  final ValueChanged<String> onToggleAction;

  const _InstantActionsSection({
    required this.actions,
    required this.onToggleAction,
  });

  @override
  Widget build(BuildContext context) {
    final firstRow = actions.take(2).toList();
    final secondRow = actions.skip(2).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Instant Actions",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundSlate50,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "One-Tap Execute",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.electricCyanFixedDim,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (firstRow.isNotEmpty)
              Expanded(
                child: _InstantActionCard(
                  item: firstRow[0],
                  onToggle: () => onToggleAction(firstRow[0].id),
                ),
              ),
            const SizedBox(width: 10),
            if (firstRow.length > 1)
              Expanded(
                child: _InstantActionCard(
                  item: firstRow[1],
                  onToggle: () => onToggleAction(firstRow[1].id),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (secondRow.isNotEmpty)
              Expanded(
                child: _InstantActionCard(
                  item: secondRow[0],
                  onToggle: () => onToggleAction(secondRow[0].id),
                ),
              ),
            const SizedBox(width: 10),
            if (secondRow.length > 1)
              Expanded(
                child: _InstantActionCard(
                  item: secondRow[1],
                  onToggle: () => onToggleAction(secondRow[1].id),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _InstantActionCard extends StatelessWidget {
  final QuickActionItem item;
  final VoidCallback onToggle;

  const _InstantActionCard({
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = switch (item.icon) {
      QuickActionIcon.light => Icons.light_mode_rounded,
      QuickActionIcon.climate => Icons.hvac_rounded,
      QuickActionIcon.lock => Icons.lock_rounded,
      QuickActionIcon.fan => Icons.air_rounded,
    };

    final iconTint = switch (item.accent) {
      QuickActionAccent.cyan => AppColors.electricCyan,
      QuickActionAccent.purple => AppColors.violetAurora,
      QuickActionAccent.emerald => AppColors.ecoEmeraldBright,
    };

    final iconBg = switch (item.accent) {
      QuickActionAccent.cyan => AppColors.electricCyan.withValues(alpha: 0.18),
      QuickActionAccent.purple => AppColors.violetContainerVibrant.withValues(alpha: 0.28),
      QuickActionAccent.emerald => AppColors.ecoEmeraldBright.withValues(alpha: 0.20),
    };

    final subtitleColor = switch (item.accent) {
      QuickActionAccent.cyan => AppColors.electricCyan,
      QuickActionAccent.purple => AppColors.violetAurora,
      QuickActionAccent.emerald => item.isEnabled ? AppColors.ecoEmeraldBright : AppColors.onSurfaceVariantSlate,
    };

    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(14),
      onClick: onToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
                child: Icon(iconData, color: iconTint, size: 20),
              ),
              NeonPillSwitch(
                checked: item.isEnabled,
                accent: item.accent,
                onCheckedChange: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackgroundSlate50,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Energy Vector Telemetry Card with custom Bézier flow graph.
class _EnergyVectorSection extends StatelessWidget {
  final EnergyVectorTelemetry energyVector;

  const _EnergyVectorSection({required this.energyVector});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.ecoEmeraldBright.withValues(alpha: 0.18),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.ecoEmeraldBright,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Energy Vector",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onBackgroundSlate50,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Real-time Telemetry",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${energyVector.currentKwh}",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.electricCyan,
                            ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "kWh",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onBackgroundSlate50,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_down_rounded,
                        size: 13,
                        color: AppColors.ecoEmeraldDim,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "${energyVector.deltaPercent}% vs yesterday",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.ecoEmeraldDim,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Custom Canvas Spline Curve
          const EnergyVectorGraph(height: 64),
          const SizedBox(height: 6),

          // Timeline labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: energyVector.timeLabels.map((label) {
              final isNow = label == "Now";
              return Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                      color: isNow ? AppColors.ecoEmeraldBright : AppColors.onSurfaceVariantSlate,
                    ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Active Devices 2x2 Grid with real-time indicators and sliders.
class _ActiveDevicesSection extends StatelessWidget {
  final List<SmartDeviceItem> devices;
  final ValueChanged<String> onDeviceToggle;
  final void Function(String, double) onDeviceLevelChange;

  const _ActiveDevicesSection({
    required this.devices,
    required this.onDeviceToggle,
    required this.onDeviceLevelChange,
  });

  @override
  Widget build(BuildContext context) {
    final firstRow = devices.take(2).toList();
    final secondRow = devices.skip(2).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Active Devices",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundSlate50,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "4 online in zone",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariantSlate,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (firstRow.isNotEmpty)
              Expanded(
                child: _DeviceCard(
                  device: firstRow[0],
                  onToggle: () => onDeviceToggle(firstRow[0].id),
                  onLevelChange: (lvl) => onDeviceLevelChange(firstRow[0].id, lvl),
                ),
              ),
            const SizedBox(width: 10),
            if (firstRow.length > 1)
              Expanded(
                child: _DeviceCard(
                  device: firstRow[1],
                  onToggle: () => onDeviceToggle(firstRow[1].id),
                  onLevelChange: (lvl) => onDeviceLevelChange(firstRow[1].id, lvl),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (secondRow.isNotEmpty)
              Expanded(
                child: _DeviceCard(
                  device: secondRow[0],
                  onToggle: () => onDeviceToggle(secondRow[0].id),
                  onLevelChange: (lvl) => onDeviceLevelChange(secondRow[0].id, lvl),
                ),
              ),
            const SizedBox(width: 10),
            if (secondRow.length > 1)
              Expanded(
                child: _DeviceCard(
                  device: secondRow[1],
                  onToggle: () => onDeviceToggle(secondRow[1].id),
                  onLevelChange: (lvl) => onDeviceLevelChange(secondRow[1].id, lvl),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final SmartDeviceItem device;
  final VoidCallback onToggle;
  final ValueChanged<double> onLevelChange;

  const _DeviceCard({
    required this.device,
    required this.onToggle,
    required this.onLevelChange,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = switch (device.id) {
      "cyberlight_pro" => Icons.wb_twilight_rounded,
      "climate_pod" => Icons.ac_unit_rounded,
      "soundwave_ultra" => Icons.speaker_rounded,
      _ => Icons.blinds_rounded,
    };

    final iconTint = switch (device.accent) {
      DeviceAccent.cyan => AppColors.electricCyan,
      DeviceAccent.cyanPurpleGradient => AppColors.electricCyanFixedDim,
      DeviceAccent.purple => AppColors.violetAurora,
      DeviceAccent.emerald => AppColors.ecoEmeraldBright,
    };

    final iconBg = switch (device.accent) {
      DeviceAccent.cyan => AppColors.electricCyan.withValues(alpha: 0.18),
      DeviceAccent.cyanPurpleGradient => AppColors.electricCyanFixedDim.withValues(alpha: 0.18),
      DeviceAccent.purple => AppColors.violetContainerVibrant.withValues(alpha: 0.28),
      DeviceAccent.emerald => AppColors.ecoEmeraldBright.withValues(alpha: 0.20),
    };

    final badgeBg = switch (device.accent) {
      DeviceAccent.cyan => AppColors.electricCyan.withValues(alpha: 0.15),
      DeviceAccent.cyanPurpleGradient => AppColors.electricCyanFixedDim.withValues(alpha: 0.15),
      DeviceAccent.purple => AppColors.violetContainerVibrant.withValues(alpha: 0.20),
      DeviceAccent.emerald => AppColors.ecoEmeraldBright.withValues(alpha: 0.15),
    };

    final badgeTextColor = switch (device.accent) {
      DeviceAccent.cyan => AppColors.electricCyan,
      DeviceAccent.cyanPurpleGradient => AppColors.electricCyanFixedDim,
      DeviceAccent.purple => AppColors.violetAurora,
      DeviceAccent.emerald => AppColors.ecoEmeraldBright,
    };

    final fillGradient = switch (device.accent) {
      DeviceAccent.cyan => const LinearGradient(
          colors: [AppColors.electricCyan, AppColors.electricCyan],
        ),
      DeviceAccent.cyanPurpleGradient => const LinearGradient(
          colors: [AppColors.electricCyan, AppColors.violetFixedDim],
        ),
      DeviceAccent.purple => const LinearGradient(
          colors: [AppColors.violetContainerVibrant, AppColors.violetAurora],
        ),
      DeviceAccent.emerald => const LinearGradient(
          colors: [AppColors.ecoEmeraldBright, AppColors.ecoEmerald],
        ),
    };

    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(14),
      onClick: onToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
                child: Icon(iconData, color: iconTint, size: 20),
              ),
              if (device.isPlayingAudio)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: EqualizerBars(
                    isAnimating: device.isPoweredOn,
                    barColor: AppColors.violetAurora,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    device.badgeText,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: badgeTextColor,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            device.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackgroundSlate50,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            device.subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: device.id == "soundwave_ultra" ? AppColors.violetAurora : AppColors.onSurfaceVariantSlate,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Glowing Progress Slider Bar
          Container(
            height: 7,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: device.isPoweredOn ? device.level : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: fillGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating in-place feedback toast.
class _FeedbackToast extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _FeedbackToast({
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineGlass,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackgroundSlate50,
                  ),
            ),
          ),
          TextButton(
            onPressed: onDismiss,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(36, 32),
            ),
            child: const Text(
              "OK",
              style: TextStyle(
                color: AppColors.electricCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
