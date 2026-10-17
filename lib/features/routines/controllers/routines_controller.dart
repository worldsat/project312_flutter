import 'package:flutter/foundation.dart';
import '../data/routine_mock_data.dart';
import '../models/routine_models.dart';

/// Unidirectional State Controller for Automations & Routines.
/// Replicates Android's RoutinesViewModel.kt.
class RoutinesController extends ValueNotifier<RoutinesUiState> {
  RoutinesController([RoutinesUiState? initialState])
      : super(initialState ?? RoutineMockData.createInitialState());

  void onAction(RoutinesUiAction action) {
    switch (action) {
      case ToggleRoutineAction(:final routineId):
        _toggleRoutine(routineId);
      case DeployNewRoutineAction():
        _deployNewRoutine();
      case ToggleSortMatrixAction():
        _toggleSortMatrix();
      case ClearRoutinesFeedbackAction():
        _clearFeedback();
    }
  }

  void _toggleRoutine(String routineId) {
    ScheduledSequenceItem? target;
    final updated = value.routines.map((routine) {
      if (routine.id == routineId) {
        target = routine;
        return routine.copyWith(isEnabled: !routine.isEnabled);
      }
      return routine;
    }).toList();

    final stateText = target?.isEnabled == true ? 'Deactivated' : 'Activated';
    value = value.copyWith(
      routines: updated,
      userFeedback: '${target?.title ?? "Routine"} $stateText',
    );
  }

  void _deployNewRoutine() {
    value = value.copyWith(
      userFeedback:
          'Routine Logic Architect: New Neural Sequence Template Ready',
    );
  }

  void _toggleSortMatrix() {
    final nextSort = !value.isSortedAlphabetical;
    final List<ScheduledSequenceItem> sortedList;

    if (nextSort) {
      sortedList = List<ScheduledSequenceItem>.from(value.routines)
        ..sort((a, b) => a.title.compareTo(b.title));
    } else {
      // Revert to initial execution priority order preserving toggled state
      final currentMap = {for (final r in value.routines) r.id: r.isEnabled};
      sortedList = RoutineMockData.initialRoutines.map((r) {
        return r.copyWith(isEnabled: currentMap[r.id] ?? r.isEnabled);
      }).toList();
    }

    value = value.copyWith(
      routines: sortedList,
      isSortedAlphabetical: nextSort,
      userFeedback: nextSort
          ? 'Matrix Sorted: Alphabetical'
          : 'Matrix Sorted: Execution Priority',
    );
  }

  void _clearFeedback() {
    value = value.copyWith(clearFeedback: true);
  }
}
