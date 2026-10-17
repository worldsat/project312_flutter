import 'package:flutter/foundation.dart';

enum RoomFilterIcon {
  dot,
  weekend,
  countertops,
  bed,
  viewInAr,
  deck,
}

enum RoomFilter {
  all("All Zones (5)", RoomFilterIcon.dot),
  livingRoom("Living Room", RoomFilterIcon.weekend),
  cyberKitchen("Cyber Kitchen", RoomFilterIcon.countertops),
  masterSuite("Master Suite", RoomFilterIcon.bed),
  holodeckStudio("Holodeck / Studio", RoomFilterIcon.viewInAr),
  patio("Patio", RoomFilterIcon.deck);

  final String label;
  final RoomFilterIcon iconType;
  const RoomFilter(this.label, this.iconType);
}

enum RoomCategory {
  livingRoom,
  masterSuite,
  holodeckStudio,
  cyberKitchen,
}

@immutable
class RoomItem {
  final String id;
  final String name;
  final String subtitle;
  final RoomCategory category;
  final bool isPoweredOn;
  final String tempC;
  final String aqi;
  final String lux;
  final String noiseDb;
  final String deepRemTemp;
  final double sliderLevel;
  final double spatialAudioLevel;
  final String gridLoadKw;
  final String? badgeText;

  const RoomItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    this.isPoweredOn = true,
    this.tempC = "22°C",
    this.aqi = "98 AQI",
    this.lux = "450 lx",
    this.noiseDb = "24 dB (Silent)",
    this.deepRemTemp = "20.0°C",
    this.sliderLevel = 0.74,
    this.spatialAudioLevel = 0.80,
    this.gridLoadKw = "3.4 kW",
    this.badgeText,
  });

  RoomItem copyWith({
    String? id,
    String? name,
    String? subtitle,
    RoomCategory? category,
    bool? isPoweredOn,
    String? tempC,
    String? aqi,
    String? lux,
    String? noiseDb,
    String? deepRemTemp,
    double? sliderLevel,
    double? spatialAudioLevel,
    String? gridLoadKw,
    String? badgeText,
  }) {
    return RoomItem(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      isPoweredOn: isPoweredOn ?? this.isPoweredOn,
      tempC: tempC ?? this.tempC,
      aqi: aqi ?? this.aqi,
      lux: lux ?? this.lux,
      noiseDb: noiseDb ?? this.noiseDb,
      deepRemTemp: deepRemTemp ?? this.deepRemTemp,
      sliderLevel: sliderLevel ?? this.sliderLevel,
      spatialAudioLevel: spatialAudioLevel ?? this.spatialAudioLevel,
      gridLoadKw: gridLoadKw ?? this.gridLoadKw,
      badgeText: badgeText ?? this.badgeText,
    );
  }
}

@immutable
class RoomsUiState {
  final RoomFilter selectedFilter;
  final List<RoomItem> rooms;
  final int totalZonesCount;
  final String? userFeedback;

  const RoomsUiState({
    this.selectedFilter = RoomFilter.all,
    this.rooms = const [],
    this.totalZonesCount = 5,
    this.userFeedback,
  });

  RoomsUiState copyWith({
    RoomFilter? selectedFilter,
    List<RoomItem>? rooms,
    int? totalZonesCount,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return RoomsUiState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      rooms: rooms ?? this.rooms,
      totalZonesCount: totalZonesCount ?? this.totalZonesCount,
      userFeedback: clearFeedback ? null : (userFeedback ?? this.userFeedback),
    );
  }
}

sealed class RoomsUiAction {
  const RoomsUiAction();
}

class SelectFilterAction extends RoomsUiAction {
  final RoomFilter filter;
  const SelectFilterAction(this.filter);
}

class ToggleRoomPowerAction extends RoomsUiAction {
  final String roomId;
  const ToggleRoomPowerAction(this.roomId);
}

class SetSliderLevelAction extends RoomsUiAction {
  final String roomId;
  final double level;
  const SetSliderLevelAction(this.roomId, this.level);
}

class ConfigureHabitatsAction extends RoomsUiAction {
  const ConfigureHabitatsAction();
}

class PairNewNodeAction extends RoomsUiAction {
  const PairNewNodeAction();
}

class ClearRoomsFeedbackAction extends RoomsUiAction {
  const ClearRoomsFeedbackAction();
}
