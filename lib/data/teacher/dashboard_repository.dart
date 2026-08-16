import 'package:drift/drift.dart';

import '../db/database.dart';
import '../evaluation/evaluation_providers.dart' show orderQuizItemsByNumber;
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

  /// Average best-attempt score ratio (0-1) across every student with at
  /// least one completed quiz attempt — the class-wide overall average,
  /// including QR-scanned summary attempts (see QrIngestService). Null if
  /// no student has a completed attempt yet.
  final double? avgQuizScorePct;

  /// Fraction (0-1) of roster students who have completed each 5E stage.
  final Map<String, double> stageCompletionRates;

  /// The quiz item with the highest miss rate across the whole roster, or
  /// null if no quiz responses exist yet. Derived from [itemDifficultyRates].
  final QuizItemMissRate? mostMissedItem;

  /// Every quiz item's miss rate, in q1..q10 order — "auto-flagged
  /// most-missed items for re-teaching" at the per-item level, not just
  /// the single worst one. Empty if no quiz_item_responses exist yet.
  /// Updates automatically after a QR scan writes new responses (see
  /// QrIngestService), since this is recomputed fresh on every
  /// [computeMetrics] call.
  final List<QuizItemMissRate> itemDifficultyRates;

  final int studentCount;

  const DashboardMetrics({
    required this.avgPrePostDelta,
    required this.avgQuizScorePct,
    required this.stageCompletionRates,
    required this.mostMissedItem,
    required this.itemDifficultyRates,
    required this.studentCount,
  });
}

/// Blueprint §3.3/§7 Step 6: the Teacher Dashboard's class-wide summary
/// cards, computed across every student currently in the roster.
class DashboardRepository {
  final AppDatabase db;
  final StageProgressRepository _stageProgress;

  DashboardRepository(this.db) : _stageProgress = StageProgressRepository(db);

  /// [sectionId] narrows every metric to that section's roster only; null
  /// computes class-wide metrics across the whole roster ("All sections").
  Future<DashboardMetrics> computeMetrics({String? sectionId}) async {
    final query = db.select(db.users)..where((t) => t.role.equals('student'));
    if (sectionId != null) {
      query.where((t) => t.sectionId.equals(sectionId));
    }
    final students = await query.get();
    final studentIds = students.map((s) => s.userId).toList();

    final avgDelta = await _avgPrePostDelta(studentIds);
    final avgQuizScore = await _avgQuizScorePct(studentIds);
    final stageCompletion = await _stageCompletionRates(studentIds);
    final itemRates = await itemDifficultyRates(studentIds);
    final mostMissed = _worstOf(itemRates);

    return DashboardMetrics(
      avgPrePostDelta: avgDelta,
      avgQuizScorePct: avgQuizScore,
      stageCompletionRates: stageCompletion,
      mostMissedItem: mostMissed,
      itemDifficultyRates: itemRates,
      studentCount: students.length,
    );
  }

  /// Average of each student's best completed-attempt ratio — the
  /// headline "class average" card, deliberately not limited to
  /// pretest/posttest attempts (unlike [_avgPrePostDelta]) so it also
  /// reflects formative and QR-scanned attempts.
  Future<double?> _avgQuizScorePct(List<String> studentIds) async {
    if (studentIds.isEmpty) return null;

    final ratios = <double>[];
    for (final studentId in studentIds) {
      final attempts = await (db.select(db.quizAttempts)
            ..where((t) => t.userId.equals(studentId) & t.completedAt.isNotNull()))
          .get();
      final best = _bestRatio(attempts);
      if (best != null) ratios.add(best);
    }

    if (ratios.isEmpty) return null;
    return ratios.reduce((a, b) => a + b) / ratios.length;
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

  /// Every active-pack quiz item's miss rate across [studentIds], in
  /// q1..q10 order — items with zero responses so far still appear, with
  /// missCount/totalResponses both 0. Recomputed fresh on every call (no
  /// caching), so a QR scan that adds quiz_item_responses is reflected the
  /// next time the Dashboard reads this (via ref.invalidate(
  /// rosterStudentsProvider), which _dashboardMetricsProvider watches).
  Future<List<QuizItemMissRate>> itemDifficultyRates(List<String> studentIds) async {
    final orderedItems = orderQuizItemsByNumber(
      await (db.select(db.quizItems)..where((t) => t.packId.equals(kActiveContentPackId))).get(),
    );
    if (studentIds.isEmpty) {
      return [
        for (final item in orderedItems)
          QuizItemMissRate(itemId: item.itemId, prompt: item.prompt, missCount: 0, totalResponses: 0),
      ];
    }

    final query = db.select(db.quizItemResponses).join([
      innerJoin(
        db.quizAttempts,
        db.quizAttempts.attemptId.equalsExp(db.quizItemResponses.attemptId),
      ),
    ])
      ..where(db.quizAttempts.userId.isIn(studentIds));
    final rows = await query.get();

    final missCounts = <String, int>{};
    final totalCounts = <String, int>{};
    for (final row in rows) {
      final response = row.readTable(db.quizItemResponses);
      final itemId = response.itemId;
      if (itemId == null) continue;
      totalCounts[itemId] = (totalCounts[itemId] ?? 0) + 1;
      if (!response.isCorrect) missCounts[itemId] = (missCounts[itemId] ?? 0) + 1;
    }

    return [
      for (final item in orderedItems)
        QuizItemMissRate(
          itemId: item.itemId,
          prompt: item.prompt,
          missCount: missCounts[item.itemId] ?? 0,
          totalResponses: totalCounts[item.itemId] ?? 0,
        ),
    ];
  }

  QuizItemMissRate? _worstOf(List<QuizItemMissRate> rates) {
    QuizItemMissRate? worst;
    for (final rate in rates) {
      if (rate.totalResponses == 0) continue;
      if (worst == null ||
          rate.missRate > worst.missRate ||
          (rate.missRate == worst.missRate && rate.missCount > worst.missCount)) {
        worst = rate;
      }
    }
    return worst;
  }
}
