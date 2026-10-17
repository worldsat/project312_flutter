import 'package:flutter/foundation.dart';

@immutable
class HabitatTelemetry {
  final String habitatName;
  final String sectorName;
  final String overallStatus;
  final double overallTemp;
  final double ambientTemp;
  final int humidityPercent;
  final int aqi;
  final String aqiStatus;
  final int activeSensorsCount;
  final bool scrubbersRunning;
  final double airPurityPercent;
  final double powerDemandKw;

  const HabitatTelemetry({
    this.habitatName = "Nexus Habitat",
    this.sectorName = "Living Sector Alpha",
    this.overallStatus = "Optimal",
    this.overallTemp = 24.0,
    this.ambientTemp = 22.5,
    this.humidityPercent = 48,
    this.aqi = 14,
    this.aqiStatus = "Optimal",
    this.activeSensorsCount = 18,
    this.scrubbersRunning = true,
    this.airPurityPercent = 99.4,
    this.powerDemandKw = 1.2,
  });

  HabitatTelemetry copyWith({
    String? habitatName,
    String? sectorName,
    String? overallStatus,
    double? overallTemp,
    double? ambientTemp,
    int? humidityPercent,
    int? aqi,
    String? aqiStatus,
    int? activeSensorsCount,
    bool? scrubbersRunning,
    double? airPurityPercent,
    double? powerDemandKw,
  }) {
    return HabitatTelemetry(
      habitatName: habitatName ?? this.habitatName,
      sectorName: sectorName ?? this.sectorName,
      overallStatus: overallStatus ?? this.overallStatus,
      overallTemp: overallTemp ?? this.overallTemp,
      ambientTemp: ambientTemp ?? this.ambientTemp,
      humidityPercent: humidityPercent ?? this.humidityPercent,
      aqi: aqi ?? this.aqi,
      aqiStatus: aqiStatus ?? this.aqiStatus,
      activeSensorsCount: activeSensorsCount ?? this.activeSensorsCount,
      scrubbersRunning: scrubbersRunning ?? this.scrubbersRunning,
      airPurityPercent: airPurityPercent ?? this.airPurityPercent,
      powerDemandKw: powerDemandKw ?? this.powerDemandKw,
    );
  }
}

enum SystemMode {
  home("Home"),
  away("Away"),
  nightProtocol("Night Protocol"),
  cinemaMode("Cinema Mode"),
  partyAura("Party Aura");

  final String label;
  const SystemMode(this.label);
}

enum QuickActionIcon {
  light,
  climate,
  lock,
  fan,
}

enum QuickActionAccent {
  cyan,
  purple,
  emerald,
}

@immutable
class QuickActionItem {
  final String id;
  final String title;
  final String subtitle;
  final QuickActionIcon icon;
  final QuickActionAccent accent;
  final bool isEnabled;

  const QuickActionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.isEnabled,
  });

  QuickActionItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    QuickActionIcon? icon,
    QuickActionAccent? accent,
    bool? isEnabled,
  }) {
    return QuickActionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      accent: accent ?? this.accent,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

@immutable
class EnergyVectorTelemetry {
  final double currentKwh;
  final int deltaPercent;
  final List<String> timeLabels;
  final List<double> splinePoints;

  const EnergyVectorTelemetry({
    this.currentKwh = 3.4,
    this.deltaPercent = -12,
    this.timeLabels = const ["06:00", "12:00", "18:00", "Now"],
    this.splinePoints = const [0.25, 0.38, 0.66, 0.48, 0.85],
  });

  EnergyVectorTelemetry copyWith({
    double? currentKwh,
    int? deltaPercent,
    List<String>? timeLabels,
    List<double>? splinePoints,
  }) {
    return EnergyVectorTelemetry(
      currentKwh: currentKwh ?? this.currentKwh,
      deltaPercent: deltaPercent ?? this.deltaPercent,
      timeLabels: timeLabels ?? this.timeLabels,
      splinePoints: splinePoints ?? this.splinePoints,
    );
  }
}

enum DeviceType {
  light,
  climate,
  audio,
  blinds,
}

enum DeviceAccent {
  cyan,
  cyanPurpleGradient,
  purple,
  emerald,
}

@immutable
class SmartDeviceItem {
  final String id;
  final String name;
  final String subtitle;
  final String badgeText;
  final double level; // 0.0 to 1.0
  final DeviceType deviceType;
  final DeviceAccent accent;
  final bool isPlayingAudio;
  final bool isPoweredOn;

  const SmartDeviceItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.badgeText,
    required this.level,
    required this.deviceType,
    required this.accent,
    this.isPlayingAudio = false,
    this.isPoweredOn = true,
  });

  SmartDeviceItem copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? badgeText,
    double? level,
    DeviceType? deviceType,
    DeviceAccent? accent,
    bool? isPlayingAudio,
    bool? isPoweredOn,
  }) {
    return SmartDeviceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      badgeText: badgeText ?? this.badgeText,
      level: level ?? this.level,
      deviceType: deviceType ?? this.deviceType,
      accent: accent ?? this.accent,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      isPoweredOn: isPoweredOn ?? this.isPoweredOn,
    );
  }
}

enum NavDestination {
  overview("Overview"),
  rooms("Rooms"),
  routines("Routines"),
  energy("Energy"),
  settings("Settings");

  final String label;
  const NavDestination(this.label);
}

@immutable
class OverviewState {
  final HabitatTelemetry telemetry;
  final SystemMode currentMode;
  final List<QuickActionItem> instantActions;
  final EnergyVectorTelemetry energyVector;
  final List<SmartDeviceItem> activeDevices;
  final NavDestination currentNavDestination;
  final bool hasUnreadNotifications;
  final String? feedbackMessage;

  const OverviewState({
    this.telemetry = const HabitatTelemetry(),
    this.currentMode = SystemMode.home,
    this.instantActions = const [],
    this.energyVector = const EnergyVectorTelemetry(),
    this.activeDevices = const [],
    this.currentNavDestination = NavDestination.overview,
    this.hasUnreadNotifications = true,
    this.feedbackMessage,
  });

  OverviewState copyWith({
    HabitatTelemetry? telemetry,
    SystemMode? currentMode,
    List<QuickActionItem>? instantActions,
    EnergyVectorTelemetry? energyVector,
    List<SmartDeviceItem>? activeDevices,
    NavDestination? currentNavDestination,
    bool? hasUnreadNotifications,
    String? feedbackMessage,
    bool clearFeedback = false,
  }) {
    return OverviewState(
      telemetry: telemetry ?? this.telemetry,
      currentMode: currentMode ?? this.currentMode,
      instantActions: instantActions ?? this.instantActions,
      energyVector: energyVector ?? this.energyVector,
      activeDevices: activeDevices ?? this.activeDevices,
      currentNavDestination: currentNavDestination ?? this.currentNavDestination,
      hasUnreadNotifications: hasUnreadNotifications ?? this.hasUnreadNotifications,
      feedbackMessage: clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
    );
  }
}

/// Sealed action hierarchy for Unidirectional Data Flow (UDF)
sealed class OverviewAction {
  const OverviewAction();
}

class ChangeModeAction extends OverviewAction {
  final SystemMode mode;
  const ChangeModeAction(this.mode);
}

class ToggleInstantActionAction extends OverviewAction {
  final String actionId;
  const ToggleInstantActionAction(this.actionId);
}

class ToggleDevicePowerAction extends OverviewAction {
  final String deviceId;
  const ToggleDevicePowerAction(this.deviceId);
}

class SetDeviceLevelAction extends OverviewAction {
  final String deviceId;
  final double level;
  const SetDeviceLevelAction(this.deviceId, this.level);
}

class SelectNavigationAction extends OverviewAction {
  final NavDestination destination;
  const SelectNavigationAction(this.destination);
}

class ToggleNotificationsAction extends OverviewAction {
  const ToggleNotificationsAction();
}

class OpenUserProfileAction extends OverviewAction {
  const OpenUserProfileAction();
}

class ClearFeedbackAction extends OverviewAction {
  const ClearFeedbackAction();
}
