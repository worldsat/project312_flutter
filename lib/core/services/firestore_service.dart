import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/energy/models/energy_models.dart';
import '../../features/overview/models/overview_models.dart';
import '../../features/rooms/models/room_models.dart';
import '../../features/routines/models/routine_models.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _roomsCollection =>
      _firestore.collection('rooms');

  CollectionReference<Map<String, dynamic>> get _routinesCollection =>
      _firestore.collection('routines');

  CollectionReference<Map<String, dynamic>> get _devicesCollection =>
      _firestore.collection('devices');

  CollectionReference<Map<String, dynamic>> get _instantActionsCollection =>
      _firestore.collection('instant_actions');

  CollectionReference<Map<String, dynamic>> get _appliancesCollection =>
      _firestore.collection('appliances');

  DocumentReference<Map<String, dynamic>> get _telemetryDoc =>
      _firestore.collection('habitats').doc('nexus_core');

  DocumentReference<Map<String, dynamic>> get _settingsDoc =>
      _firestore.collection('settings').doc('nexus_settings');

  static T _matchEnum<T extends Enum>(List<T> values, String? raw, T fallback) {
    if (raw == null || raw.isEmpty) return fallback;
    final normalized = raw.replaceAll('_', '').toLowerCase();
    return values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => fallback,
    );
  }

  /// Seeds initial default data into Firestore if collections are empty.
  Future<void> seedInitialDataIfEmpty() async {
    try {
      final defaultRooms = [
        {
          'id': 'living_room',
          'name': 'Living Room',
          'subtitle': '6 Devices Online',
          'category': 'livingRoom',
          'isPoweredOn': true,
          'tempC': '22°C',
          'aqi': '98 AQI',
          'lux': '450 lx',
          'noiseDb': '24 dB (Silent)',
          'deepRemTemp': '20.0°C',
          'sliderLevel': 0.74,
          'spatialAudioLevel': 0.80,
          'gridLoadKw': '3.4 kW',
          'badgeText': null,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'master_suite',
          'name': 'Master Cyber Suite',
          'subtitle': 'Sleep Sanctuary Active',
          'category': 'masterSuite',
          'isPoweredOn': true,
          'tempC': '20°C',
          'aqi': '95 AQI',
          'lux': '300 lx',
          'noiseDb': '24 dB (Silent)',
          'deepRemTemp': '20.0°C',
          'sliderLevel': 0.60,
          'spatialAudioLevel': 0.70,
          'gridLoadKw': '1.8 kW',
          'badgeText': null,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'holodeck_studio',
          'name': 'Holodeck Studio',
          'subtitle': 'High Precision Simulator Zone',
          'category': 'holodeckStudio',
          'isPoweredOn': true,
          'tempC': '21°C',
          'aqi': '99 AQI',
          'lux': '500 lx',
          'noiseDb': '30 dB',
          'deepRemTemp': '21.0°C',
          'sliderLevel': 0.80,
          'spatialAudioLevel': 0.80,
          'gridLoadKw': '3.4 kW',
          'badgeText': 'OVERCLOCK',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'cyber_kitchen',
          'name': 'Cyber Kitchen',
          'subtitle': 'Safety Grid 100% Secure',
          'category': 'cyberKitchen',
          'isPoweredOn': true,
          'tempC': '-18°C / 4°C',
          'aqi': '98 AQI',
          'lux': '420 lx',
          'noiseDb': '22 dB',
          'deepRemTemp': '20.0°C',
          'sliderLevel': 0.70,
          'spatialAudioLevel': 0.50,
          'gridLoadKw': '2.1 kW',
          'badgeText': 'Auto-Guarded',
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final room in defaultRooms) {
        final id = room['id'] as String;
        _roomsCollection.doc(id).set(room, SetOptions(merge: true));
      }

      final defaultRoutines = [
        {
          'id': 'sunrise_awakening',
          'title': 'Sunrise Awakening',
          'triggerText': '06:30 AM Daily',
          'triggerIcon': 'alarm',
          'categoryIcon': 'sunrise',
          'categoryAccent': 'emerald',
          'isEnabled': true,
          'actions': [
            {'label': 'Gradual 10% → 100%', 'iconType': 'lightGradual', 'accent': 'emerald'},
            {'label': 'Blinds Open 75%', 'iconType': 'blinds', 'accent': 'cyan'},
            {'label': 'Morning Broadcast', 'iconType': 'broadcast', 'accent': 'purple'},
            {'label': 'Espresso Brew Start', 'iconType': 'coffee', 'accent': 'emerald'},
          ],
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'focus_matrix',
          'title': 'Focus Matrix',
          'triggerText': 'Trigger: NFC Desk Tag',
          'triggerIcon': 'nfc',
          'categoryIcon': 'matrix',
          'categoryAccent': 'cyan',
          'isEnabled': true,
          'actions': [
            {'label': 'Blue Light 450nm', 'iconType': 'blueLight', 'accent': 'cyan'},
            {'label': 'ANC Level 100%', 'iconType': 'anc', 'accent': 'purple'},
            {'label': 'DND Shield On', 'iconType': 'dnd', 'accent': 'crimson'},
            {'label': 'Airflow 22°C Silent', 'iconType': 'airflow', 'accent': 'emerald'},
          ],
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'sunset_transition',
          'title': 'Sunset Transition',
          'triggerText': 'Astronomical Twilight (18:45)',
          'triggerIcon': 'twilight',
          'categoryIcon': 'sunset',
          'categoryAccent': 'purple',
          'isEnabled': true,
          'actions': [
            {'label': 'Warm Glow 2200K', 'iconType': 'amberLight', 'accent': 'purple'},
            {'label': 'Perimeter Shield', 'iconType': 'perimeter', 'accent': 'emerald'},
            {'label': 'Eco Temp 21°C', 'iconType': 'thermostat', 'accent': 'cyan'},
            {'label': 'Privacy Shades Closed', 'iconType': 'shades', 'accent': 'purple'},
          ],
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final routine in defaultRoutines) {
        final id = routine['id'] as String;
        _routinesCollection.doc(id).set(routine, SetOptions(merge: true));
      }

      const initial = HabitatTelemetry();
      _telemetryDoc.set({
        'habitatName': initial.habitatName,
        'sectorName': initial.sectorName,
        'overallStatus': initial.overallStatus,
        'overallTemp': initial.overallTemp,
        'ambientTemp': initial.ambientTemp,
        'humidityPercent': initial.humidityPercent,
        'aqi': initial.aqi,
        'aqiStatus': initial.aqiStatus,
        'activeSensorsCount': initial.activeSensorsCount,
        'scrubbersRunning': initial.scrubbersRunning,
        'airPurityPercent': initial.airPurityPercent,
        'powerDemandKw': initial.powerDemandKw,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final defaultDevices = [
        {
          'id': 'cyberlight_pro',
          'name': 'CyberLight Pro',
          'subtitle': 'Living • Cyan Tint',
          'badgeText': '75%',
          'level': 0.75,
          'deviceType': 'light',
          'accent': 'cyan',
          'isPlayingAudio': false,
          'isPoweredOn': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'climate_pod',
          'name': 'Climate Pod',
          'subtitle': 'Target 21.5°C',
          'badgeText': 'Cooling',
          'level': 0.65,
          'deviceType': 'climate',
          'accent': 'cyanPurpleGradient',
          'isPlayingAudio': false,
          'isPoweredOn': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'soundwave_ultra',
          'name': 'SoundWave Ultra',
          'subtitle': 'Cyberpunk Lofi',
          'badgeText': 'Lofi',
          'level': 0.60,
          'deviceType': 'audio',
          'accent': 'purple',
          'isPlayingAudio': true,
          'isPoweredOn': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'smart_blinds',
          'name': 'Smart Blinds',
          'subtitle': 'East Facade Open',
          'badgeText': '80%',
          'level': 0.80,
          'deviceType': 'blinds',
          'accent': 'emerald',
          'isPlayingAudio': false,
          'isPoweredOn': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];
      for (final dev in defaultDevices) {
        final id = dev['id'] as String;
        _devicesCollection.doc(id).set(dev, SetOptions(merge: true));
      }

      final defaultActions = [
        {
          'id': 'ambient_glow',
          'title': 'Ambient Glow',
          'subtitle': 'Atmosphere 4000K',
          'icon': 'light',
          'accent': 'cyan',
          'isEnabled': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'climate_units',
          'title': 'All Climate Units',
          'subtitle': 'Preset 21.0°C',
          'icon': 'climate',
          'accent': 'cyan',
          'isEnabled': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'lock_doors',
          'title': 'Lock All Doors',
          'subtitle': 'Biometric Perimeter',
          'icon': 'lock',
          'accent': 'purple',
          'isEnabled': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'turbo_purify',
          'title': 'Turbo Purify',
          'subtitle': 'Standby Mode',
          'icon': 'fan',
          'accent': 'emerald',
          'isEnabled': false,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];
      for (final act in defaultActions) {
        final id = act['id'] as String;
        _instantActionsCollection.doc(id).set(act, SetOptions(merge: true));
      }

      final defaultAppliances = [
        {
          'id': 'climate_control',
          'name': 'Climate Control System',
          'zoneDescription': 'HVAC Zone 01 & 02',
          'powerKw': 1.19,
          'percentage': 42,
          'accent': 'cyan',
          'ecoTip': 'Eco Tip: Shifting +1°C saves 0.18 kW/hr',
          'isEcoTipApplied': false,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'water_heater',
          'name': 'Quantum Water Heater',
          'zoneDescription': 'Thermal storage: 91%',
          'powerKw': 0.68,
          'percentage': 24,
          'accent': 'purple',
          'ecoTip': null,
          'isEcoTipApplied': false,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'ambient_lighting',
          'name': 'Cyber Ambient Lighting',
          'zoneDescription': 'Circadian sequence enabled',
          'powerKw': 0.51,
          'percentage': 18,
          'accent': 'cyanDim',
          'ecoTip': null,
          'isEcoTipApplied': false,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'studio_workstations',
          'name': 'Studio Workstations',
          'zoneDescription': '3 Units • Sleep ready',
          'powerKw': 0.46,
          'percentage': 16,
          'accent': 'emerald',
          'ecoTip': null,
          'isEcoTipApplied': false,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];
      for (final app in defaultAppliances) {
        final id = app['id'] as String;
        _appliancesCollection.doc(id).set(app, SetOptions(merge: true));
      }
    } catch (e) {
      // ignore: avoid_print
      print('Firestore seed error: $e');
    }
  }

  /// Real-time stream of Rooms from Firestore
  Stream<List<RoomItem>> streamRooms() {
    return _roomsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <RoomItem>[];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final categoryStr = data['category'] as String? ?? '';
        final category = _matchEnum(RoomCategory.values, categoryStr, RoomCategory.livingRoom);

        return RoomItem(
          id: doc.id,
          name: data['name'] as String? ?? 'Zone',
          subtitle: data['subtitle'] as String? ?? '',
          category: category,
          isPoweredOn: data['isPoweredOn'] as bool? ?? true,
          tempC: data['tempC'] as String? ?? '22°C',
          aqi: data['aqi'] as String? ?? '98 AQI',
          lux: data['lux'] as String? ?? '450 lx',
          noiseDb: data['noiseDb'] as String? ?? '24 dB',
          deepRemTemp: data['deepRemTemp'] as String? ?? '20°C',
          sliderLevel: (data['sliderLevel'] as num?)?.toDouble() ?? 0.74,
          spatialAudioLevel: (data['spatialAudioLevel'] as num?)?.toDouble() ?? 0.8,
          gridLoadKw: data['gridLoadKw'] as String? ?? '0 kW',
          badgeText: data['badgeText'] as String?,
        );
      }).toList();
    });
  }

  Future<void> updateRoomPower(String roomId, bool isPoweredOn) async {
    try {
      await _roomsCollection.doc(roomId).update({
        'isPoweredOn': isPoweredOn,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> updateRoomSliderLevel(String roomId, double level) async {
    try {
      await _roomsCollection.doc(roomId).update({
        'sliderLevel': level.clamp(0.0, 1.0),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Real-time stream of Routines from Firestore
  Stream<List<ScheduledSequenceItem>> streamRoutines() {
    return _routinesCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <ScheduledSequenceItem>[];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final triggerIcon = _matchEnum(RoutineTriggerIcon.values, data['triggerIcon'] as String?, RoutineTriggerIcon.alarm);
        final categoryIcon = _matchEnum(RoutineCategoryIcon.values, data['categoryIcon'] as String?, RoutineCategoryIcon.sunrise);
        final categoryAccent = _matchEnum(RoutineActionAccent.values, data['categoryAccent'] as String?, RoutineActionAccent.emerald);

        final rawActions = data['actions'] as List<dynamic>? ?? [];
        final actions = rawActions.map((raw) {
          final aMap = raw as Map<String, dynamic>;
          return RoutineActionItem(
            label: aMap['label'] as String? ?? '',
            iconType: _matchEnum(RoutineActionIcon.values, aMap['iconType'] as String?, RoutineActionIcon.lightGradual),
            accent: _matchEnum(RoutineActionAccent.values, aMap['accent'] as String?, RoutineActionAccent.emerald),
          );
        }).toList();

        return ScheduledSequenceItem(
          id: doc.id,
          title: data['title'] as String? ?? 'Routine',
          triggerText: data['triggerText'] as String? ?? '',
          triggerIcon: triggerIcon,
          categoryIcon: categoryIcon,
          categoryAccent: categoryAccent,
          isEnabled: data['isEnabled'] as bool? ?? true,
          actions: actions,
        );
      }).toList();
    });
  }

  Future<void> updateRoutineEnabled(String routineId, bool isEnabled) async {
    try {
      await _routinesCollection.doc(routineId).update({
        'isEnabled': isEnabled,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Real-time stream of Habitat Telemetry
  Stream<HabitatTelemetry> streamTelemetry() {
    return _telemetryDoc.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return const HabitatTelemetry();
      }
      final data = snapshot.data()!;
      return HabitatTelemetry(
        habitatName: data['habitatName'] as String? ?? 'Nexus Habitat',
        sectorName: data['sectorName'] as String? ?? 'Living Sector Alpha',
        overallStatus: data['overallStatus'] as String? ?? 'Optimal',
        overallTemp: (data['overallTemp'] as num?)?.toDouble() ?? 24.0,
        ambientTemp: (data['ambientTemp'] as num?)?.toDouble() ?? 22.5,
        humidityPercent: (data['humidityPercent'] as num?)?.toInt() ?? 48,
        aqi: (data['aqi'] as num?)?.toInt() ?? 14,
        aqiStatus: data['aqiStatus'] as String? ?? 'Optimal',
        activeSensorsCount: (data['activeSensorsCount'] as num?)?.toInt() ?? 18,
        scrubbersRunning: data['scrubbersRunning'] as bool? ?? true,
        airPurityPercent: (data['airPurityPercent'] as num?)?.toDouble() ?? 99.4,
        powerDemandKw: (data['powerDemandKw'] as num?)?.toDouble() ?? 1.2,
      );
    });
  }

  /// Real-time stream of Smart Devices
  Stream<List<SmartDeviceItem>> streamDevices() {
    return _devicesCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return <SmartDeviceItem>[];
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return SmartDeviceItem(
          id: doc.id,
          name: data['name'] as String? ?? 'Device',
          subtitle: data['subtitle'] as String? ?? '',
          badgeText: data['badgeText'] as String? ?? '',
          level: (data['level'] as num?)?.toDouble() ?? 0.5,
          deviceType: _matchEnum(DeviceType.values, data['deviceType'] as String?, DeviceType.light),
          accent: _matchEnum(DeviceAccent.values, data['accent'] as String?, DeviceAccent.cyan),
          isPlayingAudio: data['isPlayingAudio'] as bool? ?? false,
          isPoweredOn: data['isPoweredOn'] as bool? ?? true,
        );
      }).toList();
    });
  }

  Future<void> updateDevicePower(String deviceId, bool isPoweredOn) async {
    try {
      await _devicesCollection.doc(deviceId).update({
        'isPoweredOn': isPoweredOn,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> updateDeviceLevel(String deviceId, double level, String badgeText) async {
    try {
      await _devicesCollection.doc(deviceId).update({
        'level': level.clamp(0.0, 1.0),
        'badgeText': badgeText,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Real-time stream of Instant Actions
  Stream<List<QuickActionItem>> streamInstantActions() {
    return _instantActionsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return <QuickActionItem>[];
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return QuickActionItem(
          id: doc.id,
          title: data['title'] as String? ?? 'Action',
          subtitle: data['subtitle'] as String? ?? '',
          icon: _matchEnum(QuickActionIcon.values, data['icon'] as String?, QuickActionIcon.light),
          accent: _matchEnum(QuickActionAccent.values, data['accent'] as String?, QuickActionAccent.cyan),
          isEnabled: data['isEnabled'] as bool? ?? false,
        );
      }).toList();
    });
  }

  Future<void> updateInstantAction(String actionId, bool isEnabled) async {
    try {
      await _instantActionsCollection.doc(actionId).update({
        'isEnabled': isEnabled,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Real-time stream of Appliances
  Stream<List<ApplianceDrainItem>> streamAppliances() {
    return _appliancesCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return <ApplianceDrainItem>[];
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ApplianceDrainItem(
          id: doc.id,
          name: data['name'] as String? ?? 'Appliance',
          zoneDescription: data['zoneDescription'] as String? ?? '',
          powerKw: (data['powerKw'] as num?)?.toDouble() ?? 0.5,
          percentage: (data['percentage'] as num?)?.toInt() ?? 20,
          accent: _matchEnum(ApplianceAccent.values, data['accent'] as String?, ApplianceAccent.cyan),
          ecoTip: data['ecoTip'] as String?,
          isEcoTipApplied: data['isEcoTipApplied'] as bool? ?? false,
        );
      }).toList();
    });
  }

  Future<void> updateApplianceEcoTip(String applianceId, bool isEcoTipApplied) async {
    try {
      await _appliancesCollection.doc(applianceId).update({
        'isEcoTipApplied': isEcoTipApplied,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Real-time stream of Settings
  Stream<Map<String, dynamic>> streamSettings() {
    return _settingsDoc.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return <String, dynamic>{};
      return snapshot.data()!;
    });
  }

  Future<void> updateSettingsField(String field, dynamic value) async {
    try {
      await _settingsDoc.update({
        field: value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}
