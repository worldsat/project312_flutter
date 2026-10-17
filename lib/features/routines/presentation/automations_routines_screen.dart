import 'package:flutter/material.dart';
import '../../../core/components/glass_container.dart';
import '../../../core/components/routine_switch.dart';
import '../../../core/theme/app_colors.dart';
import '../models/routine_models.dart';

/// AutomationsRoutinesScreen: Complete UI for the automations_routines destination.
/// Replicates Android AutomationsRoutinesScreen.kt and DESIGN.md specifications.
class AutomationsRoutinesScreen extends StatefulWidget {
  final RoutinesUiState state;
  final ValueChanged<RoutinesUiAction> onAction;

  const AutomationsRoutinesScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<AutomationsRoutinesScreen> createState() =>
      _AutomationsRoutinesScreenState();
}

class _AutomationsRoutinesScreenState extends State<AutomationsRoutinesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount =
        widget.state.routines.where((r) => r.isEnabled).length;

    return Container(
      color: AppColors.obsidianBackground,
      child: Stack(
        children: [
          // 1. Ambient Light Backdrops
          const _RoutinesAmbientBackdrops(),

          // 2. Main Scrollable List
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // AI Protocol Synapse Banner Card
              _buildProtocolSynapseCard(widget.state.synapseStats),
              const SizedBox(height: 18),

              // Logic Architect (Construct Automation IF/THEN Builder Card)
              _buildConstructAutomationCard(),
              const SizedBox(height: 18),

              // Scheduled Sequences Section Header
              _buildScheduledSequencesHeader(activeCount),
              const SizedBox(height: 14),

              // Scheduled Sequences Cards
              ...widget.state.routines.map((routine) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildRoutineSequenceCard(routine),
                );
              }),
            ],
          ),

          // 3. Local Feedback Snackbar Overlay
          if (widget.state.userFeedback != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.electricCyan.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.state.userFeedback!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.onBackgroundSlate50,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          widget.onAction(const ClearRoutinesFeedbackAction()),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(40, 32),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: AppColors.electricCyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 1. AI Protocol Synapse Banner Card.
  Widget _buildProtocolSynapseCard(SynapseStats stats) {
    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Brain emblem + Titles + Neural Sync pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Circular Emblem with pulsing dot
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh
                                  .withValues(alpha: 0.70),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.psychology_rounded,
                              size: 20,
                              color: AppColors.electricCyan,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, _) {
                                return Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: AppColors.ecoEmeraldBright
                                        .withValues(
                                            alpha: _pulseAnimation.value),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PROTOCOL SYNAPSE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: AppColors.electricCyanFixedDim,
                            ),
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            'AI Autonomous Engine Active',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackgroundSlate50,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Neural Sync Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      AppColors.surfaceContainerHighest.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.ecoEmeraldBright,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Neural Sync',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ecoEmeraldBright,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2-Column Stats Grid
          Row(
            children: [
              // Stat 1: Triggers Fired
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest
                        .withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.smart_toy_rounded,
                            size: 15,
                            color: AppColors.electricCyan,
                          ),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              'Triggers Fired',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${stats.triggersFiredCount}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackgroundSlate50,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              stats.triggersSubtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ecoEmeraldBright,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Stat 2: Success Vector
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest
                        .withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 15,
                            color: AppColors.violetAurora,
                          ),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              'Success Vector',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${stats.successVectorPercent}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackgroundSlate50,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              stats.successSubtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.electricCyanFixedDim,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Logic Architect Card ("Construct Automation" IF/THEN Builder).
  Widget _buildConstructAutomationCard() {
    return GlassContainer(
      cornerRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Logic Architect + alt_route icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LOGIC ARCHITECT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColors.electricCyanFixedDim,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Construct Automation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackgroundSlate50,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.electricCyan.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.alt_route_rounded,
                  size: 18,
                  color: AppColors.electricCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Flow Diagram Box (IF Condition -> THEN Protocol)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.outlineGlass.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // IF Block
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest
                              .withValues(alpha: 0.80),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sensors_rounded,
                          size: 15,
                          color: AppColors.electricCyanFixedDim,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IF Condition',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                            ),
                            Text(
                              'Sensor / Event',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackgroundSlate50,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Pulsing Arrow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: AppColors.electricCyan
                            .withValues(alpha: _pulseAnimation.value),
                      );
                    },
                  ),
                ),

                // THEN Block
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'THEN Protocol',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.onSurfaceVariantSlate,
                              ),
                            ),
                            Text(
                              'Multi-Action',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackgroundSlate50,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.violetContainer
                              .withValues(alpha: 0.40),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          size: 15,
                          color: AppColors.violetAurora,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Full-Width Pill Button: Deploy New Routine
          GestureDetector(
            onTap: () => widget.onAction(const DeployNewRoutineAction()),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.electricCyan,
                    Color(0xFF00A3FF),
                  ],
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_rounded,
                    size: 20,
                    color: AppColors.electricCyanDark,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Deploy New Routine',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.electricCyanDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Scheduled Sequences Section Header.
  Widget _buildScheduledSequencesHeader(int activeCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Flexible(
                  child: Text(
                    'Scheduled Sequences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onBackgroundSlate50,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$activeCount Active',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.electricCyanFixedDim,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => widget.onAction(const ToggleSortMatrixAction()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.state.isSortedAlphabetical
                        ? 'Sorted: A-Z'
                        : 'Sort Matrix',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariantSlate,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.tune_rounded,
                    size: 14,
                    color: AppColors.onSurfaceVariantSlate,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Routine Sequence Card with Custom Switch and 2x2 Sub-Action Tiles.
  Widget _buildRoutineSequenceCard(ScheduledSequenceItem routine) {
    final categoryIconData = switch (routine.categoryIcon) {
      RoutineCategoryIcon.sunrise => Icons.wb_twilight_rounded,
      RoutineCategoryIcon.matrix => Icons.hub_rounded,
      RoutineCategoryIcon.sunset => Icons.wb_twilight_rounded,
      RoutineCategoryIcon.security => Icons.security_rounded,
    };

    final categoryTint = switch (routine.categoryAccent) {
      RoutineActionAccent.cyan => AppColors.electricCyan,
      RoutineActionAccent.purple => AppColors.violetAurora,
      RoutineActionAccent.emerald => AppColors.ecoEmeraldBright,
      RoutineActionAccent.crimson => AppColors.alertCrimson,
      RoutineActionAccent.slate => AppColors.onSurfaceVariantSlate,
    };

    final triggerIconData = switch (routine.triggerIcon) {
      RoutineTriggerIcon.alarm => Icons.alarm_rounded,
      RoutineTriggerIcon.nfc => Icons.contactless_rounded,
      RoutineTriggerIcon.twilight => Icons.solar_power_rounded,
      RoutineTriggerIcon.bedtime => Icons.bedtime_rounded,
    };

    final row1 = routine.actions.take(2).toList();
    final row2 = routine.actions.skip(2).take(2).toList();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: routine.isEnabled ? 1.0 : 0.55,
      child: GlassContainer(
        cornerRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category icon, Title, Trigger info, RoutineSwitch
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          categoryIconData,
                          size: 20,
                          color: categoryTint,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackgroundSlate50,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(
                                  triggerIconData,
                                  size: 13,
                                  color: AppColors.electricCyanFixedDim,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    routine.triggerText,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.electricCyanFixedDim,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Toggle Switch
                RoutineSwitch(
                  checked: routine.isEnabled,
                  onCheckedChange: (_) =>
                      widget.onAction(ToggleRoutineAction(routine.id)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2x2 Sub-Action Tiles
            Column(
              children: [
                Row(
                  children: [
                    for (final action in row1)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _buildActionSubTile(action),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    for (final action in row2)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _buildActionSubTile(action),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSubTile(RoutineActionItem action) {
    final iconData = switch (action.iconType) {
      RoutineActionIcon.lightGradual => Icons.light_mode_rounded,
      RoutineActionIcon.blinds => Icons.blinds_rounded,
      RoutineActionIcon.broadcast => Icons.podcasts_rounded,
      RoutineActionIcon.coffee => Icons.coffee_rounded,
      RoutineActionIcon.blueLight => Icons.lens_blur_rounded,
      RoutineActionIcon.anc => Icons.headphones_rounded,
      RoutineActionIcon.dnd => Icons.do_not_disturb_on_rounded,
      RoutineActionIcon.airflow => Icons.air_rounded,
      RoutineActionIcon.amberLight => Icons.lightbulb_rounded,
      RoutineActionIcon.perimeter => Icons.shield_rounded,
      RoutineActionIcon.thermostat => Icons.thermostat_rounded,
      RoutineActionIcon.shades => Icons.blinds_closed_rounded,
      RoutineActionIcon.lock => Icons.lock_rounded,
      RoutineActionIcon.radar => Icons.radar_rounded,
      RoutineActionIcon.camera => Icons.videocam_rounded,
      RoutineActionIcon.powerCut => Icons.power_settings_new_rounded,
    };

    final iconTint = switch (action.accent) {
      RoutineActionAccent.cyan => AppColors.electricCyan,
      RoutineActionAccent.purple => AppColors.violetAurora,
      RoutineActionAccent.emerald => AppColors.ecoEmeraldDim,
      RoutineActionAccent.crimson => AppColors.alertCrimson,
      RoutineActionAccent.slate => AppColors.onSurfaceVariantSlate,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 14,
            color: iconTint,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              action.label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.onSurfaceVariantSlate,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ambient colored glow accents behind the routines cockpit.
class _RoutinesAmbientBackdrops extends StatelessWidget {
  const _RoutinesAmbientBackdrops();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cyan Glow Top-Right
        Positioned(
          right: -40,
          top: -20,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.electricCyan.withValues(alpha: 0.18),
                  AppColors.electricCyan.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Violet Glow Left-Center
        Positioned(
          left: -40,
          top: 300,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.violetContainerVibrant.withValues(alpha: 0.20),
                  AppColors.violetContainerVibrant.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
