import '../models/settings_models.dart';

/// Pre-seeded mock dataset for Habitat Matrix Configuration & Settings Hub.
/// Aligns 1:1 with Android SettingsMockData.kt.
abstract class SettingsMockData {
  static SettingsUiState createInitialState() => const SettingsUiState(
        coreInfo: HabitatCoreInfo(
          hubId: 'NEXUS-ALPHA-77',
          firmwareVersion: 'v4.8.2-Quantum',
          meshNodesConnected: 28,
          networkLatencyMs: 2,
          hubHealthPercent: 100,
          uptimeDays: 142,
          securityLevel: MeshSecurityLevel.quantum256,
        ),
        connectivity: ConnectivitySettings(
          threadMeshActive: true,
          localAiEdgeInference: true,
          matterBridgeSync: true,
          zigbeeChannel: 25,
          cloudTelemetrySync: false,
        ),
        automation: AutomationPreferences(
          autonomousEcoTuning: true,
          geofenceAutoArm: true,
          millimeterPresence: true,
          tempUnit: TemperatureUnit.celsius,
          aqiAlertThreshold: 100,
          circadianSpectrumLighting: true,
        ),
        display: InterfacePreferences(
          ultraGlassShaders: true,
          tacticalHaptics: true,
          selectedAccent: CyberThemeAccent.cyan,
          ambientBackdropGlows: true,
        ),
        isEmergencyGridLocked: false,
        isDiagnosticRunning: false,
        userFeedback: null,
      );
}
