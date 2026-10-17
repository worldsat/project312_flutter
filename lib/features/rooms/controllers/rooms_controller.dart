import 'package:flutter/foundation.dart';
import '../data/room_mock_data.dart';
import '../models/room_models.dart';

/// RoomsController: UDF State controller for Rooms & Zones.
class RoomsController extends ValueNotifier<RoomsUiState> {
  RoomsController([RoomsUiState? initialState])
      : super(initialState ?? RoomMockData.createInitialState());

  void onAction(RoomsUiAction action) {
    switch (action) {
      case SelectFilterAction(:final filter):
        final filteredRooms = switch (filter) {
          RoomFilter.all => RoomMockData.initialRooms,
          RoomFilter.livingRoom =>
            RoomMockData.initialRooms.where((r) => r.category == RoomCategory.livingRoom).toList(),
          RoomFilter.cyberKitchen =>
            RoomMockData.initialRooms.where((r) => r.category == RoomCategory.cyberKitchen).toList(),
          RoomFilter.masterSuite =>
            RoomMockData.initialRooms.where((r) => r.category == RoomCategory.masterSuite).toList(),
          RoomFilter.holodeckStudio =>
            RoomMockData.initialRooms.where((r) => r.category == RoomCategory.holodeckStudio).toList(),
          RoomFilter.patio => <RoomItem>[],
        };

        value = value.copyWith(
          selectedFilter: filter,
          rooms: filteredRooms,
          userFeedback: "Viewing ${filter.label}",
        );

      case ToggleRoomPowerAction(:final roomId):
        final updated = value.rooms.map((room) {
          if (room.id == roomId) {
            return room.copyWith(isPoweredOn: !room.isPoweredOn);
          }
          return room;
        }).toList();

        final target = value.rooms.firstWhere((r) => r.id == roomId);
        final stateText = !target.isPoweredOn ? "Online" : "Offline";

        value = value.copyWith(
          rooms: updated,
          userFeedback: "${target.name} Master Power $stateText",
        );

      case SetSliderLevelAction(:final roomId, :final level):
        final updated = value.rooms.map((room) {
          if (room.id == roomId) {
            return room.copyWith(sliderLevel: level.clamp(0.0, 1.0));
          }
          return room;
        }).toList();

        value = value.copyWith(rooms: updated);

      case ConfigureHabitatsAction():
        value = value.copyWith(
          userFeedback: "Zone Mesh Configurator: Opening Habitat Topology Matrix",
        );

      case PairNewNodeAction():
        value = value.copyWith(
          userFeedback: "Node Pairing Radar: Scanning Zigbee / Thread Mesh Nodes...",
        );

      case ClearRoomsFeedbackAction():
        value = value.copyWith(clearFeedback: true);
    }
  }
}
