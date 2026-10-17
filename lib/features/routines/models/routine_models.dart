import 'package:flutter/foundation.dart';

/// AI Protocol Synapse Banner metrics.
@immutable
class SynapseStats {
  final int triggersFiredCount;
  final String triggersSubtitle;
  final double successVectorPercent;
  final String successSubtitle;
  final bool isNeuralSynced;

  const SynapseStats({
    this.triggersFiredCount = 24,
    this.triggersSubtitle = 'Actions Today',
    this.successVectorPercent = 99.8,
    this.successSubtitle = '% nominal',
    this.isNeuralSynced = true,
  });

  SynapseStats copyWith({
    int? triggersFiredCount,
    String? triggersSubtitle,
    double? successVectorPercent,
    String? successSubtitle,
    bool? isNeuralSynced,
  }) {
    return SynapseStats(
      triggersFiredCount: triggersFiredCount ?? this.triggersFiredCount,
      triggersSubtitle: triggersSubtitle ?? this.triggersSubtitle,
      successVectorPercent: successVectorPercent ?? this.successVectorPercent,
      successSubtitle: successSubtitle ?? this.successSubtitle,
      isNeuralSynced: isNeuralSynced ?? this.isNeuralSynced,
    );
  }
}

/// Color accent palette for routine actions and categories.
enum RoutineActionAccent {
  cyan,
  purple,
  emerald,
  crimson,
  slate,
}

/// Distinct icons available for sub-actions within a routine sequence.
enum RoutineActionIcon {
  lightGradual,
  blinds,
  broadcast,
  coffee,
  blueLight,
  anc,
  dnd,
  airflow,
  amberLight,
  perimeter,
  thermostat,
  shades,
  lock,
  radar,
  camera,
  powerCut,
}

/// Sub-action item shown inside a 2x2 tile grid in each routine card.
@immutable
class RoutineActionItem {
  final String label;
  final RoutineActionIcon iconType;
  final RoutineActionAccent accent;

  const RoutineActionItem({
    required this.label,
    required this.iconType,
    required this.accent,
  });
}

/// Trigger condition icon types.
enum RoutineTriggerIcon {
  alarm,
  nfc,
  twilight,
  bedtime,
}

/// Top category indicator icons.
enum RoutineCategoryIcon {
  sunrise,
  matrix,
  sunset,
  security,
}

/// A complete scheduled routine sequence definition.
@immutable
class ScheduledSequenceItem {
  final String id;
  final String title;
  final String triggerText;
  final RoutineTriggerIcon triggerIcon;
  final RoutineCategoryIcon categoryIcon;
  final RoutineActionAccent categoryAccent;
  final bool isEnabled;
  final List<RoutineActionItem> actions;

  const ScheduledSequenceItem({
    required this.id,
    required this.title,
    required this.triggerText,
    required this.triggerIcon,
    required this.categoryIcon,
    required this.categoryAccent,
    required this.isEnabled,
    required this.actions,
  });

  ScheduledSequenceItem copyWith({
    String? id,
    String? title,
    String? triggerText,
    RoutineTriggerIcon? triggerIcon,
    RoutineCategoryIcon? categoryIcon,
    RoutineActionAccent? categoryAccent,
    bool? isEnabled,
    List<RoutineActionItem>? actions,
  }) {
    return ScheduledSequenceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      triggerText: triggerText ?? this.triggerText,
      triggerIcon: triggerIcon ?? this.triggerIcon,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryAccent: categoryAccent ?? this.categoryAccent,
      isEnabled: isEnabled ?? this.isEnabled,
      actions: actions ?? this.actions,
    );
  }
}

/// Complete UI state for the Automations & Routines screen.
@immutable
class RoutinesUiState {
  final SynapseStats synapseStats;
  final List<ScheduledSequenceItem> routines;
  final bool isSortedAlphabetical;
  final String? userFeedback;

  const RoutinesUiState({
    this.synapseStats = const SynapseStats(),
    this.routines = const [],
    this.isSortedAlphabetical = false,
    this.userFeedback,
  });

  RoutinesUiState copyWith({
    SynapseStats? synapseStats,
    List<ScheduledSequenceItem>? routines,
    bool? isSortedAlphabetical,
    String? userFeedback,
    bool clearFeedback = false,
  }) {
    return RoutinesUiState(
      synapseStats: synapseStats ?? this.synapseStats,
      routines: routines ?? this.routines,
      isSortedAlphabetical: isSortedAlphabetical ?? this.isSortedAlphabetical,
      userFeedback: clearFeedback ? null : (userFeedback ?? this.userFeedback),
    );
  }
}

/// Discrete UI Actions dispatched from AutomationsRoutinesScreen.
sealed class RoutinesUiAction {
  const RoutinesUiAction();
}

class ToggleRoutineAction extends RoutinesUiAction {
  final String routineId;
  const ToggleRoutineAction(this.routineId);
}

class DeployNewRoutineAction extends RoutinesUiAction {
  const DeployNewRoutineAction();
}

class ToggleSortMatrixAction extends RoutinesUiAction {
  const ToggleSortMatrixAction();
}

class ClearRoutinesFeedbackAction extends RoutinesUiAction {
  const ClearRoutinesFeedbackAction();
}
