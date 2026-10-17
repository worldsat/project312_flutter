import '../models/energy_models.dart';

/// Pre-seeded mock dataset for Energy Matrix telemetry and load dynamics.
/// Aligns 1:1 with Android EnergyMockData.kt.
abstract class EnergyMockData {
  static const PowerFluxTelemetry initialPowerFlux = PowerFluxTelemetry(
    totalDemandKw: 2.84,
    selfSustainedPercent: 58,
    solarInflowKw: 1.65,
    activePanelsCount: 12,
    gridPullKw: 1.19,
    gridTierRate: 'Off-peak tier: \$0.11',
    lastUpdatedText: 'Update: Just now',
    demandArcFraction: 0.71,
    ghostArcFraction: 0.44,
  );

  static const ConsumptionDynamicsData initialConsumptionDynamics =
      ConsumptionDynamicsData(
    selectedPeriod: TimelinePeriod.day,
    offPeakWindow: 'Off-Peak Window: 23:00 - 06:00',
    costDelta: '-22% Cost Delta',
    peakLabel: 'Peak: 3.4 kW (14:30)',
    dailyRunRate: '-14.2% avg',
    cycleSavings: '\$48.70 saved',
    timeLabels: ['00:00', '06:00', '12:00', '18:00', '23:59'],
  );

  static const List<ApplianceDrainItem> initialAppliances = [
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

  static const NexusIntelligenceData initialIntelligence =
      NexusIntelligenceData(
    ecoScore: 94,
    maxScore: 100,
    habitatStatus: 'Superior Habitat Status',
    comparisonText: 'Outperforming 92% of local microgrids',
    suggestionTitle: 'Autonomous Load Balancing Ready',
    suggestionDescription:
        'Diverting non-essential water heater cycles to match predicted solar surge at 13:00.',
    isOptimizationApplied: false,
    optimizationSavingsKw: 0.4,
  );

  static EnergyUiState createInitialState() {
    return const EnergyUiState(
      powerFlux: initialPowerFlux,
      consumptionDynamics: initialConsumptionDynamics,
      appliances: initialAppliances,
      intelligence: initialIntelligence,
      userFeedback: null,
    );
  }
}
