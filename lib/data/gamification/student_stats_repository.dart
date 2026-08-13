import 'package:drift/drift.dart';

import '../../core/gamification/student_stats.dart';
import '../db/database.dart';
import 'module_interaction_tracker.dart';

/// Computes a student's [StudentStats] from the local DB, for the given
/// content pack.
class StudentStatsRepository {
  final AppDatabase db;
  final ModuleInteractionTracker _moduleInteractions;

  StudentStatsRepository(this.db) : _moduleInteractions = ModuleInteractionTracker(db);

  Future<StudentStats> computeStats({required String userId, required String packId}) async {
    return StudentStats(
      missionLevelsCompleted: await _missionLevelsCompleted(userId: userId, packId: packId),
      bestQuizScoreRatioByStage: await _bestQuizScoreRatioByStage(userId: userId, packId: packId),
      moduleViewCounts: await _moduleInteractions.allViewCounts(userId: userId),
    );
  }

  Future<int> _missionLevelsCompleted({required String userId, required String packId}) async {
    final query = db.select(db.missionAttempts).join([
      innerJoin(db.missionLevels, db.missionLevels.levelId.equalsExp(db.missionAttempts.levelId)),
    ])
      ..where(
        db.missionAttempts.userId.equals(userId) &
            db.missionAttempts.isCorrect.equals(true) &
            db.missionLevels.packId.equals(packId),
      );
    final rows = await query.get();
    final levelIds = rows.map((r) => r.readTable(db.missionAttempts).levelId).toSet();
    return levelIds.length;
  }

  Future<Map<String, double>> _bestQuizScoreRatioByStage({
    required String userId,
    required String packId,
  }) async {
    final query = db.select(db.quizItemResponses).join([
      innerJoin(
        db.quizAttempts,
        db.quizAttempts.attemptId.equalsExp(db.quizItemResponses.attemptId),
      ),
      innerJoin(db.quizItems, db.quizItems.itemId.equalsExp(db.quizItemResponses.itemId)),
      innerJoin(db.lessonStages, db.lessonStages.stageId.equalsExp(db.quizItems.stageId)),
    ])
      ..where(
        db.quizAttempts.userId.equals(userId) &
            db.quizAttempts.packId.equals(packId) &
            db.quizAttempts.completedAt.isNotNull(),
      );
    final rows = await query.get();

    // (attemptId, stageName) -> (correctCount, totalCount)
    final tally = <(String, String), (int, int)>{};
    for (final row in rows) {
      final response = row.readTable(db.quizItemResponses);
      final stage = row.readTable(db.lessonStages);
      final key = (response.attemptId!, stage.stageName);
      final current = tally[key] ?? (0, 0);
      tally[key] = (current.$1 + (response.isCorrect ? 1 : 0), current.$2 + 1);
    }

    final bestByStage = <String, double>{};
    for (final entry in tally.entries) {
      final stageName = entry.key.$2;
      final (correct, total) = entry.value;
      final ratio = total == 0 ? 0.0 : correct / total;
      if (ratio > (bestByStage[stageName] ?? 0.0)) {
        bestByStage[stageName] = ratio;
      }
    }
    return bestByStage;
  }
}
