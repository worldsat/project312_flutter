import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../models/energy_models.dart';

/// Unidirectional State Controller for Energy Analytics synced with Firestore.
/// Replicates the logic in Android's EnergyViewModel.kt.
class EnergyController extends ValueNotifier<EnergyUiState> {
  final FirestoreService? _firestoreService;
  StreamSubscription<List<ApplianceDrainItem>>? _appliancesSub;

  static const List<ApplianceDrainItem> _defaultAppliances = [
    ApplianceDrainItem(
      id: 'climate_control',
      name: 'Climate Control System',
      zoneDescription: 'HVAC Zone 01 & 02',
      powerKw: 1.19,
      percentage: 42,
      accent: ApplianceAccent.cyan,
      ecoTip: 'Eco Tip: Shifting +1°C saves 0.18 kW/hr',
      isEcoTipApplied: false,
    ),
    ApplianceDrainItem(
      id: 'water_heater',
      name: 'Quantum Water Heater',
      zoneDescription: 'Thermal storage: 91%',
      powerKw: 0.68,
      percentage: 24,
      accent: ApplianceAccent.purple,
      ecoTip: null,
      isEcoTipApplied: false,
    ),
    ApplianceDrainItem(
      id: 'ambient_lighting',
      name: 'Cyber Ambient Lighting',
      zoneDescription: 'Circadian sequence enabled',
      powerKw: 0.51,
      percentage: 18,
      accent: ApplianceAccent.cyanDim,
      ecoTip: null,
      isEcoTipApplied: false,
    ),
    ApplianceDrainItem(
      id: 'studio_workstations',
      name: 'Studio Workstations',
      zoneDescription: '3 Units • Sleep ready',
      powerKw: 0.46,
      percentage: 16,
      accent: ApplianceAccent.emerald,
      ecoTip: null,
      isEcoTipApplied: false,
    ),
  ];

  EnergyController([
    this._firestoreService,
    EnergyUiState? initialState,
  ]) : super(initialState ?? const EnergyUiState(appliances: _defaultAppliances)) {
    _initFirestore();
  }

  void _initFirestore() {
    if (_firestoreService == null) return;

    _appliancesSub = _firestoreService.streamAppliances().listen((cloudAppliances) {
      if (cloudAppliances.isNotEmpty) {
        value = value.copyWith(appliances: cloudAppliances);
      }
    });
  }

  @override
  void dispose() {
    _appliancesSub?.cancel();
    super.dispose();
  }

  void onAction(EnergyUiAction action) {
    switch (action) {
      case SelectPeriodAction(:final period):
        _selectPeriod(period);
      case ApplyApplianceEcoTipAction(:final applianceId):
        _applyApplianceEcoTip(applianceId);
      case ApplyAutoPowerOptimizationAction():
        _applyAutoPowerOptimization();
      case ClearFeedbackAction():
        _clearFeedback();
    }
  }

  void _selectPeriod(TimelinePeriod period) {
    final costDelta = switch (period) {
      TimelinePeriod.day => '-22% Cost Delta',
      TimelinePeriod.week => '-18.5% Cost Delta',
      TimelinePeriod.month => '-25.2% Cost Delta',
      TimelinePeriod.year => '-31.0% Cost Delta',
    };

    final dailyRunRate = switch (period) {
      TimelinePeriod.day => '-14.2% avg',
      TimelinePeriod.week => '-12.8% avg',
      TimelinePeriod.month => '-16.1% avg',
      TimelinePeriod.year => '-19.4% avg',
    };

    final updatedDynamics = value.consumptionDynamics.copyWith(
      selectedPeriod: period,
      costDelta: costDelta,
      dailyRunRate: dailyRunRate,
    );

    value = value.copyWith(
      consumptionDynamics: updatedDynamics,
      userFeedback: 'Timeline shifted to ${period.label} view',
    );
  }

  void _applyApplianceEcoTip(String applianceId) {
    final updatedAppliances = value.appliances.map((item) {
      if (item.id == applianceId) {
        return item.copyWith(isEcoTipApplied: true);
      }
      return item;
    }).toList();

    final targetAppliance =
        value.appliances.where((a) => a.id == applianceId).firstOrNull;

    value = value.copyWith(
      appliances: updatedAppliances,
      userFeedback:
          '${targetAppliance?.name ?? "Appliance"} Eco-Offset applied',
    );

    _firestoreService?.updateApplianceEcoTip(applianceId, true);
  }

  void _applyAutoPowerOptimization() {
    if (value.intelligence.isOptimizationApplied) return;

    final optimizedDemand = math.max(
      1.0,
      value.powerFlux.totalDemandKw - value.intelligence.optimizationSavingsKw,
    );
    final roundedDemand = (optimizedDemand * 100).round() / 100.0;

    final updatedFlux = value.powerFlux.copyWith(
      totalDemandKw: roundedDemand,
      selfSustainedPercent: 68,
      demandArcFraction: 0.60,
    );

    final updatedIntelligence = value.intelligence.copyWith(
      isOptimizationApplied: true,
      ecoScore: 98,
    );

    value = value.copyWith(
      powerFlux: updatedFlux,
      intelligence: updatedIntelligence,
      userFeedback: 'Optimization Engaged • 0.4 kWh Preserved',
    );
  }

  void _clearFeedback() {
    value = value.copyWith(clearFeedback: true);
  }
}
