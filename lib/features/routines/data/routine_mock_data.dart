import '../models/routine_models.dart';

/// Pre-seeded mock dataset for Automations & Scheduled Sequences.
/// Aligns 1:1 with Android RoutineMockData.kt.
abstract class RoutineMockData {
  static const SynapseStats initialSynapseStats = SynapseStats(
    triggersFiredCount: 24,
    triggersSubtitle: 'Actions Today',
    successVectorPercent: 99.8,
    successSubtitle: '% nominal',
    isNeuralSynced: true,
  );

  static const List<ScheduledSequenceItem> initialRoutines = [
    ScheduledSequenceItem(
      id: 'sunrise_awakening',
      title: 'Sunrise Awakening',
      triggerText: '06:30 AM Daily',
      triggerIcon: RoutineTriggerIcon.alarm,
      categoryIcon: RoutineCategoryIcon.sunrise,
      categoryAccent: RoutineActionAccent.emerald,
      isEnabled: true,
      actions: [
        RoutineActionItem(
          label: 'Gradual 10% → 100%',
          iconType: RoutineActionIcon.lightGradual,
          accent: RoutineActionAccent.emerald,
        ),
        RoutineActionItem(
          label: 'Blinds Open 75%',
          iconType: RoutineActionIcon.blinds,
          accent: RoutineActionAccent.cyan,
        ),
        RoutineActionItem(
          label: 'Morning Broadcast',
          iconType: RoutineActionIcon.broadcast,
          accent: RoutineActionAccent.purple,
        ),
        RoutineActionItem(
          label: 'Espresso Brew Start',
          iconType: RoutineActionIcon.coffee,
          accent: RoutineActionAccent.emerald,
        ),
      ],
    ),
    ScheduledSequenceItem(
      id: 'focus_matrix',
      title: 'Focus Matrix',
      triggerText: 'Trigger: NFC Desk Tag',
      triggerIcon: RoutineTriggerIcon.nfc,
      categoryIcon: RoutineCategoryIcon.matrix,
      categoryAccent: RoutineActionAccent.cyan,
      isEnabled: true,
      actions: [
        RoutineActionItem(
          label: 'Blue Light 450nm',
          iconType: RoutineActionIcon.blueLight,
          accent: RoutineActionAccent.cyan,
        ),
        RoutineActionItem(
          label: 'ANC Level 100%',
          iconType: RoutineActionIcon.anc,
          accent: RoutineActionAccent.purple,
        ),
        RoutineActionItem(
          label: 'DND Shield On',
          iconType: RoutineActionIcon.dnd,
          accent: RoutineActionAccent.crimson,
        ),
        RoutineActionItem(
          label: 'Airflow 22°C Silent',
          iconType: RoutineActionIcon.airflow,
          accent: RoutineActionAccent.emerald,
        ),
      ],
    ),
    ScheduledSequenceItem(
      id: 'sunset_transition',
      title: 'Sunset Transition',
      triggerText: 'Astronomical Twilight (18:45)',
      triggerIcon: RoutineTriggerIcon.twilight,
      categoryIcon: RoutineCategoryIcon.sunset,
      categoryAccent: RoutineActionAccent.purple,
      isEnabled: true,
      actions: [
        RoutineActionItem(
          label: 'Amber Tone 2700K',
          iconType: RoutineActionIcon.amberLight,
          accent: RoutineActionAccent.emerald,
        ),
        RoutineActionItem(
          label: 'Perimeter Guard Arm',
          iconType: RoutineActionIcon.perimeter,
          accent: RoutineActionAccent.cyan,
        ),
        RoutineActionItem(
          label: 'Thermostat 21°C',
          iconType: RoutineActionIcon.thermostat,
          accent: RoutineActionAccent.purple,
        ),
        RoutineActionItem(
          label: 'Smart Shades 100%',
          iconType: RoutineActionIcon.shades,
          accent: RoutineActionAccent.slate,
        ),
      ],
    ),
    ScheduledSequenceItem(
      id: 'cyber_security_lockout',
      title: 'Cyber Security Lockout',
      triggerText: '11:30 PM Nightly',
      triggerIcon: RoutineTriggerIcon.bedtime,
      categoryIcon: RoutineCategoryIcon.security,
      categoryAccent: RoutineActionAccent.crimson,
      isEnabled: true,
      actions: [
        RoutineActionItem(
          label: 'Biometric Locks On',
          iconType: RoutineActionIcon.lock,
          accent: RoutineActionAccent.crimson,
        ),
        RoutineActionItem(
          label: 'Motion Grid Armed',
          iconType: RoutineActionIcon.radar,
          accent: RoutineActionAccent.cyan,
        ),
        RoutineActionItem(
          label: 'IR Night Optical',
          iconType: RoutineActionIcon.camera,
          accent: RoutineActionAccent.emerald,
        ),
        RoutineActionItem(
          label: 'Vampire Loads Cut',
          iconType: RoutineActionIcon.powerCut,
          accent: RoutineActionAccent.purple,
        ),
      ],
    ),
  ];

  static RoutinesUiState createInitialState() {
    return const RoutinesUiState(
      synapseStats: initialSynapseStats,
      routines: initialRoutines,
      isSortedAlphabetical: false,
      userFeedback: null,
    );
  }
}
