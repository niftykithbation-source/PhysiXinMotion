import 'package:drift/drift.dart';

import '../db/database.dart';
import '../session/current_student_provider.dart' show kActiveContentPackId;
import '../session/stage_progress_repository.dart';

class QuizItemMissRate {
  final String itemId;
  final String prompt;
  final int missCount;
  final int totalResponses;

  const QuizItemMissRate({
    required this.itemId,
    required this.prompt,
    required this.missCount,
    required this.totalResponses,
  });

  double get missRate => totalResponses == 0 ? 0 : missCount / totalResponses;
}

class DashboardMetrics {
  /// Average (posttest ratio - pretest ratio) across students with both a
  /// completed pretest and posttest attempt. Null if no such pair exists
  /// yet in the roster's data.
  final double? avgPrePostDelta;

  /// Fraction (0-1) of roster students who have completed each 5E stage.
  final Map<String, double> stageCompletionRates;

  /// The quiz item with the highest miss rate across the whole roster, or
  /// null if no quiz responses exist yet.
  final QuizItemMissRate? mostMissedItem;

  final int studentCount;

  const DashboardMetrics({
    required this.avgPrePostDelta,
    required this.stageCompletionRates,
    required this.mostMissedItem,
    required this.studentCount,
  });
}

/// Blueprint §3.3/§7 Step 6: the Teacher Dashboard's class-wide summary
/// cards, computed across every student currently in the roster.
class DashboardRepository {
  final AppDatabase db;
  final StageProgressRepository _stageProgress;

  DashboardRepository(this.db) : _stageProgress = StageProgressRepository(db);

  Future<DashboardMetrics> computeMetrics() async {
    final students =
        await (db.select(db.users)..where((t) => t.role.equals('student'))).get();

    final avgDelta = await _avgPrePostDelta(students.map((s) => s.userId).toList());
    final stageCompletion = await _stageCompletionRates(students.map((s) => s.userId).toList());
    final mostMissed = await _mostMissedItem(students.map((s) => s.userId).toList());

    return DashboardMetrics(
      avgPrePostDelta: avgDelta,
      stageCompletionRates: stageCompletion,
      mostMissedItem: mostMissed,
      studentCount: students.length,
    );
  }

  Future<double?> _avgPrePostDelta(List<String> studentIds) async {
    if (studentIds.isEmpty) return null;

    final deltas = <double>[];
    for (final studentId in studentIds) {
      final attempts = await (db.select(db.quizAttempts)
            ..where(
              (t) =>
                  t.userId.equals(studentId) &
                  t.packId.equals(kActiveContentPackId) &
                  t.completedAt.isNotNull(),
            ))
          .get();

      final pretest = _bestRatio(attempts.where((a) => a.attemptType == 'pretest'));
      final posttest = _bestRatio(attempts.where((a) => a.attemptType == 'posttest'));
      if (pretest != null && posttest != null) {
        deltas.add(posttest - pretest);
      }
    }

    if (deltas.isEmpty) return null;
    return deltas.reduce((a, b) => a + b) / deltas.length;
  }

  double? _bestRatio(Iterable<QuizAttemptRow> attempts) {
    double? best;
    for (final attempt in attempts) {
      final total = attempt.totalScore;
      final max = attempt.maxScore;
      if (total == null || max == null || max == 0) continue;
      final ratio = total / max;
      if (best == null || ratio > best) best = ratio;
    }
    return best;
  }

  Future<Map<String, double>> _stageCompletionRates(List<String> studentIds) async {
    if (studentIds.isEmpty) {
      return {for (final stage in kFiveEStages) stage: 0.0};
    }

    final counts = {for (final stage in kFiveEStages) stage: 0};
    for (final studentId in studentIds) {
      final completed = await _stageProgress.completedStages(
        userId: studentId,
        packId: kActiveContentPackId,
      );
      for (final stage in completed) {
        counts[stage] = (counts[stage] ?? 0) + 1;
      }
    }

    return {
      for (final entry in counts.entries) entry.key: entry.value / studentIds.length,
    };
  }

  Future<QuizItemMissRate?> _mostMissedItem(List<String> studentIds) async {
    if (studentIds.isEmpty) return null;

    final query = db.select(db.quizItemResponses).join([
      innerJoin(
        db.quizAttempts,
        db.quizAttempts.attemptId.equalsExp(db.quizItemResponses.attemptId),
      ),
      innerJoin(db.quizItems, db.quizItems.itemId.equalsExp(db.quizItemResponses.itemId)),
    ])
      ..where(db.quizAttempts.userId.isIn(studentIds));
    final rows = await query.get();
    if (rows.isEmpty) return null;

    final tally = <String, (String prompt, int miss, int total)>{};
    for (final row in rows) {
      final response = row.readTable(db.quizItemResponses);
      final item = row.readTable(db.quizItems);
      final current = tally[item.itemId] ?? (item.prompt, 0, 0);
      tally[item.itemId] = (
        current.$1,
        current.$2 + (response.isCorrect ? 0 : 1),
        current.$3 + 1,
      );
    }

    MapEntry<String, (String, int, int)>? worst;
    for (final entry in tally.entries) {
      if (worst == null) {
        worst = entry;
        continue;
      }
      final entryRate = entry.value.$2 / entry.value.$3;
      final worstRate = worst.value.$2 / worst.value.$3;
      if (entryRate > worstRate || (entryRate == worstRate && entry.value.$2 > worst.value.$2)) {
        worst = entry;
      }
    }

    if (worst == null) return null;
    return QuizItemMissRate(
      itemId: worst.key,
      prompt: worst.value.$1,
      missCount: worst.value.$2,
      totalResponses: worst.value.$3,
    );
  }
}
