import '../models/room_models.dart';

class RoomMockData {
  static const List<RoomItem> initialRooms = [
    RoomItem(
      id: "living_room",
      name: "Living Room",
      subtitle: "6 Devices Online",
      category: RoomCategory.livingRoom,
      isPoweredOn: true,
      tempC: "22°C",
      aqi: "98 AQI",
      lux: "450 lx",
      sliderLevel: 0.74,
      badgeText: null,
    ),
    RoomItem(
      id: "master_suite",
      name: "Master Cyber Suite",
      subtitle: "Sleep Sanctuary Active",
      category: RoomCategory.masterSuite,
      isPoweredOn: true,
      noiseDb: "24 dB (Silent)",
      deepRemTemp: "20.0°C",
      sliderLevel: 0.60,
      badgeText: null,
    ),
    RoomItem(
      id: "holodeck_studio",
      name: "Holodeck Studio",
      subtitle: "High Precision Simulator Zone",
      category: RoomCategory.holodeckStudio,
      isPoweredOn: true,
      spatialAudioLevel: 0.80,
      gridLoadKw: "3.4 kW",
      badgeText: "OVERCLOCK",
    ),
    RoomItem(
      id: "cyber_kitchen",
      name: "Cyber Kitchen",
      subtitle: "Safety Grid 100% Secure",
      category: RoomCategory.cyberKitchen,
      isPoweredOn: true,
      tempC: "-18°C / 4°C",
      badgeText: "Auto-Guarded",
    ),
  ];

  static RoomsUiState createInitialState() {
    return const RoomsUiState(
      selectedFilter: RoomFilter.all,
      rooms: initialRooms,
      totalZonesCount: 5,
      userFeedback: null,
    );
  }
}
