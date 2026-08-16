import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/physics_engine/answer_checker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/backup/auto_backup_service.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/evaluation/evaluation_providers.dart';
import '../../../data/gamification/gamification_service.dart';
import '../../../data/session/current_student_provider.dart';
import '../widgets/feedback_badge.dart';

/// Student — Evaluation Terminal (Evaluate). Blueprint §3.3: "10-item MC
/// quiz, one item per screen, progress bar. Immediate per-item feedback...
/// Summary screen: score, badges unlocked, Review Missed Items."
class EvaluationTerminalScreen extends ConsumerStatefulWidget {
  const EvaluationTerminalScreen({super.key, this.onFinished});

  /// Called once the attempt is scored and persisted. Lets a host shell
  /// (e.g. [StudentHomeShell]) surface the score in its own dialog and
  /// redirect, on top of the in-page summary rendered below. [responses]
  /// is this attempt's per-item answers, in submission order — used to
  /// build the compressed `ans` string for the Teacher Portal QR scan.
  final void Function(
    int correctCount,
    int totalCount,
    GamificationOutcome? outcome,
    List<QuizItemResponseRow> responses,
  )? onFinished;

  @override
  ConsumerState<EvaluationTerminalScreen> createState() => _EvaluationTerminalScreenState();
}

class _EvaluationTerminalScreenState extends ConsumerState<EvaluationTerminalScreen> {
  int _index = 0;
  String? _selectedKey;
  bool _checked = false;
  bool _finished = false;
  bool _submitting = false;

  String? _attemptId;
  final List<QuizItemResponseRow> _responses = [];
  GamificationOutcome? _outcome;

  Future<void> _ensureAttemptStarted(WidgetRef ref) async {
    if (_attemptId != null) return;
    final db = ref.read(appDatabaseProvider);
    final student = await ref.read(currentStudentProvider.future);
    _attemptId = const Uuid().v4();
    await db.into(db.quizAttempts).insert(QuizAttemptsCompanion.insert(
          attemptId: _attemptId!,
          userId: Value(student.userId),
          packId: const Value(kActiveContentPackId),
          attemptType: const Value('formative'),
          startedAt: DateTime.now().millisecondsSinceEpoch,
        ));
  }

  Future<void> _submitAnswer(QuizItemRow item) async {
    if (_selectedKey == null) return;
    setState(() => _submitting = true);

    await _ensureAttemptStarted(ref);
    final db = ref.read(appDatabaseProvider);
    final isCorrect = checkMcqAnswer(_selectedKey!, item.correctAnswer);

    final response = await db.into(db.quizItemResponses).insertReturning(
          QuizItemResponsesCompanion.insert(
            responseId: const Uuid().v4(),
            attemptId: Value(_attemptId),
            itemId: Value(item.itemId),
            givenAnswer: _selectedKey!,
            isCorrect: isCorrect,
            answeredAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
    _responses.add(response);

    if (mounted) {
      setState(() {
        _checked = true;
        _submitting = false;
      });
    }
  }

  Future<void> _nextOrFinish(List<QuizItemRow> items) async {
    if (_index < items.length - 1) {
      setState(() {
        _index++;
        _selectedKey = null;
        _checked = false;
      });
      return;
    }
    await _finishAttempt(items);
  }

  Future<void> _finishAttempt(List<QuizItemRow> items) async {
    setState(() => _submitting = true);
    final db = ref.read(appDatabaseProvider);
    final student = await ref.read(currentStudentProvider.future);
    final correctCount = _responses.where((r) => r.isCorrect).length;

    await (db.update(db.quizAttempts)..where((t) => t.attemptId.equals(_attemptId!))).write(
      QuizAttemptsCompanion(
        completedAt: Value(DateTime.now().millisecondsSinceEpoch),
        totalScore: Value(correctCount.toDouble()),
        maxScore: Value(items.length.toDouble()),
      ),
    );
    final attempt =
        await (db.select(db.quizAttempts)..where((t) => t.attemptId.equals(_attemptId!))).getSingle();

    final outcome = await GamificationService(db).onQuizAttemptCompleted(attempt);
    await AutoBackupService(db).checkAndBackupIfStageCompleted(
      userId: student.userId,
      packId: kActiveContentPackId,
    );

    if (mounted) {
      setState(() {
        _outcome = outcome;
        _finished = true;
        _submitting = false;
      });
      widget.onFinished?.call(correctCount, items.length, outcome, List.unmodifiable(_responses));
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(activeQuizItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Evaluation Terminal')),
      body: SafeArea(
        child: itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text('No evaluation items found.'));
            }
            if (_finished) {
              return _SummaryView(items: items, responses: _responses, outcome: _outcome);
            }
            return _QuestionView(
              items: items,
              index: _index,
              selectedKey: _selectedKey,
              checked: _checked,
              submitting: _submitting,
              onSelect: (key) => setState(() => _selectedKey = key),
              onSubmit: () => _submitAnswer(items[_index]),
              onNext: () => _nextOrFinish(items),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('$error'))),
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.items,
    required this.index,
    required this.selectedKey,
    required this.checked,
    required this.submitting,
    required this.onSelect,
    required this.onSubmit,
    required this.onNext,
  });

  final List<QuizItemRow> items;
  final int index;
  final String? selectedKey;
  final bool checked;
  final bool submitting;
  final ValueChanged<String> onSelect;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final item = items[index];
    final colors = AppColors.of(context);
    final choices = (jsonDecode(item.choicesJson ?? '[]') as List).cast<Map<String, dynamic>>();
    final isCorrect = selectedKey == item.correctAnswer;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: (index + 1) / items.length),
          const SizedBox(height: 8),
          Text('Item ${index + 1} of ${items.length}'),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.prompt, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  RadioGroup<String>(
                    groupValue: selectedKey,
                    onChanged: (value) {
                      if (!checked && value != null) onSelect(value);
                    },
                    child: Column(
                      children: [
                        for (final choice in choices)
                          RadioListTile<String>(
                            value: choice['key'] as String,
                            title: Text('${choice['key']}. ${choice['text']}'),
                            selected: selectedKey == choice['key'],
                          ),
                      ],
                    ),
                  ),
                  if (checked) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FeedbackBadge(isCorrect: isCorrect, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isCorrect
                                      ? 'Correct!'
                                      : 'Correct answer: ${item.correctAnswer}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
                          if (item.explanation != null) ...[
                            const SizedBox(height: 8),
                            Text(item.explanation!),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitting
                  ? null
                  : checked
                      ? onNext
                      : (selectedKey != null ? onSubmit : null),
              child: Text(
                checked ? (index == items.length - 1 ? 'See Summary' : 'Next') : 'Submit',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.items, required this.responses, required this.outcome});

  final List<QuizItemRow> items;
  final List<QuizItemResponseRow> responses;
  final GamificationOutcome? outcome;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final correctCount = responses.where((r) => r.isCorrect).length;
    final missed = responses.where((r) => !r.isCorrect).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session complete', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Score: $correctCount / ${items.length}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (outcome != null) ...[
            const SizedBox(height: 4),
            Text('+${outcome!.pointsAwarded} points'),
            if (outcome!.newlyUnlockedBadges.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Badges unlocked!', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final badge in outcome!.newlyUnlockedBadges)
                    Chip(
                      avatar: Icon(Icons.emoji_events, color: colors.secondaryAccent),
                      label: Text(badge.badgeName),
                    ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 24),
          if (missed.isNotEmpty) ...[
            Text('Review Missed Items', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final response in missed)
                    _MissedItemCard(
                      item: items.firstWhere((i) => i.itemId == response.itemId),
                      response: response,
                    ),
                ],
              ),
            ),
          ] else
            const Expanded(child: Center(child: Text('Perfect score — no missed items!'))),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissedItemCard extends StatelessWidget {
  const _MissedItemCard({required this.item, required this.response});

  final QuizItemRow item;
  final QuizItemResponseRow response;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.prompt, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Your answer: ${response.givenAnswer} · Correct: ${item.correctAnswer}'),
            if (item.explanation != null) ...[
              const SizedBox(height: 4),
              Text(item.explanation!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
