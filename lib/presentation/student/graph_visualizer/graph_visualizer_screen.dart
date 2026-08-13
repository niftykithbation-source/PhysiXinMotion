import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/content/lesson_stage_providers.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/gamification/module_interaction_tracker.dart';
import '../../../data/motion_lab/motion_trials_provider.dart';
import '../../../data/session/current_student_provider.dart';
import '../../../data/settings/app_settings_provider.dart';
import '../widgets/five_e_progress_pips.dart';

enum _GraphMode { displacementTime, velocityTime }

/// Student — Graph Visualizer (Explain, read-only teaching aid). Blueprint
/// §3.3/§7 Step 5.3: reads motion_trials, doesn't write any evidence of its
/// own — completion is tracked via [ModuleInteractionTracker] instead (see
/// Step 4's flagged Graph Reader badge gap, closed here).
class GraphVisualizerScreen extends ConsumerStatefulWidget {
  const GraphVisualizerScreen({super.key});

  @override
  ConsumerState<GraphVisualizerScreen> createState() => _GraphVisualizerScreenState();
}

class _GraphVisualizerScreenState extends ConsumerState<GraphVisualizerScreen> {
  _GraphMode _mode = _GraphMode.displacementTime;
  final List<int> _selectedIndices = [];
  bool _showArea = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final db = ref.read(appDatabaseProvider);
      final student = await ref.read(currentStudentProvider.future);
      await ModuleInteractionTracker(db)
          .recordView(userId: student.userId, moduleKey: 'graph_visualizer');
    });
  }

  @override
  Widget build(BuildContext context) {
    final trialsAsync = ref.watch(studentMotionTrialsProvider);
    final stageAsync = ref.watch(lessonStageByNameProvider('explain'));
    final simpleGraphics = ref.watch(simpleGraphicsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Graph Visualizer')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FiveEProgressPips(
                current: 'explain',
                completedStages: {'engage', 'explore', 'explain'},
              ),
              const SizedBox(height: 20),
              SegmentedButton<_GraphMode>(
                segments: const [
                  ButtonSegment(
                    value: _GraphMode.displacementTime,
                    label: Text('Displacement-time'),
                  ),
                  ButtonSegment(value: _GraphMode.velocityTime, label: Text('Velocity-time')),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) => setState(() {
                  _mode = selection.first;
                  _selectedIndices.clear();
                }),
              ),
              const SizedBox(height: 16),
              trialsAsync.when(
                data: (trials) => _GraphPanel(
                  trials: capTrialHistory(trials, simpleGraphics: simpleGraphics),
                  mode: _mode,
                  simpleGraphics: simpleGraphics,
                  selectedIndices: _selectedIndices,
                  showArea: _showArea,
                  onPointTap: (index) => setState(() {
                    if (_selectedIndices.contains(index)) {
                      _selectedIndices.remove(index);
                    } else {
                      if (_selectedIndices.length >= 2) _selectedIndices.removeAt(0);
                      _selectedIndices.add(index);
                    }
                  }),
                ),
                loading: () => const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => Text('$error'),
              ),
              if (_mode == _GraphMode.velocityTime) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => setState(() => _showArea = !_showArea),
                  child: Text(_showArea ? 'Hide shaded area' : 'Shade area under curve'),
                ),
              ],
              const SizedBox(height: 28),
              Text('The four kinematic equations', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              stageAsync.when(
                data: (stage) => _EquationsPanel(stage: stage),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text('$error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraphPanel extends StatelessWidget {
  const _GraphPanel({
    required this.trials,
    required this.mode,
    required this.simpleGraphics,
    required this.selectedIndices,
    required this.showArea,
    required this.onPointTap,
  });

  final List<MotionTrialRow> trials;
  final _GraphMode mode;
  final bool simpleGraphics;
  final List<int> selectedIndices;
  final bool showArea;
  final void Function(int index) onPointTap;

  List<FlSpot> get _spots {
    if (mode == _GraphMode.displacementTime) {
      return [
        const FlSpot(0, 0),
        for (final trial in trials) FlSpot(trial.timeS, trial.displacementM),
      ];
    }
    return [
      for (final trial in trials) FlSpot(trial.timeS, trial.computedVelocity ?? 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    if (trials.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'No Motion Lab trials yet — add some in Motion Lab first.',
            style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6)),
          ),
        ),
      );
    }

    final spots = _spots;
    final unit = mode == _GraphMode.displacementTime ? 'm/s' : 'm/s²';
    final slopeLabel = mode == _GraphMode.displacementTime ? 'velocity' : 'acceleration';

    String? slopeText;
    if (selectedIndices.length == 2) {
      final a = spots[selectedIndices[0]];
      final b = spots[selectedIndices[1]];
      if (b.x != a.x) {
        final slope = (b.y - a.y) / (b.x - a.x);
        slopeText = 'Slope = $slopeLabel = ${slope.toStringAsFixed(2)} $unit';
      }
    }

    double? area;
    if (showArea && mode == _GraphMode.velocityTime && spots.length >= 2) {
      area = 0;
      for (var i = 1; i < spots.length; i++) {
        final dt = spots[i].x - spots[i - 1].x;
        area = area! + dt * (spots[i].y + spots[i - 1].y) / 2;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap any two points to see the slope between them.',
          style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6), fontSize: 12),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: LineChart(
            duration: simpleGraphics ? Duration.zero : const Duration(milliseconds: 150),
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: colors.primaryAccent,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: showArea && mode == _GraphMode.velocityTime,
                    color: colors.secondaryAccent.withValues(alpha: 0.3),
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                      radius: selectedIndices.contains(index) ? 7 : 4,
                      color: selectedIndices.contains(index)
                          ? colors.secondaryAccent
                          : colors.primaryAccent,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchCallback: (event, response) {
                  if (event is! FlTapUpEvent) return;
                  final spot = response?.lineBarSpots?.firstOrNull;
                  if (spot != null) onPointTap(spot.spotIndex);
                },
                touchTooltipData: LineTouchTooltipData(getTooltipColor: (_) => colors.surfaceCard),
              ),
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
        if (slopeText != null) ...[
          const SizedBox(height: 8),
          Text(slopeText, style: Theme.of(context).textTheme.titleSmall),
        ],
        if (area != null) ...[
          const SizedBox(height: 8),
          Text(
            'Shaded area = displacement ≈ ${area.toStringAsFixed(2)} m',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ],
    );
  }
}

class _EquationsPanel extends StatelessWidget {
  const _EquationsPanel({required this.stage});

  final LessonStageRow stage;

  @override
  Widget build(BuildContext context) {
    final body = jsonDecode(stage.bodyJson) as Map<String, dynamic>;
    final equations = (body['kinematic_equations'] as List).cast<Map<String, dynamic>>();

    return Column(
      children: [
        for (final eq in equations)
          Card(
            child: ExpansionTile(
              title: Text(
                eq['formula'] as String,
                style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
              subtitle: Text('solves for ${eq['solves_for']}'),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final step in (eq['derivation_steps'] as List).cast<String>())
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('• $step'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
