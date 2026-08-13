import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/teacher/roster_providers.dart';

class _StudentActivity {
  final List<MotionTrialRow> trials;
  final List<MissionAttemptRow> missionAttempts;
  final List<QuizAttemptRow> quizAttempts;

  const _StudentActivity({
    required this.trials,
    required this.missionAttempts,
    required this.quizAttempts,
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
  return _StudentActivity(
    trials: trials,
    missionAttempts: missionAttempts,
    quizAttempts: quizAttempts,
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
              ListTile(
                dense: true,
                title: Text(attempt.completedAt == null ? 'In progress' : 'Completed'),
                subtitle: Text(
                  attempt.totalScore == null
                      ? 'Not yet scored'
                      : 'Score: ${attempt.totalScore}/${attempt.maxScore}',
                ),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
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
