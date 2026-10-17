import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/components/consumption_dynamics_graph.dart';
import '../../../core/components/glass_container.dart';
import '../../../core/components/power_flux_gauge.dart';
import '../../../core/theme/app_colors.dart';
import '../models/energy_models.dart';

/// EnergyAnalyticsScreen: Complete UI for the energy_analytics destination.
/// Replicates Android EnergyAnalyticsScreen.kt and DESIGN.md specifications.
class EnergyAnalyticsScreen extends StatefulWidget {
  final EnergyUiState state;
  final ValueChanged<EnergyUiAction> onAction;

  const EnergyAnalyticsScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<EnergyAnalyticsScreen> createState() => _EnergyAnalyticsScreenState();
}

class _EnergyAnalyticsScreenState extends State<EnergyAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
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
    return Container(
      color: AppColors.obsidianBackground,
      child: Stack(
        children: [
          // 1. Ambient Light Backdrops
          const _EnergyAmbientBackdrops(),

          // 2. Main Scrollable Matrix
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Header & Micro Status
              _buildMatrixHeader(),
              const SizedBox(height: 20),

              // Power Flux Nexus Card
              _buildPowerFluxSection(),
              const SizedBox(height: 20),

              // Consumption Dynamics Card
              _buildConsumptionDynamicsSection(),
              const SizedBox(height: 20),

              // Active Appliance Drain Breakdown
              _buildApplianceDrainSection(),
              const SizedBox(height: 20),

              // Nexus Intelligence / AI Recommendations
              _buildNexusIntelligenceSection(),
            ],
          ),

          // 3. Local Feedback Snackbar Overlay
          if (widget.state.userFeedback != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.electricCyan.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.state.userFeedback!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.onBackgroundSlate50,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          widget.onAction(const ClearFeedbackAction()),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(40, 32),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: AppColors.electricCyan,
                          fontWeight: FontWeight.bold,
                        ),
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

  /// Top title block: Energy Matrix & Grid Sync micro status.
  Widget _buildMatrixHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Energy Matrix',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackgroundSlate50,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.ecoEmeraldDim
                              .withValues(alpha: _pulseAnimation.value),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Live telemetry & predictive eco-routing',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariantSlate,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Grid Sync Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.outlineGlass.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 15,
                color: AppColors.ecoEmeraldDim,
              ),
              SizedBox(width: 4),
              Text(
                'Grid Sync',
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
    );
  }

  /// Real-Time Energy Nexus Card (Power Flux Gauge & Solar vs Grid sub-panels).
  Widget _buildPowerFluxSection() {
    final powerFlux = widget.state.powerFlux;
    final isOptimized = widget.state.intelligence.isOptimizationApplied;

    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Power Flux + Update status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sync_alt_rounded,
                      size: 16,
                      color: AppColors.electricCyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Power Flux',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onBackgroundSlate50,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  powerFlux.lastUpdatedText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariantSlate,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Radial Concentric Gauge
          Center(
            child: PowerFluxGauge(
              totalDemandKw: powerFlux.totalDemandKw,
              selfSustainedPercent: powerFlux.selfSustainedPercent,
              demandFraction: powerFlux.demandArcFraction,
              ghostFraction: powerFlux.ghostArcFraction,
              isOptimized: isOptimized,
            ),
          ),
          const SizedBox(height: 16),

          // Sub-Panels: Solar Inflow vs Grid Pull
          Row(
            children: [
              // Solar Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outlineGlass.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.ecoEmeraldBright,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Solar Inflow',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.solar_power_rounded,
                            size: 16,
                            color: AppColors.ecoEmeraldBright,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '+${powerFlux.solarInflowKw}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ecoEmeraldBright,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            ' kW',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ecoEmeraldDim,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${powerFlux.activePanelsCount} panels active',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariantSlate.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Grid Pull Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outlineGlass.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.violetAurora,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Grid Pull',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.electric_bolt_rounded,
                            size: 16,
                            color: AppColors.violetAurora,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${powerFlux.gridPullKw}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.violetAurora,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            ' kW',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.violetAurora.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        powerFlux.gridTierRate,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariantSlate.withValues(alpha: 0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Consumption Dynamics with timeline filter pills and wave graph.
  Widget _buildConsumptionDynamicsSection() {
    final data = widget.state.consumptionDynamics;

    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Segmented Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Consumption Dynamics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundSlate50,
                      ),
                    ),
                    const Text(
                      'Timeline variance & peak telemetry',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariantSlate,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Filter Pill Group (Day, Week, Month, Year)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withValues(alpha: 0.80),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: TimelinePeriod.values.map((period) {
                    final isSelected = period == data.selectedPeriod;
                    return GestureDetector(
                      onTap: () => widget.onAction(SelectPeriodAction(period)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.electricCyan
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          period.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.electricCyanDark
                                : AppColors.onSurfaceVariantSlate,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Inner Wave Curve Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.outlineGlass.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Off-peak badge row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.electricCyanFixedDim,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              data.offPeakWindow,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.electricCyanFixedDim,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.costDelta,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ecoEmeraldBright,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Vector Bézier Wave Graph
                ConsumptionDynamicsGraph(
                  peakLabel: data.peakLabel,
                ),
                const SizedBox(height: 4),

                // Horizontal Time Ticks
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: data.timeLabels
                        .map(
                          (tick) => Text(
                            tick,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.onSurfaceVariantSlate,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Insights Footer Strip
          Row(
            children: [
              // Daily Run Rate
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.trending_down_rounded,
                        size: 18,
                        color: AppColors.ecoEmeraldDim,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Run Rate',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                            ),
                            Text(
                              data.dailyRunRate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackgroundSlate50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Cycle Savings
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.savings_rounded,
                        size: 18,
                        color: AppColors.electricCyan,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cycle Savings',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                            ),
                            Text(
                              data.cycleSavings,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackgroundSlate50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Top Consuming Devices Breakdown with interactive Eco-Tips.
  Widget _buildApplianceDrainSection() {
    final appliances = widget.state.appliances;

    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Appliance Drain',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundSlate50,
                      ),
                    ),
                    const Text(
                      'Real-time hardware power allotment',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariantSlate,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${appliances.length} Active',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackgroundSlate50,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // List of Appliance Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appliances.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildApplianceCard(appliances[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApplianceCard(ApplianceDrainItem item) {
    final iconData = switch (item.id) {
      'climate_control' => Icons.air_rounded,
      'water_heater' => Icons.water_drop_rounded,
      'ambient_lighting' => Icons.lightbulb_rounded,
      _ => Icons.desktop_windows_rounded,
    };

    final iconTint = switch (item.accent) {
      ApplianceAccent.cyan => AppColors.electricCyan,
      ApplianceAccent.purple => AppColors.violetAurora,
      ApplianceAccent.cyanDim => AppColors.electricCyanFixedDim,
      ApplianceAccent.emerald => AppColors.ecoEmeraldDim,
    };

    final iconBg = switch (item.accent) {
      ApplianceAccent.cyan => AppColors.electricCyan.withValues(alpha: 0.16),
      ApplianceAccent.purple =>
        AppColors.violetContainerVibrant.withValues(alpha: 0.22),
      ApplianceAccent.cyanDim =>
        AppColors.electricCyanFixedDim.withValues(alpha: 0.16),
      ApplianceAccent.emerald =>
        AppColors.ecoEmeraldBright.withValues(alpha: 0.16),
    };

    final barColor = switch (item.accent) {
      ApplianceAccent.cyan => AppColors.electricCyan,
      ApplianceAccent.purple => AppColors.violetAurora,
      ApplianceAccent.cyanDim => AppColors.electricCyanFixedDim,
      ApplianceAccent.emerald => AppColors.ecoEmeraldDim,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineGlass.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon + Name + Zone
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        size: 20,
                        color: iconTint,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackgroundSlate50,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.zoneDescription,
                            style: const TextStyle(
                              fontSize: 10,
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

              // Power + Percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        item.powerKw.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackgroundSlate50,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        'kW',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariantSlate,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${item.percentage}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: barColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Glass Progress Slot
          Container(
            height: 7,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(999),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth =
                    constraints.maxWidth * (item.percentage / 100.0);
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 7,
                    width: barWidth,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              },
            ),
          ),

          // Optional Inline Eco-Optimization Tip
          if (item.ecoTip != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest.withValues(alpha: 0.40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.eco_rounded,
                    size: 14,
                    color: AppColors.ecoEmeraldDim,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.ecoTip!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariantSlate,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: item.isEcoTipApplied
                        ? null
                        : () => widget.onAction(
                              ApplyApplianceEcoTipAction(item.id),
                            ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: item.isEcoTipApplied
                            ? AppColors.ecoEmeraldBright.withValues(alpha: 0.50)
                            : AppColors.ecoEmeraldBright,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.isEcoTipApplied ? 'Shifted' : 'Apply',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003824),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Eco-Score & AI Recommendations (Nexus Intelligence).
  Widget _buildNexusIntelligenceSection() {
    final intelligence = widget.state.intelligence;
    final isEngaged = intelligence.isOptimizationApplied;

    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Internal Emerald Ambient Bloom
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.ecoEmeraldBright.withValues(alpha: 0.20),
                    AppColors.ecoEmeraldBright.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Brain icon + Nexus Intelligence + AI Active
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.ecoEmeraldBright
                                .withValues(alpha: 0.20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.psychology_rounded,
                            size: 22,
                            color: AppColors.ecoEmeraldBright,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nexus Intelligence',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onBackgroundSlate50,
                                ),
                              ),
                              Text(
                                'Real-time dynamic mesh optimization',
                                style: TextStyle(
                                  fontSize: 11,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.ecoEmeraldBright.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'AI Active',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ecoEmeraldBright,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Eco Score Badge & Visual Meter
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow.withValues(alpha: 0.80),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineGlass.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Circular Mini Radial Progress (Score 94/100)
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(52, 52),
                            painter: _MiniRadialProgressPainter(
                              progress: intelligence.ecoScore / 100.0,
                            ),
                          ),
                          const Icon(
                            Icons.energy_savings_leaf_rounded,
                            size: 20,
                            color: AppColors.ecoEmeraldBright,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${intelligence.ecoScore}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onBackgroundSlate50,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                '/ 100',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            intelligence.habitatStatus,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ecoEmeraldBright,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            intelligence.comparisonText,
                            style: const TextStyle(
                              fontSize: 10,
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
              const SizedBox(height: 12),

              // AI Suggestion & CTA Action Button
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineGlass.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: AppColors.electricCyan,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                intelligence.suggestionTitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onBackgroundSlate50,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                intelligence.suggestionDescription,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // CTA Button: Linear Gradient Full-Width Pill
                    GestureDetector(
                      onTap: isEngaged
                          ? null
                          : () => widget.onAction(
                                const ApplyAutoPowerOptimizationAction(),
                              ),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(
                            colors: isEngaged
                                ? const [
                                    AppColors.ecoEmeraldBright,
                                    AppColors.ecoEmerald,
                                  ]
                                : const [
                                    AppColors.electricCyan,
                                    Color(0xFF00A3FF),
                                  ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 19,
                              color: isEngaged
                                  ? const Color(0xFF003824)
                                  : AppColors.electricCyanDark,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isEngaged
                                    ? 'Optimization Engaged • 0.4 kWh Preserved'
                                    : 'Apply Auto-Power Optimization (Save 0.4 kWh)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isEngaged
                                      ? const Color(0xFF003824)
                                      : AppColors.electricCyanDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
  }
}

/// Mini Radial Progress Painter for Eco Score 94/100
class _MiniRadialProgressPainter extends CustomPainter {
  final double progress;

  _MiniRadialProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 4.0;
    final diameter = math.min(size.width, size.height) - strokeWidth;
    final radius = diameter / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = AppColors.surfaceContainerHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    // Active arc
    final activePaint = Paint()
      ..color = AppColors.ecoEmeraldBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, activePaint);
  }

  @override
  bool shouldRepaint(covariant _MiniRadialProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Ambient Light Backdrops for authentic cyber glassmorphism depth.
class _EnergyAmbientBackdrops extends StatelessWidget {
  const _EnergyAmbientBackdrops();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cyan Glow Top-Left
        Positioned(
          left: -40,
          top: -20,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.electricCyan.withValues(alpha: 0.20),
                  AppColors.electricCyan.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Emerald Glow Top-Right
        Positioned(
          right: -40,
          top: 140,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.ecoEmeraldBright.withValues(alpha: 0.18),
                  AppColors.ecoEmeraldBright.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Violet Glow Bottom-Left
        Positioned(
          left: 40,
          top: 520,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.violetContainerVibrant.withValues(alpha: 0.22),
                  AppColors.violetContainerVibrant.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
