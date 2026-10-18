import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../models/overview_models.dart';

/// OverviewController: UDF State controller managing OverviewState synced with Firestore.
class OverviewController extends ValueNotifier<OverviewState> {
  final FirestoreService? _firestoreService;
  StreamSubscription<HabitatTelemetry>? _telemetrySub;
  StreamSubscription<List<QuickActionItem>>? _actionsSub;
  StreamSubscription<List<SmartDeviceItem>>? _devicesSub;

  static const List<QuickActionItem> _defaultInstantActions = [
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

  static const List<SmartDeviceItem> _defaultDevices = [
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

  OverviewController([
    this._firestoreService,
    OverviewState? initialState,
  ]) : super(
          initialState ??
              const OverviewState(
                instantActions: _defaultInstantActions,
                activeDevices: _defaultDevices,
              ),
        ) {
    _initFirestore();
  }

  void _initFirestore() {
    if (_firestoreService == null) return;

    _telemetrySub = _firestoreService.streamTelemetry().listen((telemetry) {
      value = value.copyWith(telemetry: telemetry);
    });

    _actionsSub = _firestoreService.streamInstantActions().listen((cloudActions) {
      if (cloudActions.isNotEmpty) {
        value = value.copyWith(instantActions: cloudActions);
      }
    });

    _devicesSub = _firestoreService.streamDevices().listen((cloudDevices) {
      if (cloudDevices.isNotEmpty) {
        value = value.copyWith(activeDevices: cloudDevices);
      }
    });
  }

  @override
  void dispose() {
    _telemetrySub?.cancel();
    _actionsSub?.cancel();
    _devicesSub?.cancel();
    super.dispose();
  }

  void onAction(OverviewAction action) {
    switch (action) {
      case ChangeModeAction(:final mode):
        value = value.copyWith(
          currentMode: mode,
          feedbackMessage: "System Mode shifted to: ${mode.label}",
        );

      case ToggleInstantActionAction(:final actionId):
        final target = value.instantActions.firstWhere((e) => e.id == actionId);
        final nextState = !target.isEnabled;
        final updated = value.instantActions.map((item) {
          if (item.id == actionId) {
            return item.copyWith(isEnabled: nextState);
          }
          return item;
        }).toList();

        final stateText = nextState ? "Engaged" : "Disengaged";

        value = value.copyWith(
          instantActions: updated,
          feedbackMessage: "${target.title}: $stateText",
        );
        _firestoreService?.updateInstantAction(actionId, nextState);

      case ToggleDevicePowerAction(:final deviceId):
        final target = value.activeDevices.firstWhere((e) => e.id == deviceId);
        final nextState = !target.isPoweredOn;
        final updated = value.activeDevices.map((device) {
          if (device.id == deviceId) {
            return device.copyWith(isPoweredOn: nextState);
          }
          return device;
        }).toList();

        final stateText = nextState ? "Powered On" : "Powered Down";

        value = value.copyWith(
          activeDevices: updated,
          feedbackMessage: "${target.name}: $stateText",
        );
        _firestoreService?.updateDevicePower(deviceId, nextState);

      case SetDeviceLevelAction(:final deviceId, :final level):
        final clamped = level.clamp(0.0, 1.0);
        final badge = switch (deviceId) {
          "climate_pod" => "Cooling",
          "soundwave_ultra" => "Lofi",
          _ => "${(clamped * 100).round()}%",
        };
        final updated = value.activeDevices.map((device) {
          if (device.id == deviceId) {
            return device.copyWith(level: clamped, badgeText: badge);
          }
          return device;
        }).toList();

        value = value.copyWith(activeDevices: updated);
        _firestoreService?.updateDeviceLevel(deviceId, clamped, badge);

      case SelectNavigationAction(:final destination):
        value = value.copyWith(
          currentNavDestination: destination,
          feedbackMessage: "Navigated to ${destination.label}",
        );

      case ToggleNotificationsAction():
        final newHasUnread = !value.hasUnreadNotifications;
        value = value.copyWith(
          hasUnreadNotifications: newHasUnread,
          feedbackMessage: newHasUnread
              ? "New habitat telemetry alert: Filter cartridge nominal"
              : "Notifications cleared",
        );

      case OpenUserProfileAction():
        value = value.copyWith(
          feedbackMessage: "Habitat Commander: Dr. Elena Vance (Quantum Node Alpha)",
        );

      case ClearFeedbackAction():
        value = value.copyWith(clearFeedback: true);
    }
  }
}
