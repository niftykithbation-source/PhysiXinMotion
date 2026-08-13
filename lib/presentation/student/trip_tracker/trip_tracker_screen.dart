import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/backup/auto_backup_service.dart';
import '../../../data/content/lesson_stage_providers.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/session/current_student_provider.dart';
import '../widgets/five_e_progress_pips.dart';
import 'route_animation_canvas.dart';

final _tripTrackerDataProvider = FutureProvider.autoDispose((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final stage = await ref.watch(lessonStageByNameProvider('engage').future);
  final student = await ref.watch(currentStudentProvider.future);
  final existing = await (db.select(db.predictionLog)
        ..where((t) => t.userId.equals(student.userId) & t.stageId.equals(stage.stageId)))
      .getSingleOrNull();
  return (stage: stage, student: student, existing: existing);
});

/// Student — Trip Tracker (Engage). Blueprint §3.3.
class TripTrackerScreen extends ConsumerWidget {
  const TripTrackerScreen({super.key, this.onContinue});

  /// Called when the student taps "Continue to Motion Lab".
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(_tripTrackerDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Tracker')),
      body: dataAsync.when(
        data: (data) => _TripTrackerBody(
          stage: data.stage,
          student: data.student,
          existing: data.existing,
          onContinue: onContinue,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(padding: const EdgeInsets.all(24), child: Text('$error')),
        ),
      ),
    );
  }
}

class _TripTrackerBody extends ConsumerStatefulWidget {
  const _TripTrackerBody({
    required this.stage,
    required this.student,
    required this.existing,
    required this.onContinue,
  });

  final LessonStageRow stage;
  final UserRow student;
  final PredictionLogRow? existing;
  final VoidCallback? onContinue;

  @override
  ConsumerState<_TripTrackerBody> createState() => _TripTrackerBodyState();
}

class _TripTrackerBodyState extends ConsumerState<_TripTrackerBody> {
  String? _selectedPrediction;
  String? _selectedReasoning;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final body = jsonDecode(widget.stage.bodyJson) as Map<String, dynamic>;
    final predictionOptions = (body['prediction_options'] as List).cast<Map<String, dynamic>>();
    final reasoningOptions = (body['reasoning_options'] as List).cast<Map<String, dynamic>>();
    final submitted = widget.existing != null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FiveEProgressPips(
              current: 'engage',
              completedStages: submitted ? const {'engage'} : const {},
            ),
            const SizedBox(height: 20),
            Text(
              body['hook_question'] as String,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(body['scenario'] as String, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            const RouteAnimationCanvas(),
            const SizedBox(height: 24),
            if (submitted) ...[
              Text(
                'You predicted: ${_labelFor(predictionOptions, widget.existing!.predictedOption)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onContinue,
                  child: const Text('Continue to Motion Lab'),
                ),
              ),
            ] else ...[
              Text(
                body['prediction_prompt'] as String,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in predictionOptions)
                    ChoiceChip(
                      label: Text(option['label'] as String),
                      selected: _selectedPrediction == option['key'],
                      onSelected: (_) =>
                          setState(() => _selectedPrediction = option['key'] as String),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Why?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in reasoningOptions)
                    ChoiceChip(
                      label: Text(option['label'] as String),
                      selected: _selectedReasoning == option['key'],
                      onSelected: (_) =>
                          setState(() => _selectedReasoning = option['key'] as String),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedPrediction != null && _selectedReasoning != null && !_submitting
                          ? _submit
                          : null,
                  child: const Text('Predict the Winner'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _labelFor(List<Map<String, dynamic>> options, String key) {
    return options.firstWhere((o) => o['key'] == key)['label'] as String;
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final db = ref.read(appDatabaseProvider);

    await db.into(db.predictionLog).insert(PredictionLogCompanion.insert(
          logId: const Uuid().v4(),
          userId: Value(widget.student.userId),
          stageId: Value(widget.stage.stageId),
          predictedOption: _selectedPrediction!,
          reasoningKey: Value(_selectedReasoning),
          submittedAt: DateTime.now().millisecondsSinceEpoch,
        ));

    await AutoBackupService(db).checkAndBackupIfStageCompleted(
      userId: widget.student.userId,
      packId: kActiveContentPackId,
    );

    ref.invalidate(_tripTrackerDataProvider);
  }
}
