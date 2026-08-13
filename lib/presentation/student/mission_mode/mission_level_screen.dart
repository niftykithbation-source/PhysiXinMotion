import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/gamification/points_calculator.dart';
import '../../../core/physics_engine/answer_checker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/backup/auto_backup_service.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/gamification/gamification_service.dart';
import '../../../data/mission_mode/mission_mode_providers.dart';
import '../../../data/session/current_student_provider.dart';
import '../widgets/feedback_badge.dart';

/// Student — Mission Mode (Elaborate): problem screen. Blueprint §3.3.
class MissionLevelScreen extends ConsumerStatefulWidget {
  const MissionLevelScreen({super.key, required this.level});

  final MissionLevelRow level;

  @override
  ConsumerState<MissionLevelScreen> createState() => _MissionLevelScreenState();
}

class _MissionLevelScreenState extends ConsumerState<MissionLevelScreen> {
  final _answerController = TextEditingController();
  final _scratchpadController = TextEditingController();
  bool _showScratchpad = false;
  bool _submitting = false;

  ({bool isCorrect, double given})? _result;

  @override
  void dispose() {
    _answerController.dispose();
    _scratchpadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final level = widget.level;
    final givenValues = jsonDecode(level.givenValues) as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(level.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(level.scenarioText, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              Card(
                color: colors.surfaceCard,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Given', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      for (final entry in givenValues.entries)
                        Text('${entry.key} = ${entry.value}'),
                      const SizedBox(height: 4),
                      Text('Find: ${level.targetVariable}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _answerController,
                enabled: _result == null,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: InputDecoration(labelText: 'Your answer (${(level.unit ?? '')})'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _showScratchpad = !_showScratchpad),
                icon: const Icon(Icons.calculate_outlined),
                label: Text(_showScratchpad ? 'Hide scratchpad' : 'Show scratchpad'),
              ),
              if (_showScratchpad)
                TextField(
                  controller: _scratchpadController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Work out your manual computation here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 20),
              if (_result == null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: const Text('Submit'),
                  ),
                )
              else
                _ResultPanel(
                  result: _result!,
                  level: level,
                  onTryAgain: () => setState(() {
                    _result = null;
                    _answerController.clear();
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final given = double.tryParse(_answerController.text);
    if (given == null) return;

    setState(() => _submitting = true);

    final db = ref.read(appDatabaseProvider);
    final student = await ref.read(currentStudentProvider.future);
    final level = widget.level;

    final isCorrect = checkNumericAnswer(given, level.correctAnswer, level.tolerance);

    final previousAttempts = await (db.select(db.missionAttempts)
          ..where((t) => t.userId.equals(student.userId) & t.levelId.equals(level.levelId)))
        .get();
    final attemptNumber = previousAttempts.length + 1;

    final attempt = await db.into(db.missionAttempts).insertReturning(
          MissionAttemptsCompanion.insert(
            attemptId: const Uuid().v4(),
            userId: Value(student.userId),
            levelId: Value(level.levelId),
            submittedAnswer: given,
            isCorrect: isCorrect,
            attemptNumber: attemptNumber,
            pointsAwarded: Value(
              pointsForMissionAttempt(isCorrect: isCorrect, attemptNumber: attemptNumber),
            ),
            submittedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    await GamificationService(db).onMissionAttemptRecorded(attempt);
    await AutoBackupService(db).checkAndBackupIfStageCompleted(
      userId: student.userId,
      packId: kActiveContentPackId,
    );

    ref.invalidate(missionLevelSolvedProvider(level.levelId));

    if (mounted) {
      setState(() {
        _result = (isCorrect: isCorrect, given: given);
        _submitting = false;
      });
    }
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.result, required this.level, required this.onTryAgain});

  final ({bool isCorrect, double given}) result;
  final MissionLevelRow level;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FeedbackBadge(isCorrect: result.isCorrect),
            const SizedBox(width: 8),
            Text(
              result.isCorrect ? 'Correct!' : 'Not quite.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Formula: ${(level.formulaHint ?? '')}'),
        Text('Correct answer: ${level.correctAnswer} ${(level.unit ?? '')}'),
        if (!result.isCorrect) ...[
          const SizedBox(height: 12),
          Text(
            'Compare with your manual computation — where did it diverge?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: onTryAgain, child: const Text('Try Again')),
          ),
        ] else ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Levels'),
            ),
          ),
        ],
      ],
    );
  }
}
