import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../models/routine_models.dart';

/// Unidirectional State Controller for Automations & Routines.
/// Replicates Android's RoutinesViewModel.kt.
class RoutinesController extends ValueNotifier<RoutinesUiState> {
  final FirestoreService? firestoreService;
  StreamSubscription<List<ScheduledSequenceItem>>? _routinesSubscription;

  RoutinesController({RoutinesUiState? initialState, this.firestoreService})
      : super(initialState ?? const RoutinesUiState(routines: [])) {
    if (firestoreService != null) {
      _routinesSubscription = firestoreService!.streamRoutines().listen((cloudRoutines) {
        if (cloudRoutines.isNotEmpty) {
          value = value.copyWith(routines: cloudRoutines);
        }
      });
    }
  }

  @override
  void dispose() {
    _routinesSubscription?.cancel();
    super.dispose();
  }

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

    final nextState = target?.isEnabled == true;
    final stateText = nextState ? 'Activated' : 'Deactivated';
    value = value.copyWith(
      routines: updated,
      userFeedback: '${target?.title ?? "Routine"} $stateText',
    );
    firestoreService?.updateRoutineEnabled(routineId, nextState);
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
      sortedList = List<ScheduledSequenceItem>.from(value.routines)
        ..sort((a, b) => a.id.compareTo(b.id));
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
