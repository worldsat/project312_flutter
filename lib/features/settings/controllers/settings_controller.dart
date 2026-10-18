import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../models/settings_models.dart';

/// Unidirectional State Controller for the Settings & Habitat Matrix Hub synced with Firestore.
/// Replicates Android SettingsViewModel.kt.
class SettingsController extends ValueNotifier<SettingsUiState> {
  final FirestoreService? _firestoreService;
  StreamSubscription<Map<String, dynamic>>? _settingsSub;
  Timer? _diagnosticTimer;

  SettingsController([
    this._firestoreService,
    SettingsUiState? initialState,
  ]) : super(initialState ?? const SettingsUiState()) {
    _initFirestore();
  }

  void _initFirestore() {
    if (_firestoreService == null) return;

    _settingsSub = _firestoreService.streamSettings().listen((data) {
      if (data.isNotEmpty) {
        value = value.copyWith(
          connectivity: value.connectivity.copyWith(
            threadMeshActive: data['threadMeshActive'] as bool? ?? value.connectivity.threadMeshActive,
            localAiEdgeInference: data['localAiEdgeInference'] as bool? ?? value.connectivity.localAiEdgeInference,
            matterBridgeSync: data['matterBridgeSync'] as bool? ?? value.connectivity.matterBridgeSync,
            cloudTelemetrySync: data['cloudTelemetrySync'] as bool? ?? value.connectivity.cloudTelemetrySync,
          ),
          automation: value.automation.copyWith(
            autonomousEcoTuning: data['autonomousEcoTuning'] as bool? ?? value.automation.autonomousEcoTuning,
            geofenceAutoArm: data['geofenceAutoArm'] as bool? ?? value.automation.geofenceAutoArm,
            millimeterPresence: data['millimeterPresence'] as bool? ?? value.automation.millimeterPresence,
            circadianSpectrumLighting: data['circadianSpectrumLighting'] as bool? ?? value.automation.circadianSpectrumLighting,
          ),
          display: value.display.copyWith(
            ultraGlassShaders: data['ultraGlassShaders'] as bool? ?? value.display.ultraGlassShaders,
            tacticalHaptics: data['tacticalHaptics'] as bool? ?? value.display.tacticalHaptics,
            ambientBackdropGlows: data['ambientBackdropGlows'] as bool? ?? value.display.ambientBackdropGlows,
          ),
          isEmergencyGridLocked: data['isEmergencyGridLocked'] as bool? ?? value.isEmergencyGridLocked,
        );
      }
    });
  }

  @override
  void dispose() {
    _settingsSub?.cancel();
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
    _firestoreService?.updateSettingsField('threadMeshActive', enabled);
  }

  void _toggleLocalAi(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(localAiEdgeInference: enabled),
      userFeedback: enabled
          ? 'Edge Neural Processing enabled (Zero cloud latency)'
          : 'Cloud Inference enabled',
    );
    _firestoreService?.updateSettingsField('localAiEdgeInference', enabled);
  }

  void _toggleMatterBridge(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(matterBridgeSync: enabled),
      userFeedback: enabled
          ? 'Matter 1.3 Bridge connected to HomeKit & Google Home'
          : 'Matter Bridge offline',
    );
    _firestoreService?.updateSettingsField('matterBridgeSync', enabled);
  }

  void _toggleCloudSync(bool enabled) {
    value = value.copyWith(
      connectivity: value.connectivity.copyWith(cloudTelemetrySync: enabled),
      userFeedback: enabled
          ? 'Encrypted Cloud Snapshot Relay enabled'
          : 'Local-Only Enclave mode active',
    );
    _firestoreService?.updateSettingsField('cloudTelemetrySync', enabled);
  }

  void _toggleAutonomousEco(bool enabled) {
    value = value.copyWith(
      automation: value.automation.copyWith(autonomousEcoTuning: enabled),
      userFeedback: enabled
          ? 'AI Autonomous Eco-Tuning engaged'
          : 'Eco-Tuning set to manual schedule',
    );
    _firestoreService?.updateSettingsField('autonomousEcoTuning', enabled);
  }

  void _toggleGeofenceAutoArm(bool enabled) {
    value = value.copyWith(
      automation: value.automation.copyWith(geofenceAutoArm: enabled),
      userFeedback: enabled
          ? '500m Geofence Perimeter Auto-Arm enabled'
          : 'Geofence Auto-Arm disabled',
    );
    _firestoreService?.updateSettingsField('geofenceAutoArm', enabled);
  }

  void _toggleMillimeterPresence(bool enabled) {
    value = value.copyWith(
      automation: value.automation.copyWith(millimeterPresence: enabled),
      userFeedback: enabled
          ? '60GHz mmWave Radar micro-presence online'
          : 'mmWave Radar sleeping',
    );
    _firestoreService?.updateSettingsField('millimeterPresence', enabled);
  }

  void _selectTempUnit(TemperatureUnit unit) {
    value = value.copyWith(
      automation: value.automation.copyWith(tempUnit: unit),
      userFeedback:
          'Habitat Temperature Unit set to ${unit.label} (${unit.symbol})',
    );
    _firestoreService?.updateSettingsField('tempUnit', unit.name);
  }

  void _setAqiThreshold(int threshold) {
    value = value.copyWith(
      automation: value.automation.copyWith(aqiAlertThreshold: threshold),
    );
    _firestoreService?.updateSettingsField('aqiAlertThreshold', threshold);
  }

  void _toggleCircadianLighting(bool enabled) {
    value = value.copyWith(
      automation:
          value.automation.copyWith(circadianSpectrumLighting: enabled),
      userFeedback: enabled
          ? 'Circadian Kelvin Dynamic Spectrum active (2700K - 6500K)'
          : 'Static color temperature mode',
    );
    _firestoreService?.updateSettingsField('circadianSpectrumLighting', enabled);
  }

  void _toggleUltraGlass(bool enabled) {
    value = value.copyWith(
      display: value.display.copyWith(ultraGlassShaders: enabled),
      userFeedback: enabled
          ? 'Ultra Frosted Glassmorphism shaders active'
          : 'Performance glass mode active',
    );
    _firestoreService?.updateSettingsField('ultraGlassShaders', enabled);
  }

  void _toggleTacticalHaptics(bool enabled) {
    value = value.copyWith(
      display: value.display.copyWith(tacticalHaptics: enabled),
      userFeedback: enabled
          ? 'Tactile Haptic Feedback enabled'
          : 'Haptics disabled',
    );
    _firestoreService?.updateSettingsField('tacticalHaptics', enabled);
  }

  void _selectThemeAccent(CyberThemeAccent accent) {
    value = value.copyWith(
      display: value.display.copyWith(selectedAccent: accent),
      userFeedback: 'Aura Accent Palette switched to ${accent.label}',
    );
    _firestoreService?.updateSettingsField('selectedAccent', accent.name);
  }

  void _toggleAmbientBackdrops(bool enabled) {
    value = value.copyWith(
      display: value.display.copyWith(ambientBackdropGlows: enabled),
      userFeedback: enabled
          ? 'Neon Backdrop Flare Glows enabled'
          : 'Minimal backdrop mode',
    );
    _firestoreService?.updateSettingsField('ambientBackdropGlows', enabled);
  }

  void _triggerEmergencyLockdown() {
    final newLocked = !value.isEmergencyGridLocked;
    value = value.copyWith(
      isEmergencyGridLocked: newLocked,
      userFeedback: newLocked
          ? '⚠️ EMERGENCY GRID LOCKDOWN ENGAGED: Gas & High-Voltage relays isolated'
          : '✅ Grid Lockdown cleared: Nominal telemetry restored',
    );
    _firestoreService?.updateSettingsField('isEmergencyGridLocked', newLocked);
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
