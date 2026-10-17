import 'package:flutter/foundation.dart';
import '../data/overview_mock_data.dart';
import '../models/overview_models.dart';

/// OverviewController: UDF State controller managing OverviewState.
class OverviewController extends ValueNotifier<OverviewState> {
  OverviewController([OverviewState? initialState])
      : super(initialState ?? OverviewMockData.createInitialState());

  void onAction(OverviewAction action) {
    switch (action) {
      case ChangeModeAction(:final mode):
        value = value.copyWith(
          currentMode: mode,
          feedbackMessage: "System Mode shifted to: ${mode.label}",
        );

      case ToggleInstantActionAction(:final actionId):
        final updated = value.instantActions.map((item) {
          if (item.id == actionId) {
            return item.copyWith(isEnabled: !item.isEnabled);
          }
          return item;
        }).toList();

        final target = value.instantActions.firstWhere((e) => e.id == actionId);
        final stateText = !target.isEnabled ? "Engaged" : "Disengaged";

        value = value.copyWith(
          instantActions: updated,
          feedbackMessage: "${target.title}: $stateText",
        );

      case ToggleDevicePowerAction(:final deviceId):
        final updated = value.activeDevices.map((device) {
          if (device.id == deviceId) {
            return device.copyWith(isPoweredOn: !device.isPoweredOn);
          }
          return device;
        }).toList();

        final target = value.activeDevices.firstWhere((e) => e.id == deviceId);
        final stateText = !target.isPoweredOn ? "Powered On" : "Powered Down";

        value = value.copyWith(
          activeDevices: updated,
          feedbackMessage: "${target.name}: $stateText",
        );

      case SetDeviceLevelAction(:final deviceId, :final level):
        final updated = value.activeDevices.map((device) {
          if (device.id == deviceId) {
            return device.copyWith(level: level.clamp(0.0, 1.0));
          }
          return device;
        }).toList();

        value = value.copyWith(activeDevices: updated);

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
