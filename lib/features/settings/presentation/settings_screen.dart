import 'package:flutter/material.dart';
import '../../../core/components/glass_container.dart';
import '../../../core/components/neon_pill_switch.dart';
import '../../../core/theme/app_colors.dart';
import '../../overview/models/overview_models.dart' show QuickActionAccent;
import '../models/settings_models.dart';

/// SettingsScreen: High-fidelity futuristic smart home configuration hub for Nexus Habitat.
/// Follows Obsidian Dark aesthetic, cyber glassmorphism, and neon telemetry design tokens.
class SettingsScreen extends StatefulWidget {
  final SettingsUiState state;
  final ValueChanged<SettingsUiAction> onAction;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isDiagnosticRunning && !_spinController.isAnimating) {
      _spinController.repeat();
    } else if (!widget.state.isDiagnosticRunning &&
        _spinController.isAnimating) {
      _spinController.stop();
      _spinController.reset();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeAccentColor = switch (widget.state.display.selectedAccent) {
      CyberThemeAccent.cyan => AppColors.electricCyan,
      CyberThemeAccent.violet => AppColors.violetAurora,
      CyberThemeAccent.emerald => AppColors.ecoEmerald,
    };

    return Container(
      color: AppColors.obsidianBackground,
      child: Stack(
        children: [
          // 1. Main Scrollable List
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Header
              _buildHeader(widget.state.coreInfo.firmwareVersion),
              const SizedBox(height: 16),

              // Hub Core Architecture Telemetry Card
              _buildHabitatCoreStatusCard(
                widget.state.coreInfo,
                activeAccentColor,
              ),
              const SizedBox(height: 16),

              // Section: Mesh & Protocol Connectivity
              _buildSectionTitle(
                title: 'MESH & PROTOCOL CONNECTIVITY',
                icon: Icons.hub_rounded,
                tint: AppColors.electricCyan,
              ),
              const SizedBox(height: 10),
              _buildConnectivityCard(),
              const SizedBox(height: 16),

              // Section: Automation & Intelligence
              _buildSectionTitle(
                title: 'AUTOMATION & INTELLIGENCE',
                icon: Icons.auto_awesome_rounded,
                tint: AppColors.violetAurora,
              ),
              const SizedBox(height: 10),
              _buildAutomationCard(),
              const SizedBox(height: 16),

              // Section: Interface & Cyber Aesthetics
              _buildSectionTitle(
                title: 'INTERFACE & CYBER AESTHETICS',
                icon: Icons.palette_rounded,
                tint: AppColors.ecoEmeraldDim,
              ),
              const SizedBox(height: 10),
              _buildInterfaceCard(),
              const SizedBox(height: 16),

              // Section: Grid Security & Diagnostics
              _buildSectionTitle(
                title: 'GRID SECURITY & DIAGNOSTICS',
                icon: Icons.shield_rounded,
                tint: AppColors.alertCrimson,
              ),
              const SizedBox(height: 10),
              _buildSecurityCard(),
              const SizedBox(height: 16),

              // System Version Watermark
              _buildWatermark(),
            ],
          ),

          // 3. Local Feedback Snackbar Overlay
          if (widget.state.userFeedback != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          widget.onAction(const ClearSettingsFeedbackAction()),
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

  Widget _buildHeader(String firmwareVersion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habitat Matrix',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackgroundSlate50,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Node 01 // Firmware $firmwareVersion • Mesh Secure',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariantSlate,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildHabitatCoreStatusCard(
    HabitatCoreInfo coreInfo,
    Color accentColor,
  ) {
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
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.memory_rounded,
                        size: 24,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  coreInfo.hubId,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onBackgroundSlate50,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.ecoEmeraldBright
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'ONLINE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.ecoEmeraldDim,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${coreInfo.meshNodesConnected} Nodes Synched • ${coreInfo.networkLatencyMs} ms Latency',
                            style: const TextStyle(
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

              // Security Tag
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      AppColors.surfaceContainerLowest.withValues(alpha: 0.70),
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
                      Icons.security_rounded,
                      size: 13,
                      color: AppColors.electricCyanFixedDim,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      coreInfo.securityLevel.encryption,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.electricCyanFixedDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3-Metric Snapshot Strip
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${coreInfo.hubHealthPercent}%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ecoEmeraldDim,
                      ),
                    ),
                    const Text(
                      'Hub Health',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariantSlate,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${coreInfo.networkLatencyMs} ms',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.electricCyan,
                      ),
                    ),
                    const Text(
                      'RF Latency',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariantSlate,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${coreInfo.uptimeDays}d',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.violetAurora,
                      ),
                    ),
                    const Text(
                      'Total Uptime',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariantSlate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectivityCard() {
    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSettingSwitchRow(
            icon: Icons.wifi_tethering_rounded,
            title: 'Thread Mesh Protocol (6LoWPAN)',
            subtitle: 'Multi-hop, low-latency, self-healing wireless grid',
            checked: widget.state.connectivity.threadMeshActive,
            accent: QuickActionAccent.cyan,
            onCheckedChange: (v) =>
                widget.onAction(ToggleThreadMeshAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.psychology_rounded,
            title: 'Local AI Neural Inference',
            subtitle: 'Edge coprocessor runs routines with 0ms cloud lag',
            checked: widget.state.connectivity.localAiEdgeInference,
            accent: QuickActionAccent.purple,
            onCheckedChange: (v) =>
                widget.onAction(ToggleLocalAiAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.device_hub_rounded,
            title: 'Universal Matter Bridge',
            subtitle: 'Matter 1.3 sync for Apple Home & Google Home',
            checked: widget.state.connectivity.matterBridgeSync,
            accent: QuickActionAccent.emerald,
            onCheckedChange: (v) =>
                widget.onAction(ToggleMatterBridgeAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.cloud_sync_rounded,
            title: 'Encrypted Cloud Snapshot Relay',
            subtitle: 'Zero-knowledge offsite backup of habitat state',
            checked: widget.state.connectivity.cloudTelemetrySync,
            accent: QuickActionAccent.cyan,
            onCheckedChange: (v) =>
                widget.onAction(ToggleCloudSyncAction(v)),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationCard() {
    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSettingSwitchRow(
            icon: Icons.motion_photos_auto_rounded,
            title: 'Autonomous Eco-Tuning',
            subtitle: 'AI dynamically modulates heat pumps and loads',
            checked: widget.state.automation.autonomousEcoTuning,
            accent: QuickActionAccent.emerald,
            onCheckedChange: (v) =>
                widget.onAction(ToggleAutonomousEcoAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.nearby_error_rounded,
            title: '500m Geofence Perimeter Auto-Arm',
            subtitle: 'Pre-cools habitat and locks nodes upon exit',
            checked: widget.state.automation.geofenceAutoArm,
            accent: QuickActionAccent.cyan,
            onCheckedChange: (v) =>
                widget.onAction(ToggleGeofenceAutoArmAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.radar_rounded,
            title: '60GHz mmWave Presence Radar',
            subtitle: 'Micro-motion breath sensing avoids false-offs',
            checked: widget.state.automation.millimeterPresence,
            accent: QuickActionAccent.purple,
            onCheckedChange: (v) =>
                widget.onAction(ToggleMillimeterPresenceAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.wb_sunny_rounded,
            title: 'Circadian Lighting Spectrum',
            subtitle: 'Auto daylight Kelvin sync (2700K - 6500K)',
            checked: widget.state.automation.circadianSpectrumLighting,
            accent: QuickActionAccent.cyan,
            onCheckedChange: (v) =>
                widget.onAction(ToggleCircadianLightingAction(v)),
          ),
          _buildSettingsDivider(),

          // Temperature Unit Selection
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
                        color: AppColors.electricCyan.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.thermostat_rounded,
                        size: 18,
                        color: AppColors.electricCyan,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thermal Telemetry Unit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackgroundSlate50,
                            ),
                          ),
                          Text(
                            'Current: ${widget.state.automation.tempUnit.label} (${widget.state.automation.tempUnit.symbol})',
                            style: const TextStyle(
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

              // Temperature Unit Toggle Pills
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.outlineGlass.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: TemperatureUnit.values.map((unit) {
                    final isSelected =
                        unit == widget.state.automation.tempUnit;
                    return GestureDetector(
                      onTap: () =>
                          widget.onAction(SelectTempUnitAction(unit)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.electricCyan.withValues(alpha: 0.25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          unit.symbol,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.electricCyan
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
          _buildSettingsDivider(),

          // AQI Alert Threshold Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.air_rounded,
                        size: 16,
                        color: AppColors.ecoEmeraldDim,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'AQI Alert Trigger',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackgroundSlate50,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '> ${widget.state.automation.aqiAlertThreshold} AQI',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ecoEmeraldBright,
                    ),
                  ),
                ],
              ),
              Slider(
                value: widget.state.automation.aqiAlertThreshold.toDouble(),
                min: 50,
                max: 200,
                divisions: 15,
                activeColor: AppColors.ecoEmerald,
                inactiveColor: AppColors.surfaceContainerHigh,
                thumbColor: AppColors.ecoEmeraldBright,
                onChanged: (val) =>
                    widget.onAction(SetAqiThresholdAction(val.toInt())),
              ),
              const Text(
                'Notification and HEPA filtration engage when indoor index exceeds threshold.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariantSlate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterfaceCard() {
    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingSwitchRow(
            icon: Icons.security_rounded,
            title: 'Ultra Frosted Glassmorphism',
            subtitle: 'Multi-layer obsidian blur & rim-lighting',
            checked: widget.state.display.ultraGlassShaders,
            accent: QuickActionAccent.cyan,
            onCheckedChange: (v) =>
                widget.onAction(ToggleUltraGlassAction(v)),
          ),
          _buildSettingsDivider(),
          _buildSettingSwitchRow(
            icon: Icons.vibration_rounded,
            title: 'Tactical Haptic Feedback',
            subtitle: 'Subtle vibration pulse on switch actuation',
            checked: widget.state.display.tacticalHaptics,
            accent: QuickActionAccent.purple,
            onCheckedChange: (v) =>
                widget.onAction(ToggleTacticalHapticsAction(v)),
          ),
          _buildSettingsDivider(),

          // Neon Aura Accent Theme Selector
          const Text(
            'Neon Aura Accent Theme',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onBackgroundSlate50,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: CyberThemeAccent.values.map((accent) {
              final isSelected =
                  accent == widget.state.display.selectedAccent;
              final accentColor = Color(accent.hexCode);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () =>
                        widget.onAction(SelectThemeAccentAction(accent)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentColor.withValues(alpha: 0.20)
                            : AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? accentColor
                              : AppColors.outlineGlass.withValues(alpha: 0.10),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              accent.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? accentColor
                                    : AppColors.onSurfaceVariantSlate,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return GlassContainer(
      cornerRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Emergency Grid Lockdown Action
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
                        color: AppColors.alertCrimson.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        size: 20,
                        color: AppColors.alertCrimson,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Grid Isolation',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.state.isEmergencyGridLocked
                                  ? AppColors.alertCrimson
                                  : AppColors.onBackgroundSlate50,
                            ),
                          ),
                          Text(
                            widget.state.isEmergencyGridLocked
                                ? 'GRID LOCKED: Gas valves and relays isolated'
                                : 'Instantly cut smart valves & high-voltage nodes',
                            style: TextStyle(
                              fontSize: 11,
                              color: widget.state.isEmergencyGridLocked
                                  ? AppColors.alertCrimson
                                      .withValues(alpha: 0.8)
                                  : AppColors.onSurfaceVariantSlate,
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

              GestureDetector(
                onTap: () => widget
                    .onAction(const TriggerEmergencyLockdownAction()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.state.isEmergencyGridLocked
                        ? AppColors.alertCrimson
                        : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: widget.state.isEmergencyGridLocked
                          ? AppColors.alertCrimson
                          : AppColors.outlineGlass.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.state.isEmergencyGridLocked ? 'DISARM' : 'ARM LOCK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: widget.state.isEmergencyGridLocked
                          ? Colors.white
                          : AppColors.alertCrimson,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildSettingsDivider(),

          // System Diagnostic Action
          GestureDetector(
            onTap: widget.state.isDiagnosticRunning
                ? null
                : () =>
                    widget.onAction(const RunSystemDiagnosticAction()),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _spinController,
                    child: const Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: AppColors.electricCyan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.state.isDiagnosticRunning
                              ? 'Running Diagnostic Scan...'
                              : 'Run Habitat Self-Diagnostic',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onBackgroundSlate50,
                          ),
                        ),
                        const Text(
                          'Ping 28 wireless nodes, verify enclave keys & radio RF power',
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
          ),
        ],
      ),
    );
  }

  Widget _buildWatermark() {
    return Column(
      children: [
        const Text(
          'NEXUS HABITAT // QUANTUM OS 4.8.2-Q',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Color(0x9994A3B8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Engineered with Flutter • Cyber Glassmorphic Shell',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.onSurfaceVariantSlate.withValues(alpha: 0.40),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
    required Color tint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: tint,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool checked,
    required QuickActionAccent accent,
    required ValueChanged<bool> onCheckedChange,
  }) {
    final iconBg = switch (accent) {
      QuickActionAccent.cyan =>
        AppColors.electricCyan.withValues(alpha: 0.15),
      QuickActionAccent.purple =>
        AppColors.violetContainer.withValues(alpha: 0.40),
      QuickActionAccent.emerald =>
        AppColors.ecoEmerald.withValues(alpha: 0.15),
    };

    final iconTint = switch (accent) {
      QuickActionAccent.cyan => AppColors.electricCyan,
      QuickActionAccent.purple => AppColors.violetAurora,
      QuickActionAccent.emerald => AppColors.ecoEmeraldDim,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconTint),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundSlate50,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
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

        NeonPillSwitch(
          checked: checked,
          onCheckedChange: onCheckedChange,
          accent: accent,
        ),
      ],
    );
  }

  Widget _buildSettingsDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: AppColors.outlineGlass.withValues(alpha: 0.08),
        height: 1,
        thickness: 1,
      ),
    );
  }
}

