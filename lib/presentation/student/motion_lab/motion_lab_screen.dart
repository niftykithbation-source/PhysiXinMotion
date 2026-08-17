import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/physics_engine/motion_lab_calculator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/backup/auto_backup_service.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/motion_lab/motion_trials_provider.dart';
import '../../../data/session/current_student_provider.dart';
import '../../../data/settings/app_settings_provider.dart';
import '../widgets/five_e_progress_pips.dart';
import 'trial_animation_canvas.dart';

/// Student — Motion Lab (Explore, sandbox). Blueprint §3.3.
class MotionLabScreen extends ConsumerStatefulWidget {
  const MotionLabScreen({super.key, this.onSendToGraphVisualizer});

  final VoidCallback? onSendToGraphVisualizer;

  @override
  ConsumerState<MotionLabScreen> createState() => _MotionLabScreenState();
}

class _MotionLabScreenState extends ConsumerState<MotionLabScreen> {
  MotionTrialRow? _animatingTrial;
  int _replayTick = 0;

  void _playTrial(MotionTrialRow trial) {
    setState(() {
      _animatingTrial = trial;
      _replayTick++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trialsAsync = ref.watch(studentMotionTrialsProvider);
    final simpleGraphics = ref.watch(simpleGraphicsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Motion Lab')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FiveEProgressPips(
                current: 'explore',
                completedStages: trialsAsync.maybeWhen(
                  data: (trials) => trials.isNotEmpty ? const {'engage', 'explore'} : const {'engage'},
                  orElse: () => const {},
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '"Walk the Line": mark an 8-10 m path, walk it, record what you measured.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (_animatingTrial != null) ...[
                const SizedBox(height: 20),
                Text('Simulation', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                TrialAnimationCanvas(
                  key: ValueKey('${_animatingTrial!.trialId}-$_replayTick'),
                  trial: _animatingTrial!,
                ),
              ],
              const SizedBox(height: 20),
              trialsAsync.when(
                data: (trials) => _MotionLabChart(trials: trials, simpleGraphics: simpleGraphics),
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => Text('$error'),
              ),
              const SizedBox(height: 20),
              trialsAsync.maybeWhen(
                data: (trials) => _TrialList(
                  trials: capTrialHistory(trials, simpleGraphics: simpleGraphics),
                  totalCount: trials.length,
                  onReplay: _playTrial,
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
              _AddTrialForm(onTrialAdded: _playTrial),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: trialsAsync.maybeWhen(
                    data: (trials) => trials.isNotEmpty ? widget.onSendToGraphVisualizer : null,
                    orElse: () => null,
                  ),
                  child: const Text('Send to Graph Visualizer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MotionLabChart extends StatelessWidget {
  const _MotionLabChart({required this.trials, required this.simpleGraphics});

  final List<MotionTrialRow> trials;
  final bool simpleGraphics;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    if (trials.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'Add a trial to see the displacement-time chart.',
            style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6)),
          ),
        ),
      );
    }

    final visibleTrials = capTrialHistory(trials, simpleGraphics: simpleGraphics);
    final spots = [
      const FlSpot(0, 0),
      for (final trial in visibleTrials) FlSpot(trial.timeS, trial.displacementM),
    ];

    return SizedBox(
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
              dotData: const FlDotData(show: true),
            ),
          ],
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}

class _TrialList extends StatelessWidget {
  const _TrialList({required this.trials, required this.totalCount, required this.onReplay});

  final List<MotionTrialRow> trials;
  final int totalCount;
  final void Function(MotionTrialRow trial) onReplay;

  @override
  Widget build(BuildContext context) {
    if (trials.isEmpty) return const SizedBox.shrink();
    final hiddenCount = totalCount - trials.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hiddenCount > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Showing the most recent ${trials.length} of $totalCount trials.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        for (final trial in trials)
          Card(
            child: ListTile(
              title: Text('Trial ${trial.trialNumber}'),
              subtitle: Text(
                'distance ${trial.distanceM} m · displacement ${trial.displacementM} m · '
                'time ${trial.timeS} s · '
                'v: ${trial.computedVelocity?.toStringAsFixed(2) ?? '-'} m/s',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.play_circle_outline),
                tooltip: 'Replay simulation',
                onPressed: () => onReplay(trial),
              ),
              onTap: () => onReplay(trial),
            ),
          ),
      ],
    );
  }
}

class _AddTrialForm extends ConsumerStatefulWidget {
  const _AddTrialForm({required this.onTrialAdded});

  final void Function(MotionTrialRow trial) onTrialAdded;

  @override
  ConsumerState<_AddTrialForm> createState() => _AddTrialFormState();
}

class _AddTrialFormState extends ConsumerState<_AddTrialForm> {
  final _distanceController = TextEditingController();
  final _displacementController = TextEditingController();
  final _timeController = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    _distanceController.dispose();
    _displacementController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('+ Add Trial', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _distanceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: const InputDecoration(labelText: 'Distance walked (m)'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _displacementController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: const InputDecoration(labelText: 'Displacement (m, signed)'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _timeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Time (s)'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: const Text('Add Trial'),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final distance = double.tryParse(_distanceController.text);
    final displacement = double.tryParse(_displacementController.text);
    final time = double.tryParse(_timeController.text);

    if (distance == null || displacement == null || time == null) {
      setState(() => _error = 'Enter a number in every field.');
      return;
    }

    final ({double speed, double velocity}) computed;
    try {
      computed = computeSpeedVelocity(distanceM: distance, displacementM: displacement, timeS: time);
    } on ArgumentError catch (e) {
      setState(() => _error = e.message as String? ?? 'Invalid trial values.');
      return;
    }

    setState(() {
      _error = null;
      _submitting = true;
    });

    final db = ref.read(appDatabaseProvider);
    final student = await ref.read(currentStudentProvider.future);
    final existingTrials = await ref.read(studentMotionTrialsProvider.future);
    final nextTrialNumber = existingTrials.length + 1;

    final insertedTrial = await db.into(db.motionTrials).insertReturning(
          MotionTrialsCompanion.insert(
            trialId: const Uuid().v4(),
            userId: Value(student.userId),
            trialNumber: nextTrialNumber,
            distanceM: distance,
            displacementM: displacement,
            timeS: time,
            computedSpeed: Value(computed.speed),
            computedVelocity: Value(computed.velocity),
            recordedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    await AutoBackupService(db).checkAndBackupIfStageCompleted(
      userId: student.userId,
      packId: kActiveContentPackId,
    );

    _distanceController.clear();
    _displacementController.clear();
    _timeController.clear();
    ref.invalidate(studentMotionTrialsProvider);
    // Trigger the simulation directly with the row we just inserted,
    // rather than relying on the list provider's refresh reaching this
    // widget tree in time.
    widget.onTrialAdded(insertedTrial);
    if (mounted) setState(() => _submitting = false);
  }
}
