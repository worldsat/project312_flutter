import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/settings_mock_data.dart';
import '../models/settings_models.dart';

/// Unidirectional State Controller for the Settings & Habitat Matrix Hub.
/// Replicates Android SettingsViewModel.kt.
class SettingsController extends ValueNotifier<SettingsUiState> {
  Timer? _diagnosticTimer;

  SettingsController([SettingsUiState? initialState])
      : super(initialState ?? SettingsMockData.createInitialState());

  @override
  void dispose() {
    _diagnosticTimer?.cancel();
    super.dispose();
  }

  void onAction(SettingsUiAction action) {
    switch (action) {
      case ToggleThreadMeshAction(:final enabled):
        _toggleThreadMesh(enabled);
      case ToggleLocalAiAction(:final enabled):
        _toggleLocalAi(enabled);
      case ToggleMatterBridgeAction(:final enabled):
        _toggleMatterBridge(enabled);
      case ToggleCloudSyncAction(:final enabled):
        _toggleCloudSync(enabled);
      case ToggleAutonomousEcoAction(:final enabled):
        _toggleAutonomousEco(enabled);
      case ToggleGeofenceAutoArmAction(:final enabled):
        _toggleGeofenceAutoArm(enabled);
      case ToggleMillimeterPresenceAction(:final enabled):
        _toggleMillimeterPresence(enabled);
      case SelectTempUnitAction(:final unit):
        _selectTempUnit(unit);
      case SetAqiThresholdAction(:final threshold):
        _setAqiThreshold(threshold);
      case ToggleCircadianLightingAction(:final enabled):
        _toggleCircadianLighting(enabled);
      case ToggleUltraGlassAction(:final enabled):
        _toggleUltraGlass(enabled);
      case ToggleTacticalHapticsAction(:final enabled):
        _toggleTacticalHaptics(enabled);
      case SelectThemeAccentAction(:final accent):
        _selectThemeAccent(accent);
      case ToggleAmbientBackdropsAction(:final enabled):
        _toggleAmbientBackdrops(enabled);
      case TriggerEmergencyLockdownAction():
        _triggerEmergencyLockdown();
      case RunSystemDiagnosticAction():
        _runSystemDiagnostic();
      case ClearSettingsFeedbackAction():
        _clearFeedback();
    }
  }

  void _toggleThreadMesh(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(threadMeshActive: enabled),
      userFeedback: enabled
          ? 'Thread Mesh 6LoWPAN protocol enabled'
          : 'Thread Mesh disabled (Fallback to Wi-Fi)',
    );
  }

  void _toggleLocalAi(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(localAiEdgeInference: enabled),
      userFeedback: enabled
          ? 'Edge Neural Processing enabled (Zero cloud latency)'
          : 'Cloud Inference enabled',
    );
  }

  void _toggleMatterBridge(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(matterBridgeSync: enabled),
      userFeedback: enabled
          ? 'Matter 1.3 Bridge connected to HomeKit & Google Home'
          : 'Matter Bridge offline',
    );
  }

  void _toggleCloudSync(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(cloudTelemetrySync: enabled),
      userFeedback: enabled
          ? 'Encrypted Cloud Snapshot Relay enabled'
          : 'Local-Only Enclave mode active',
    );
  }

  void _toggleAutonomousEco(bool enabled) {
    value = value.copyWith(
      automation: value.automation.copyWith(autonomousEcoTuning: enabled),
      userFeedback: enabled
          ? 'AI Autonomous Eco-Tuning engaged'
          : 'Eco-Tuning set to manual schedule',
    );
  }

  void _toggleGeofenceAutoArm(bool enabled) {
    value = value.copyWith(
      automation: value.automation.copyWith(geofenceAutoArm: enabled),
      userFeedback: enabled
          ? '500m Geofence Perimeter Auto-Arm enabled'
          : 'Geofence Auto-Arm disabled',
    );
  }

  void _toggleMillimeterPresence(bool enabled) {
    value = value.copyWith(
      automation: value.automation.copyWith(millimeterPresence: enabled),
      userFeedback: enabled
          ? '60GHz mmWave Radar micro-presence online'
          : 'mmWave Radar sleeping',
    );
  }

  void _selectTempUnit(TemperatureUnit unit) {
    value = value.copyWith(
      automation: value.automation.copyWith(tempUnit: unit),
      userFeedback:
          'Habitat Temperature Unit set to ${unit.label} (${unit.symbol})',
    );
  }

  void _setAqiThreshold(int threshold) {
    value = value.copyWith(
      automation: value.automation.copyWith(aqiAlertThreshold: threshold),
    );
  }

  void _toggleCircadianLighting(bool enabled) {
    value = value.copyWith(
      automation:
          value.automation.copyWith(circadianSpectrumLighting: enabled),
      userFeedback: enabled
          ? 'Circadian Kelvin Dynamic Spectrum active (2700K - 6500K)'
          : 'Static color temperature mode',
    );
  }

  void _toggleUltraGlass(bool enabled) {
    value = value.copyWith(
      display: value.display.copyWith(ultraGlassShaders: enabled),
      userFeedback: enabled
          ? 'Ultra Frosted Glassmorphism shaders active'
          : 'Performance glass mode active',
    );
  }

  void _toggleTacticalHaptics(bool enabled) {
    value = value.copyWith(
      display: value.display.copyWith(tacticalHaptics: enabled),
      userFeedback: enabled
          ? 'Tactile Haptic Feedback enabled'
          : 'Haptics disabled',
    );
  }

  void _selectThemeAccent(CyberThemeAccent accent) {
    value = value.copyWith(
      display: value.display.copyWith(selectedAccent: accent),
      userFeedback: 'Aura Accent Palette switched to ${accent.label}',
    );
  }

  void _toggleAmbientBackdrops(bool enabled) {
    value = value.copyWith(
      display: value.display.copyWith(ambientBackdropGlows: enabled),
      userFeedback: enabled
          ? 'Neon Backdrop Flare Glows enabled'
          : 'Minimal backdrop mode',
    );
  }

  void _triggerEmergencyLockdown() {
    final newLocked = !value.isEmergencyGridLocked;
    value = value.copyWith(
      isEmergencyGridLocked: newLocked,
      userFeedback: newLocked
          ? '⚠️ EMERGENCY GRID LOCKDOWN ENGAGED: Gas & High-Voltage relays isolated'
          : '✅ Grid Lockdown cleared: Nominal telemetry restored',
    );
  }

  void _runSystemDiagnostic() {
    value = value.copyWith(
      isDiagnosticRunning: true,
      userFeedback: 'Pinging 28 Habitat Mesh Nodes...',
    );

    _diagnosticTimer?.cancel();
    _diagnosticTimer = Timer(const Duration(milliseconds: 1200), () {
      value = value.copyWith(
        isDiagnosticRunning: false,
        userFeedback:
            'Self-Diagnostic Complete: 28/28 Nodes Online • Latency 1.6ms • Mesh 100% Nominal',
      );
    });
  }

  void _clearFeedback() {
    value = value.copyWith(clearFeedback: true);
  }
}
