import 'package:flutter/material.dart';
import '../../../core/components/glass_container.dart';
import '../../../core/theme/app_colors.dart';
import '../models/room_models.dart';

/// RoomsZonesScreen: Flutter conversion of RoomsZonesScreen.kt.
/// Complete UI for the rooms_zones destination matching DESIGN.md.
class RoomsZonesScreen extends StatelessWidget {
  final RoomsUiState state;
  final ValueChanged<RoomsUiAction> onAction;

  const RoomsZonesScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Decorative Ambient Light Backdrops
        const _RoomsAmbientBackdrops(),

        // 2. Main Scrollable List
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Header & Configure Button
            _RoomsHeader(
              totalZonesCount: state.totalZonesCount,
              onConfigureClick: () => onAction(const ConfigureHabitatsAction()),
            ),
            const SizedBox(height: 18),

            // Horizontal Scrollable Zone Filter Pills
            _ZoneFilterStrip(
              selectedFilter: state.selectedFilter,
              onSelectFilter: (filter) => onAction(SelectFilterAction(filter)),
            ),
            const SizedBox(height: 18),

            // Room Cards List
            ...state.rooms.map((room) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: switch (room.category) {
                  RoomCategory.livingRoom => _LivingRoomCard(
                      room: room,
                      onToggle: () => onAction(ToggleRoomPowerAction(room.id)),
                    ),
                  RoomCategory.masterSuite => _MasterSuiteCard(
                      room: room,
                      onToggle: () => onAction(ToggleRoomPowerAction(room.id)),
                    ),
                  RoomCategory.holodeckStudio => _HolodeckStudioCard(
                      room: room,
                      onToggle: () => onAction(ToggleRoomPowerAction(room.id)),
                    ),
                  RoomCategory.cyberKitchen => _CyberKitchenCard(
                      room: room,
                    ),
                },
              );
            }),

            // Pair New Zone or Node Action Button
            _PairNewZoneButton(
              onClick: () => onAction(const PairNewNodeAction()),
            ),
          ],
        ),

        // 3. Floating In-Place Feedback Banner
        if (state.userFeedback != null)
          Positioned(
            left: 20,
            right: 20,
            bottom: 84,
            child: _FeedbackToast(
              message: state.userFeedback!,
              onDismiss: () => onAction(const ClearRoomsFeedbackAction()),
            ),
          ),
      ],
    );
  }
}

/// Ambient colored glow accents behind the rooms cockpit.
class _RoomsAmbientBackdrops extends StatelessWidget {
  const _RoomsAmbientBackdrops();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              left: -40,
              top: -20,
              width: 260,
              height: 260,
              child: Container(
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
            Positioned(
              right: -50,
              top: 320,
              width: 280,
              height: 280,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.violetContainerVibrant.withValues(alpha: 0.22),
                      AppColors.violetContainerVibrant.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Active Habitats Header.
class _RoomsHeader extends StatelessWidget {
  final int totalZonesCount;
  final VoidCallback onConfigureClick;

  const _RoomsHeader({
    required this.totalZonesCount,
    required this.onConfigureClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Active Habitats",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackgroundSlate50,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "$totalZonesCount Zones synched • Real-time environmental telemetrics",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariantSlate,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Configure Button
        InkWell(
          onTap: onConfigureClick,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.outlineGlass.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.tune_rounded,
                  color: AppColors.electricCyanFixedDim,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "CONFIGURE",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColors.electricCyanFixedDim,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal Scrollable Zone Filter Pills.
class _ZoneFilterStrip extends StatelessWidget {
  final RoomFilter selectedFilter;
  final ValueChanged<RoomFilter> onSelectFilter;

  const _ZoneFilterStrip({
    required this.selectedFilter,
    required this.onSelectFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: RoomFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = RoomFilter.values[index];
          final isSelected = filter == selectedFilter;

          final iconData = switch (filter.iconType) {
            RoomFilterIcon.dot => null,
            RoomFilterIcon.weekend => Icons.weekend_rounded,
            RoomFilterIcon.countertops => Icons.countertops_rounded,
            RoomFilterIcon.bed => Icons.bed_rounded,
            RoomFilterIcon.viewInAr => Icons.view_in_ar_rounded,
            RoomFilterIcon.deck => Icons.deck_rounded,
          };

          return GestureDetector(
            onTap: () => onSelectFilter(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.electricCyan.withValues(alpha: 0.22)
                    : AppColors.surfaceContainerHigh.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected
                      ? AppColors.electricCyan.withValues(alpha: 0.60)
                      : AppColors.outlineGlass.withValues(alpha: 0.10),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter.iconType == RoomFilterIcon.dot)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
                      ),
                    )
                  else if (iconData != null)
                    Icon(
                      iconData,
                      size: 16,
                      color: isSelected ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    filter.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Tactile Master Power Toggle Switch for Room Cards.
class _MasterPowerToggle extends StatelessWidget {
  final bool checked;
  final VoidCallback onToggle;
  final Gradient accentGradient;
  final IconData iconData;

  const _MasterPowerToggle({
    required this.checked,
    required this.onToggle,
    required this.accentGradient,
    this.iconData = Icons.bolt_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 54,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: checked
              ? accentGradient
              : const LinearGradient(
                  colors: [AppColors.surfaceContainerHighest, AppColors.surfaceContainerHighest],
                ),
          boxShadow: checked
              ? [
                  BoxShadow(
                    color: AppColors.electricCyan.withValues(alpha: 0.40),
                    blurRadius: 16,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.40),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              iconData,
              size: 13,
              color: checked ? AppColors.electricCyan : AppColors.onSurfaceVariantSlate,
            ),
          ),
        ),
      ),
    );
  }
}

/// Room Card 1: Living Room (Hero Card with visual backdrop scrim).
class _LivingRoomCard extends StatelessWidget {
  final RoomItem room;
  final VoidCallback onToggle;

  const _LivingRoomCard({
    required this.room,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: room.isPoweredOn ? 1.0 : 0.55,
      child: GlassContainer(
        cornerRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Weekend icon + Title + Master Power Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.electricCyan.withValues(alpha: 0.20),
                        ),
                        child: const Icon(
                          Icons.weekend_rounded,
                          color: AppColors.electricCyan,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onBackgroundSlate50,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.electricCyan,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    room.subtitle,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.onSurfaceVariantSlate,
                                        ),
                                    overflow: TextOverflow.ellipsis,
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
                const SizedBox(width: 8),

                // Master Power Toggle
                _MasterPowerToggle(
                  checked: room.isPoweredOn,
                  onToggle: onToggle,
                  accentGradient: const LinearGradient(
                    colors: [AppColors.electricCyan, AppColors.electricCyanFixedDim],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Live Telemetry Snapshot (3 Columns: Climate Optima, Clean Air, Diffused)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.60),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TelemetryItem(
                    icon: Icons.thermostat_rounded,
                    iconColor: AppColors.electricCyanFixedDim,
                    value: room.tempC,
                    label: "Climate Optima",
                  ),
                  _TelemetryItem(
                    icon: Icons.air_rounded,
                    iconColor: AppColors.ecoEmeraldDim,
                    value: room.aqi,
                    label: "Clean Air",
                  ),
                  _TelemetryItem(
                    icon: Icons.light_mode_rounded,
                    iconColor: AppColors.violetAurora,
                    value: room.lux,
                    label: "Diffused",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Ambient Illumination Control Slider Preview
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wb_twilight_rounded,
                            size: 14,
                            color: AppColors.electricCyan,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "Aurora Gradient Luster",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                      "${(room.sliderLevel * 100).toInt()}%",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.electricCyan,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: room.sliderLevel,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.electricCyan,
                            AppColors.ecoEmeraldBright,
                            AppColors.violetAurora,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TelemetryItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _TelemetryItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 3),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: AppColors.onSurfaceVariantSlate,
              ),
        ),
      ],
    );
  }
}

/// Room Card 2: Master Cyber Suite (Deep Indigo & Sleep Isolation).
class _MasterSuiteCard extends StatelessWidget {
  final RoomItem room;
  final VoidCallback onToggle;

  const _MasterSuiteCard({
    required this.room,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: room.isPoweredOn ? 1.0 : 0.55,
      child: GlassContainer(
        cornerRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Bedtime icon + Title + Sleep Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.violetContainer.withValues(alpha: 0.40),
                        ),
                        child: const Icon(
                          Icons.bedtime_rounded,
                          color: AppColors.violetAurora,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onBackgroundSlate50,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.violetFixedDim,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    room.subtitle,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.onSurfaceVariantSlate,
                                        ),
                                    overflow: TextOverflow.ellipsis,
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
                const SizedBox(width: 8),

                // Sleep Toggle
                _MasterPowerToggle(
                  checked: room.isPoweredOn,
                  onToggle: onToggle,
                  accentGradient: const LinearGradient(
                    colors: [AppColors.violetContainerVibrant, AppColors.violetAurora],
                  ),
                  iconData: Icons.nightlight_rounded,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2-Column Telemetry Badges (Sound Shield & Deep Rem Temp)
            Row(
              children: [
                // Sound Shield
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.40),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.violetContainer.withValues(alpha: 0.40),
                          ),
                          child: const Icon(Icons.graphic_eq_rounded, color: AppColors.violetAurora, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sound Shield",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontSize: 10,
                                      color: AppColors.onSurfaceVariantSlate,
                                    ),
                              ),
                              Text(
                                room.noiseDb,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onBackgroundSlate50,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Deep Rem Temp
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.40),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.electricCyan.withValues(alpha: 0.20),
                          ),
                          child: const Icon(Icons.ac_unit_rounded, color: AppColors.electricCyanFixedDim, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deep Rem Temp",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontSize: 10,
                                      color: AppColors.onSurfaceVariantSlate,
                                    ),
                              ),
                              Text(
                                room.deepRemTemp,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onBackgroundSlate50,
                                    ),
                                overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 12),

            // Sub-bar status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sensors_rounded, size: 15, color: AppColors.ecoEmeraldDim),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "Circadian rhythm cycle: Deep Sleep Mode",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                  "3 items synched",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.violetAurora,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Room Card 3: Holodeck Studio (Neon Violet & Hyper-Performance).
class _HolodeckStudioCard extends StatelessWidget {
  final RoomItem room;
  final VoidCallback onToggle;

  const _HolodeckStudioCard({
    required this.room,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: room.isPoweredOn ? 1.0 : 0.55,
      child: GlassContainer(
        cornerRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: ViewInAr icon + Title + OVERCLOCK tag + Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.violetAurora.withValues(alpha: 0.20),
                        ),
                        child: const Icon(
                          Icons.view_in_ar_rounded,
                          color: AppColors.violetAurora,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    room.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.onBackgroundSlate50,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.violetContainer.withValues(alpha: 0.50),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    "OVERCLOCK",
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                          color: AppColors.violetFixedDim,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              room.subtitle,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

                // Overclock Power Toggle
                _MasterPowerToggle(
                  checked: room.isPoweredOn,
                  onToggle: onToggle,
                  accentGradient: const LinearGradient(
                    colors: [AppColors.violetContainerVibrant, AppColors.violetAurora],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Acoustic & Lighting Matrix Bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.60),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.spatial_audio_rounded, size: 16, color: AppColors.electricCyan),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "Spatial Audio Cluster",
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onBackgroundSlate50,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${(room.spatialAudioLevel * 100).toInt()}%",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.electricCyan,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 7,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: room.spatialAudioLevel,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.violetContainerVibrant, AppColors.electricCyan],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Dynamic RGB Sync: Reactive Prism",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.ecoEmeraldDim,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "12 ms latency",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.ecoEmeraldDim,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Room Visual Snapshot Strip
            Container(
              height: 56,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.violetContainer.withValues(alpha: 0.70),
                    AppColors.surfaceContainerHigh.withValues(alpha: 0.60),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.memory_rounded, size: 16, color: AppColors.violetAurora),
                  const SizedBox(width: 6),
                  Text(
                    "${room.gridLoadKw} Grid Load",
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
      ),
    );
  }
}

/// Room Card 4: Cyber Kitchen (Safety, Climate & Telemetrics).
class _CyberKitchenCard extends StatelessWidget {
  final RoomItem room;

  const _CyberKitchenCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Kitchen icon + Title + Auto-Guarded badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.ecoEmeraldBright.withValues(alpha: 0.20),
                      ),
                      child: const Icon(
                        Icons.kitchen_rounded,
                        color: AppColors.ecoEmeraldDim,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onBackgroundSlate50,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.ecoEmeraldBright,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  room.subtitle,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.onSurfaceVariantSlate,
                                      ),
                                  overflow: TextOverflow.ellipsis,
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
              const SizedBox(width: 8),

              // Auto-Guarded Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.ecoEmeraldBright.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      size: 13,
                      color: AppColors.ecoEmeraldDim,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Auto-Guarded",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ecoEmeraldDim,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Appliance Sub-Grid (Smart Vault & Water Pure Osmosis)
          Row(
            children: [
              // Smart Vault
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh.withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Smart Vault",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                          ),
                          const Icon(Icons.ac_unit_rounded, size: 15, color: AppColors.electricCyan),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "-18°C / 4°C",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackgroundSlate50,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Compressor Eco",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: AppColors.ecoEmeraldDim,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Filtration
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh.withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filtration",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariantSlate,
                                ),
                          ),
                          const Icon(Icons.water_drop_rounded, size: 15, color: AppColors.electricCyan),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "99.4% Pure",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackgroundSlate50,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Cartridge optimal",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: AppColors.electricCyanFixedDim,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Inline Environmental Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.50),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.gas_meter_rounded, size: 14, color: AppColors.ecoEmeraldBright),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "VOC & Methane Sensors: Nominal",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                  "Smart Oven: Idle",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.onBackgroundSlate50,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pair New Zone or Node Glass Action Button.
class _PairNewZoneButton extends StatelessWidget {
  final VoidCallback onClick;

  const _PairNewZoneButton({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(16),
      onClick: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.electricCyan.withValues(alpha: 0.20),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.electricCyan,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Pair New Zone or Node",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackgroundSlate50,
                ),
          ),
        ],
      ),
    );
  }
}

/// In-place feedback toast.
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
