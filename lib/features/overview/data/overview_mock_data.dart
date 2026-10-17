import '../models/overview_models.dart';

class OverviewMockData {
  static const HabitatTelemetry initialTelemetry = HabitatTelemetry(
    habitatName: "Nexus Habitat",
    sectorName: "Living Sector Alpha",
    overallStatus: "Optimal",
    overallTemp: 24.0,
    ambientTemp: 22.5,
    humidityPercent: 48,
    aqi: 14,
    aqiStatus: "Optimal",
    activeSensorsCount: 18,
    scrubbersRunning: true,
    airPurityPercent: 99.4,
    powerDemandKw: 1.2,
  );

  static const List<QuickActionItem> initialInstantActions = [
    QuickActionItem(
      id: "ambient_glow",
      title: "Ambient Glow",
      subtitle: "Atmosphere 4000K",
      icon: QuickActionIcon.light,
      accent: QuickActionAccent.cyan,
      isEnabled: true,
    ),
    QuickActionItem(
      id: "climate_units",
      title: "All Climate Units",
      subtitle: "Preset 21.0°C",
      icon: QuickActionIcon.climate,
      accent: QuickActionAccent.cyan,
      isEnabled: true,
    ),
    QuickActionItem(
      id: "lock_doors",
      title: "Lock All Doors",
      subtitle: "Biometric Perimeter",
      icon: QuickActionIcon.lock,
      accent: QuickActionAccent.purple,
      isEnabled: true,
    ),
    QuickActionItem(
      id: "turbo_purify",
      title: "Turbo Purify",
      subtitle: "Standby Mode",
      icon: QuickActionIcon.fan,
      accent: QuickActionAccent.emerald,
      isEnabled: false,
    ),
  ];

  static const EnergyVectorTelemetry initialEnergyVector = EnergyVectorTelemetry(
    currentKwh: 3.4,
    deltaPercent: -12,
    timeLabels: ["06:00", "12:00", "18:00", "Now"],
    splinePoints: [0.25, 0.38, 0.66, 0.48, 0.85],
  );

  static const List<SmartDeviceItem> initialDevices = [
    SmartDeviceItem(
      id: "cyberlight_pro",
      name: "CyberLight Pro",
      subtitle: "Living • Cyan Tint",
      badgeText: "75%",
      level: 0.75,
      deviceType: DeviceType.light,
      accent: DeviceAccent.cyan,
      isPoweredOn: true,
    ),
    SmartDeviceItem(
      id: "climate_pod",
      name: "Climate Pod",
      subtitle: "Target 21.5°C",
      badgeText: "Cooling",
      level: 0.65,
      deviceType: DeviceType.climate,
      accent: DeviceAccent.cyanPurpleGradient,
      isPoweredOn: true,
    ),
    SmartDeviceItem(
      id: "soundwave_ultra",
      name: "SoundWave Ultra",
      subtitle: "Cyberpunk Lofi",
      badgeText: "Lofi",
      level: 0.60,
      deviceType: DeviceType.audio,
      accent: DeviceAccent.purple,
      isPlayingAudio: true,
      isPoweredOn: true,
    ),
    SmartDeviceItem(
      id: "smart_blinds",
      name: "Smart Blinds",
      subtitle: "East Facade Open",
      badgeText: "80%",
      level: 0.80,
      deviceType: DeviceType.blinds,
      accent: DeviceAccent.emerald,
      isPoweredOn: true,
    ),
  ];

  static OverviewState createInitialState() {
    return const OverviewState(
      telemetry: initialTelemetry,
      currentMode: SystemMode.home,
      instantActions: initialInstantActions,
      energyVector: initialEnergyVector,
      activeDevices: initialDevices,
      currentNavDestination: NavDestination.overview,
      hasUnreadNotifications: true,
      feedbackMessage: null,
    );
  }
}
