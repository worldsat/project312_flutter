import 'package:flutter/foundation.dart';

/// Telemetry metrics for the real-time Power Flux Hero Gauge.
@immutable
class PowerFluxTelemetry {
  final double totalDemandKw;
  final int selfSustainedPercent;
  final double solarInflowKw;
  final int activePanelsCount;
  final double gridPullKw;
  final String gridTierRate;
  final String lastUpdatedText;
  final double demandArcFraction;
  final double ghostArcFraction;

  const PowerFluxTelemetry({
    this.totalDemandKw = 2.84,
    this.selfSustainedPercent = 58,
    this.solarInflowKw = 1.65,
    this.activePanelsCount = 12,
    this.gridPullKw = 1.19,
    this.gridTierRate = 'Off-peak tier: \$0.11',
    this.lastUpdatedText = 'Update: Just now',
    this.demandArcFraction = 0.71,
    this.ghostArcFraction = 0.44,
  });

  PowerFluxTelemetry copyWith({
    double? totalDemandKw,
    int? selfSustainedPercent,
    double? solarInflowKw,
    int? activePanelsCount,
    double? gridPullKw,
    String? gridTierRate,
    String? lastUpdatedText,
    double? demandArcFraction,
    double? ghostArcFraction,
  }) {
    return PowerFluxTelemetry(
      totalDemandKw: totalDemandKw ?? this.totalDemandKw,
      selfSustainedPercent: selfSustainedPercent ?? this.selfSustainedPercent,
      solarInflowKw: solarInflowKw ?? this.solarInflowKw,
      activePanelsCount: activePanelsCount ?? this.activePanelsCount,
      gridPullKw: gridPullKw ?? this.gridPullKw,
      gridTierRate: gridTierRate ?? this.gridTierRate,
      lastUpdatedText: lastUpdatedText ?? this.lastUpdatedText,
      demandArcFraction: demandArcFraction ?? this.demandArcFraction,
      ghostArcFraction: ghostArcFraction ?? this.ghostArcFraction,
    );
  }
}

/// Timeline range filter periods for consumption graphs.
enum TimelinePeriod {
  day('Day'),
  week('Week'),
  month('Month'),
  year('Year');

  final String label;
  const TimelinePeriod(this.label);
}

/// Dynamics dataset for the spline graph and summary rate cards.
@immutable
class ConsumptionDynamicsData {
  final TimelinePeriod selectedPeriod;
  final String offPeakWindow;
  final String costDelta;
  final String peakLabel;
  final String dailyRunRate;
  final String cycleSavings;
  final List<String> timeLabels;

  const ConsumptionDynamicsData({
    this.selectedPeriod = TimelinePeriod.day,
    this.offPeakWindow = 'Off-Peak Window: 23:00 - 06:00',
    this.costDelta = '-22% Cost Delta',
    this.peakLabel = 'Peak: 3.4 kW (14:30)',
    this.dailyRunRate = '-14.2% avg',
    this.cycleSavings = '\$48.70 saved',
    this.timeLabels = const ['00:00', '06:00', '12:00', '18:00', '23:59'],
  });

  ConsumptionDynamicsData copyWith({
    TimelinePeriod? selectedPeriod,
    String? offPeakWindow,
    String? costDelta,
    String? peakLabel,
    String? dailyRunRate,
    String? cycleSavings,
    List<String>? timeLabels,
  }) {
    return ConsumptionDynamicsData(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      offPeakWindow: offPeakWindow ?? this.offPeakWindow,
      costDelta: costDelta ?? this.costDelta,
      peakLabel: peakLabel ?? this.peakLabel,
      dailyRunRate: dailyRunRate ?? this.dailyRunRate,
      cycleSavings: cycleSavings ?? this.cycleSavings,
      timeLabels: timeLabels ?? this.timeLabels,
    );
  }
}

/// Aesthetic color accent coding for appliance consumption rows.
enum ApplianceAccent {
  cyan,
  purple,
  cyanDim,
  emerald,
}

/// Breakdown data for individual monitored high-draw appliances.
@immutable
class ApplianceDrainItem {
  final String id;
  final String name;
  final String zoneDescription;
  final double powerKw;
  final int percentage;
  final ApplianceAccent accent;
  final String? ecoTip;
  final bool isEcoTipApplied;

  const ApplianceDrainItem({
    required this.id,
    required this.name,
    required this.zoneDescription,
    required this.powerKw,
    required this.percentage,
    required this.accent,
    this.ecoTip,
    this.isEcoTipApplied = false,
  });

  ApplianceDrainItem copyWith({
    String? id,
    String? name,
    String? zoneDescription,
    double? powerKw,
    int? percentage,
    ApplianceAccent? accent,
    String? ecoTip,
    bool? isEcoTipApplied,
  }) {
    return ApplianceDrainItem(
      id: id ?? this.id,
      name: name ?? this.name,
      zoneDescription: zoneDescription ?? this.zoneDescription,
      powerKw: powerKw ?? this.powerKw,
      percentage: percentage ?? this.percentage,
      accent: accent ?? this.accent,
      ecoTip: ecoTip ?? this.ecoTip,
      isEcoTipApplied: isEcoTipApplied ?? this.isEcoTipApplied,
    );
  }
}

/// AI habitat mesh optimization intelligence data.
@immutable
class NexusIntelligenceData {
  final int ecoScore;
  final int maxScore;
  final String habitatStatus;
  final String comparisonText;
  final String suggestionTitle;
  final String suggestionDescription;
  final bool isOptimizationApplied;
  final double optimizationSavingsKw;

  const NexusIntelligenceData({
    this.ecoScore = 94,
    this.maxScore = 100,
    this.habitatStatus = 'Superior Habitat Status',
    this.comparisonText = 'Outperforming 92% of local microgrids',
    this.suggestionTitle = 'Autonomous Load Balancing Ready',
    this.suggestionDescription =
        'Diverting non-essential water heater cycles to match predicted solar surge at 13:00.',
    this.isOptimizationApplied = false,
    this.optimizationSavingsKw = 0.4,
  });

  NexusIntelligenceData copyWith({
    int? ecoScore,
    int? maxScore,
    String? habitatStatus,
    String? comparisonText,
    String? suggestionTitle,
    String? suggestionDescription,
    bool? isOptimizationApplied,
    double? optimizationSavingsKw,
  }) {
    return NexusIntelligenceData(
      ecoScore: ecoScore ?? this.ecoScore,
      maxScore: maxScore ?? this.maxScore,
      habitatStatus: habitatStatus ?? this.habitatStatus,
      comparisonText: comparisonText ?? this.comparisonText,
      suggestionTitle: suggestionTitle ?? this.suggestionTitle,
      suggestionDescription: suggestionDescription ?? this.suggestionDescription,
      isOptimizationApplied: isOptimizationApplied ?? this.isOptimizationApplied,
      optimizationSavingsKw: optimizationSavingsKw ?? this.optimizationSavingsKw,
    );
  }
}

/// Complete UI State for the Energy Analytics screen.
@immutable
class EnergyUiState {
  final PowerFluxTelemetry powerFlux;
  final ConsumptionDynamicsData consumptionDynamics;
  final List<ApplianceDrainItem> appliances;
  final NexusIntelligenceData intelligence;
  final String? userFeedback;

  const EnergyUiState({
    this.powerFlux = const PowerFluxTelemetry(),
    this.consumptionDynamics = const ConsumptionDynamicsData(),
    this.appliances = const [],
    this.intelligence = const NexusIntelligenceData(),
    this.userFeedback,
  });

  EnergyUiState copyWith({
    PowerFluxTelemetry? powerFlux,
    ConsumptionDynamicsData? consumptionDynamics,
    List<ApplianceDrainItem>? appliances,
    NexusIntelligenceData? intelligence,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return EnergyUiState(
      powerFlux: powerFlux ?? this.powerFlux,
      consumptionDynamics: consumptionDynamics ?? this.consumptionDynamics,
      appliances: appliances ?? this.appliances,
      intelligence: intelligence ?? this.intelligence,
      userFeedback: clearFeedback ? null : (userFeedback ?? this.userFeedback),
    );
  }
}

/// Discrete UI Actions dispatched from EnergyAnalyticsScreen.
sealed class EnergyUiAction {
  const EnergyUiAction();
}

class SelectPeriodAction extends EnergyUiAction {
  final TimelinePeriod period;
  const SelectPeriodAction(this.period);
}

class ApplyApplianceEcoTipAction extends EnergyUiAction {
  final String applianceId;
  const ApplyApplianceEcoTipAction(this.applianceId);
}

class ApplyAutoPowerOptimizationAction extends EnergyUiAction {
  const ApplyAutoPowerOptimizationAction();
}

class ClearFeedbackAction extends EnergyUiAction {
  const ClearFeedbackAction();
}
