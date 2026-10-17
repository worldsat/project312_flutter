import 'package:flutter/foundation.dart';

/// Thermal telemetry unit preference.
enum TemperatureUnit {
  celsius('°C', 'Celsius'),
  fahrenheit('°F', 'Fahrenheit');

  final String symbol;
  final String label;
  const TemperatureUnit(this.symbol, this.label);
}

/// Cyber theme color accent tokens for real-time personalization.
enum CyberThemeAccent {
  cyan('cyan', 'Electric Cyan', 0xFF00F2FE),
  violet('violet', 'Violet Aurora', 0xFF8B5CF6),
  emerald('emerald', 'Eco Emerald', 0xFF10B981);

  final String id;
  final String label;
  final int hexCode;
  const CyberThemeAccent(this.id, this.label, this.hexCode);
}

/// Mesh radio encryption security grade.
enum MeshSecurityLevel {
  quantum256('Quantum Mesh', 'AES-256-GCM'),
  edgeGuard('Edge Local', 'Hardware Enclave'),
  legacyCompat('Standard', 'TLS 1.3');

  final String label;
  final String encryption;
  const MeshSecurityLevel(this.label, this.encryption);
}

/// Hardware hub telemetry and cryptographic architecture info.
@immutable
class HabitatCoreInfo {
  final String hubId;
  final String firmwareVersion;
  final int meshNodesConnected;
  final int networkLatencyMs;
  final int hubHealthPercent;
  final int uptimeDays;
  final MeshSecurityLevel securityLevel;

  const HabitatCoreInfo({
    this.hubId = 'NEXUS-ALPHA-77',
    this.firmwareVersion = 'v4.8.2-Quantum',
    this.meshNodesConnected = 28,
    this.networkLatencyMs = 2,
    this.hubHealthPercent = 100,
    this.uptimeDays = 142,
    this.securityLevel = MeshSecurityLevel.quantum256,
  });

  HabitatCoreInfo copyWith({
    String? hubId,
    String? firmwareVersion,
    int? meshNodesConnected,
    int? networkLatencyMs,
    int? hubHealthPercent,
    int? uptimeDays,
    MeshSecurityLevel? securityLevel,
  }) {
    return HabitatCoreInfo(
      hubId: hubId ?? this.hubId,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      meshNodesConnected: meshNodesConnected ?? this.meshNodesConnected,
      networkLatencyMs: networkLatencyMs ?? this.networkLatencyMs,
      hubHealthPercent: hubHealthPercent ?? this.hubHealthPercent,
      uptimeDays: uptimeDays ?? this.uptimeDays,
      securityLevel: securityLevel ?? this.securityLevel,
    );
  }
}

/// Radio network mesh and local cloud sync settings.
@immutable
class ConnectivitySettings {
  final bool threadMeshActive;
  final bool localAiEdgeInference;
  final bool matterBridgeSync;
  final int zigbeeChannel;
  final bool cloudTelemetrySync;

  const ConnectivitySettings({
    this.threadMeshActive = true,
    this.localAiEdgeInference = true,
    this.matterBridgeSync = true,
    this.zigbeeChannel = 25,
    this.cloudTelemetrySync = false,
  });

  ConnectivitySettings copyWith({
    bool? threadMeshActive,
    bool? localAiEdgeInference,
    bool? matterBridgeSync,
    int? zigbeeChannel,
    bool? cloudTelemetrySync,
  }) {
    return ConnectivitySettings(
      threadMeshActive: threadMeshActive ?? this.threadMeshActive,
      localAiEdgeInference: localAiEdgeInference ?? this.localAiEdgeInference,
      matterBridgeSync: matterBridgeSync ?? this.matterBridgeSync,
      zigbeeChannel: zigbeeChannel ?? this.zigbeeChannel,
      cloudTelemetrySync: cloudTelemetrySync ?? this.cloudTelemetrySync,
    );
  }
}

/// Dynamic mesh automation preferences.
@immutable
class AutomationPreferences {
  final bool autonomousEcoTuning;
  final bool geofenceAutoArm;
  final bool millimeterPresence;
  final TemperatureUnit tempUnit;
  final int aqiAlertThreshold;
  final bool circadianSpectrumLighting;

  const AutomationPreferences({
    this.autonomousEcoTuning = true,
    this.geofenceAutoArm = true,
    this.millimeterPresence = true,
    this.tempUnit = TemperatureUnit.celsius,
    this.aqiAlertThreshold = 100,
    this.circadianSpectrumLighting = true,
  });

  AutomationPreferences copyWith({
    bool? autonomousEcoTuning,
    bool? geofenceAutoArm,
    bool? millimeterPresence,
    TemperatureUnit? tempUnit,
    int? aqiAlertThreshold,
    bool? circadianSpectrumLighting,
  }) {
    return AutomationPreferences(
      autonomousEcoTuning: autonomousEcoTuning ?? this.autonomousEcoTuning,
      geofenceAutoArm: geofenceAutoArm ?? this.geofenceAutoArm,
      millimeterPresence: millimeterPresence ?? this.millimeterPresence,
      tempUnit: tempUnit ?? this.tempUnit,
      aqiAlertThreshold: aqiAlertThreshold ?? this.aqiAlertThreshold,
      circadianSpectrumLighting:
          circadianSpectrumLighting ?? this.circadianSpectrumLighting,
    );
  }
}

/// Display and haptic interface configurations.
@immutable
class InterfacePreferences {
  final bool ultraGlassShaders;
  final bool tacticalHaptics;
  final CyberThemeAccent selectedAccent;
  final bool ambientBackdropGlows;

  const InterfacePreferences({
    this.ultraGlassShaders = true,
    this.tacticalHaptics = true,
    this.selectedAccent = CyberThemeAccent.cyan,
    this.ambientBackdropGlows = true,
  });

  InterfacePreferences copyWith({
    bool? ultraGlassShaders,
    bool? tacticalHaptics,
    CyberThemeAccent? selectedAccent,
    bool? ambientBackdropGlows,
  }) {
    return InterfacePreferences(
      ultraGlassShaders: ultraGlassShaders ?? this.ultraGlassShaders,
      tacticalHaptics: tacticalHaptics ?? this.tacticalHaptics,
      selectedAccent: selectedAccent ?? this.selectedAccent,
      ambientBackdropGlows: ambientBackdropGlows ?? this.ambientBackdropGlows,
    );
  }
}

/// Complete UI state for the Settings Hub.
@immutable
class SettingsUiState {
  final HabitatCoreInfo coreInfo;
  final ConnectivitySettings connectivity;
  final AutomationPreferences automation;
  final InterfacePreferences display;
  final bool isEmergencyGridLocked;
  final bool isDiagnosticRunning;
  final String? userFeedback;

  const SettingsUiState({
    this.coreInfo = const HabitatCoreInfo(),
    this.connectivity = const ConnectivitySettings(),
    this.automation = const AutomationPreferences(),
    this.display = const InterfacePreferences(),
    this.isEmergencyGridLocked = false,
    this.isDiagnosticRunning = false,
    this.userFeedback,
  });

  SettingsUiState copyWith({
    HabitatCoreInfo? coreInfo,
    ConnectivitySettings? connectivity,
    AutomationPreferences? automation,
    InterfacePreferences? display,
    bool? isEmergencyGridLocked,
    bool? isDiagnosticRunning,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return SettingsUiState(
      coreInfo: coreInfo ?? this.coreInfo,
      connectivity: connectivity ?? this.connectivity,
      automation: automation ?? this.automation,
      display: display ?? this.display,
      isEmergencyGridLocked:
          isEmergencyGridLocked ?? this.isEmergencyGridLocked,
      isDiagnosticRunning: isDiagnosticRunning ?? this.isDiagnosticRunning,
      userFeedback: clearFeedback ? null : (userFeedback ?? this.userFeedback),
    );
  }
}

/// Discrete UI Actions dispatched from SettingsScreen.
sealed class SettingsUiAction {
  const SettingsUiAction();
}

class ToggleThreadMeshAction extends SettingsUiAction {
  final bool enabled;
  const ToggleThreadMeshAction(this.enabled);
}

class ToggleLocalAiAction extends SettingsUiAction {
  final bool enabled;
  const ToggleLocalAiAction(this.enabled);
}

class ToggleMatterBridgeAction extends SettingsUiAction {
  final bool enabled;
  const ToggleMatterBridgeAction(this.enabled);
}

class ToggleCloudSyncAction extends SettingsUiAction {
  final bool enabled;
  const ToggleCloudSyncAction(this.enabled);
}

class ToggleAutonomousEcoAction extends SettingsUiAction {
  final bool enabled;
  const ToggleAutonomousEcoAction(this.enabled);
}

class ToggleGeofenceAutoArmAction extends SettingsUiAction {
  final bool enabled;
  const ToggleGeofenceAutoArmAction(this.enabled);
}

class ToggleMillimeterPresenceAction extends SettingsUiAction {
  final bool enabled;
  const ToggleMillimeterPresenceAction(this.enabled);
}

class SelectTempUnitAction extends SettingsUiAction {
  final TemperatureUnit unit;
  const SelectTempUnitAction(this.unit);
}

class SetAqiThresholdAction extends SettingsUiAction {
  final int threshold;
  const SetAqiThresholdAction(this.threshold);
}

class ToggleCircadianLightingAction extends SettingsUiAction {
  final bool enabled;
  const ToggleCircadianLightingAction(this.enabled);
}

class ToggleUltraGlassAction extends SettingsUiAction {
  final bool enabled;
  const ToggleUltraGlassAction(this.enabled);
}

class ToggleTacticalHapticsAction extends SettingsUiAction {
  final bool enabled;
  const ToggleTacticalHapticsAction(this.enabled);
}

class SelectThemeAccentAction extends SettingsUiAction {
  final CyberThemeAccent accent;
  const SelectThemeAccentAction(this.accent);
}

class ToggleAmbientBackdropsAction extends SettingsUiAction {
  final bool enabled;
  const ToggleAmbientBackdropsAction(this.enabled);
}

class TriggerEmergencyLockdownAction extends SettingsUiAction {
  const TriggerEmergencyLockdownAction();
}

class RunSystemDiagnosticAction extends SettingsUiAction {
  const RunSystemDiagnosticAction();
}

class ClearSettingsFeedbackAction extends SettingsUiAction {
  const ClearSettingsFeedbackAction();
}
