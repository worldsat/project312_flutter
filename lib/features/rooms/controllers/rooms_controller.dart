import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../models/room_models.dart';

/// RoomsController: UDF State controller for Rooms & Zones.
class RoomsController extends ValueNotifier<RoomsUiState> {
  final FirestoreService? firestoreService;
  StreamSubscription<List<RoomItem>>? _roomsSubscription;
  List<RoomItem> _allRooms = [];

  RoomsController({RoomsUiState? initialState, this.firestoreService})
      : super(initialState ?? const RoomsUiState(rooms: [])) {
    if (firestoreService != null) {
      _roomsSubscription = firestoreService!.streamRooms().listen((firestoreRooms) {
        _allRooms = firestoreRooms;
        _applyFilter(value.selectedFilter);
      });
    }
  }

  @override
  void dispose() {
    _roomsSubscription?.cancel();
    super.dispose();
  }

  void _applyFilter(RoomFilter filter) {
    final filteredRooms = switch (filter) {
      RoomFilter.all => _allRooms,
      RoomFilter.livingRoom =>
        _allRooms.where((r) => r.category == RoomCategory.livingRoom).toList(),
      RoomFilter.cyberKitchen =>
        _allRooms.where((r) => r.category == RoomCategory.cyberKitchen).toList(),
      RoomFilter.masterSuite =>
        _allRooms.where((r) => r.category == RoomCategory.masterSuite).toList(),
      RoomFilter.holodeckStudio =>
        _allRooms.where((r) => r.category == RoomCategory.holodeckStudio).toList(),
      RoomFilter.patio => <RoomItem>[],
    };

    value = value.copyWith(
      selectedFilter: filter,
      rooms: filteredRooms,
      totalZonesCount: _allRooms.length,
    );
  }

  void onAction(RoomsUiAction action) {
    switch (action) {
      case SelectFilterAction(:final filter):
        _applyFilter(filter);
        value = value.copyWith(userFeedback: "Viewing ${filter.label}");

      case ToggleRoomPowerAction(:final roomId):
        final target = value.rooms.firstWhere((r) => r.id == roomId);
        final nextPowerState = !target.isPoweredOn;
        final updated = value.rooms.map((room) {
          if (room.id == roomId) {
            return room.copyWith(isPoweredOn: nextPowerState);
          }
          return room;
        }).toList();

        final stateText = nextPowerState ? "Online" : "Offline";

        value = value.copyWith(
          rooms: updated,
          userFeedback: "${target.name} Master Power $stateText",
        );
        firestoreService?.updateRoomPower(roomId, nextPowerState);

      case SetSliderLevelAction(:final roomId, :final level):
        final clampedLevel = level.clamp(0.0, 1.0);
        final updated = value.rooms.map((room) {
          if (room.id == roomId) {
            return room.copyWith(sliderLevel: clampedLevel);
          }
          return room;
        }).toList();

        value = value.copyWith(rooms: updated);
        firestoreService?.updateRoomSliderLevel(roomId, clampedLevel);

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
