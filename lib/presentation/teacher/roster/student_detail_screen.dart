import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/evaluation/evaluation_providers.dart';
import '../../../data/session/current_student_provider.dart' show kActiveContentPackId;
import '../../../data/teacher/roster_providers.dart';

/// One row of a quiz attempt's per-question breakdown — Q1..Q10, per
/// [orderQuizItemsByNumber]. Populated whether the attempt came from a
/// full in-app Evaluation session or a QR scan (QrIngestService writes
/// real quiz_item_responses rows from the compressed `ans` string, so both
/// sources look identical here).
class _ItemResponseDetail {
  final int itemNumber;
  final String prompt;
  final String givenAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String? explanation;

  const _ItemResponseDetail({
    required this.itemNumber,
    required this.prompt,
    required this.givenAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.explanation,
  });
}

class _StudentActivity {
  final List<MotionTrialRow> trials;
  final List<MissionAttemptRow> missionAttempts;
  final List<QuizAttemptRow> quizAttempts;
  final Map<String, List<_ItemResponseDetail>> responsesByAttemptId;

  const _StudentActivity({
    required this.trials,
    required this.missionAttempts,
    required this.quizAttempts,
    required this.responsesByAttemptId,
  });
}

final _studentActivityProvider = FutureProvider.autoDispose.family<_StudentActivity, String>((
  ref,
  userId,
) async {
  final db = ref.watch(appDatabaseProvider);
  final trials = await (db.select(db.motionTrials)..where((t) => t.userId.equals(userId))).get();
  final missionAttempts =
      await (db.select(db.missionAttempts)..where((t) => t.userId.equals(userId))).get();
  final quizAttempts =
      await (db.select(db.quizAttempts)..where((t) => t.userId.equals(userId))).get();

  final orderedItems = orderQuizItemsByNumber(
    await (db.select(db.quizItems)..where((t) => t.packId.equals(kActiveContentPackId))).get(),
  );
  final itemNumberById = {
    for (var i = 0; i < orderedItems.length; i++) orderedItems[i].itemId: i + 1,
  };
  final promptById = {for (final item in orderedItems) item.itemId: item.prompt};
  final explanationById = {for (final item in orderedItems) item.itemId: item.explanation};

  final attemptIds = quizAttempts.map((a) => a.attemptId).toList();
  final responsesByAttemptId = <String, List<_ItemResponseDetail>>{};
  if (attemptIds.isNotEmpty) {
    final responses =
        await (db.select(db.quizItemResponses)..where((t) => t.attemptId.isIn(attemptIds))).get();
    for (final response in responses) {
      final attemptId = response.attemptId;
      if (attemptId == null) continue;
      responsesByAttemptId
          .putIfAbsent(attemptId, () => [])
          .add(_ItemResponseDetail(
            itemNumber: itemNumberById[response.itemId] ?? 0,
            prompt: promptById[response.itemId] ?? response.itemId ?? 'Unknown item',
            givenAnswer: response.givenAnswer,
            correctAnswer: response.isCorrect
                ? response.givenAnswer
                : (orderedItems
                        .where((item) => item.itemId == response.itemId)
                        .map((item) => item.correctAnswer)
                        .firstOrNull ??
                    '?'),
            isCorrect: response.isCorrect,
            explanation: explanationById[response.itemId],
          ));
    }
    for (final list in responsesByAttemptId.values) {
      list.sort((a, b) => a.itemNumber.compareTo(b.itemNumber));
    }
  }

  return _StudentActivity(
    trials: trials,
    missionAttempts: missionAttempts,
    quizAttempts: quizAttempts,
    responsesByAttemptId: responsesByAttemptId,
  );
});

/// Teacher — Class Roster: student detail. Blueprint §3.3: "tap for
/// individual detail (their trial data, mission attempts, quiz responses)".
class StudentDetailScreen extends ConsumerWidget {
  const StudentDetailScreen({super.key, required this.student});

  final UserRow student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(_studentActivityProvider(student.userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(student.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit student',
            onPressed: () => _showEditDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove student',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: activityAsync.when(
        data: (activity) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (student.officialStudentId != null) Text('ID: ${student.officialStudentId}'),
            if (student.gradeLevel != null || student.strand != null)
              Text('${student.gradeLevel ?? ''} ${student.strand ?? ''}'.trim()),
            const SizedBox(height: 20),
            _SectionHeader('Motion Lab trials (${activity.trials.length})'),
            for (final trial in activity.trials)
              ListTile(
                dense: true,
                title: Text('Trial ${trial.trialNumber}'),
                subtitle: Text(
                  'd=${trial.distanceM}m, Δx=${trial.displacementM}m, t=${trial.timeS}s, '
                  'v=${trial.computedVelocity?.toStringAsFixed(2) ?? '-'} m/s',
                ),
              ),
            const SizedBox(height: 20),
            _SectionHeader('Mission attempts (${activity.missionAttempts.length})'),
            for (final attempt in activity.missionAttempts)
              ListTile(
                dense: true,
                leading: Icon(
                  attempt.isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
                ),
                title: Text('Level attempt #${attempt.attemptNumber}'),
                subtitle: Text('answer: ${attempt.submittedAnswer} · +${attempt.pointsAwarded} pts'),
              ),
            const SizedBox(height: 20),
            _SectionHeader('Quiz attempts (${activity.quizAttempts.length})'),
            for (final attempt in activity.quizAttempts)
              _QuizAttemptTile(
                attempt: attempt,
                responses: activity.responsesByAttemptId[attempt.attemptId] ?? const [],
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController(text: student.displayName);
    final studentIdController = TextEditingController(text: student.officialStudentId ?? '');
    final gradeController = TextEditingController(text: student.gradeLevel ?? '');
    final strandController = TextEditingController(text: student.strand ?? '');
    final sections = await ref.read(classSectionsProvider.future);
    String? selectedSectionId = student.sectionId;

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                TextField(
                  controller: studentIdController,
                  decoration: const InputDecoration(labelText: 'Student ID (LRN / class number)'),
                ),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Grade level'),
                ),
                TextField(
                  controller: strandController,
                  decoration: const InputDecoration(labelText: 'Strand'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue: selectedSectionId,
                  decoration: const InputDecoration(labelText: 'Section'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('No section')),
                    for (final section in sections)
                      DropdownMenuItem(value: section.sectionId, child: Text(section.sectionName)),
                  ],
                  onChanged: (value) => setState(() => selectedSectionId = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                final db = ref.read(appDatabaseProvider);
                await (db.update(db.users)..where((t) => t.userId.equals(student.userId))).write(
                  UsersCompanion(
                    displayName: Value(nameController.text.trim()),
                    officialStudentId: Value(
                      studentIdController.text.trim().isEmpty
                          ? null
                          : studentIdController.text.trim(),
                    ),
                    gradeLevel: Value(
                      gradeController.text.trim().isEmpty ? null : gradeController.text.trim(),
                    ),
                    strand: Value(
                      strandController.text.trim().isEmpty ? null : strandController.text.trim(),
                    ),
                    sectionId: Value(selectedSectionId),
                  ),
                );
                ref.invalidate(rosterStudentsProvider);
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove student?'),
        content: Text(
          'This removes ${student.displayName} from the roster. Their activity records stay '
          'in the database but will no longer be linked to a roster entry.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.users)..where((t) => t.userId.equals(student.userId))).go();
    ref.invalidate(rosterStudentsProvider);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _QuizAttemptTile extends StatelessWidget {
  const _QuizAttemptTile({required this.attempt, required this.responses});

  final QuizAttemptRow attempt;
  final List<_ItemResponseDetail> responses;

  @override
  Widget build(BuildContext context) {
    final title = Text(attempt.completedAt == null ? 'In progress' : 'Completed');
    final subtitle = Text(
      attempt.totalScore == null
          ? 'Not yet scored'
          : 'Score: ${attempt.totalScore}/${attempt.maxScore}'
              '${attempt.attemptType == 'formative' ? '' : ' (${attempt.attemptType})'}',
    );

    if (responses.isEmpty) {
      return ListTile(dense: true, title: title, subtitle: subtitle);
    }

    return ExpansionTile(
      dense: true,
      title: title,
      subtitle: subtitle,
      children: [
        for (final response in responses)
          ListTile(
            dense: true,
            leading: Icon(
              response.isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: response.isCorrect ? Colors.green : Colors.redAccent,
            ),
            title: Text('Q${response.itemNumber}: ${response.prompt}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.isCorrect
                      ? 'Answered ${response.givenAnswer} — correct'
                      : 'Answered ${response.givenAnswer} — correct answer: ${response.correctAnswer}',
                ),
                if (response.explanation != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      response.explanation!,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
