import 'package:drift/drift.dart';

import '../db/database.dart';
import '../gamification/module_interaction_tracker.dart';

/// The 5E stage names, in order — matches lesson_stages.stage_name's CHECK
/// constraint and drives the shared progress-pip indicator.
const kFiveEStages = ['engage', 'explore', 'explain', 'elaborate', 'evaluate'];

/// Determines which 5E stages a student has completed, for the progress
/// pips shown on Student Portal screens and for Step 5.6's
/// completion-triggered auto-backup. Each stage's "complete" signal is the
/// most direct evidence the current schema offers for that stage:
/// - engage: a prediction_log row exists for this pack's engage stage
/// - explore: at least one motion_trials row exists (not pack-scoped in
///   the schema, so this is per-user rather than per-pack)
/// - explain: Graph Visualizer has been opened at least once
///   (module_interaction_tracker — see Step 4's flagged schema gap)
/// - elaborate: a correct mission_attempts row exists for both mission
///   levels in this pack
/// - evaluate: a completed quiz_attempts row exists for this pack
class StageProgressRepository {
  final AppDatabase db;
  final ModuleInteractionTracker _moduleInteractions;

  StageProgressRepository(this.db) : _moduleInteractions = ModuleInteractionTracker(db);

  Future<Set<String>> completedStages({required String userId, required String packId}) async {
    final completed = <String>{};

    final engageStage = await (db.select(db.lessonStages)
          ..where((t) => t.packId.equals(packId) & t.stageName.equals('engage')))
        .getSingleOrNull();
    if (engageStage != null) {
      final prediction = await (db.select(db.predictionLog)
            ..where((t) => t.userId.equals(userId) & t.stageId.equals(engageStage.stageId))
            ..limit(1))
          .getSingleOrNull();
      if (prediction != null) completed.add('engage');
    }

    final anyTrial = await (db.select(db.motionTrials)
          ..where((t) => t.userId.equals(userId))
          ..limit(1))
        .getSingleOrNull();
    if (anyTrial != null) completed.add('explore');

    final graphViews =
        await _moduleInteractions.viewCount(userId: userId, moduleKey: 'graph_visualizer');
    if (graphViews > 0) completed.add('explain');

    final missionQuery = db.select(db.missionAttempts).join([
      innerJoin(db.missionLevels, db.missionLevels.levelId.equalsExp(db.missionAttempts.levelId)),
    ])
      ..where(
        db.missionAttempts.userId.equals(userId) &
            db.missionAttempts.isCorrect.equals(true) &
            db.missionLevels.packId.equals(packId),
      );
    final missionRows = await missionQuery.get();
    final correctLevelIds = missionRows.map((r) => r.readTable(db.missionAttempts).levelId).toSet();
    final totalLevels =
        await (db.select(db.missionLevels)..where((t) => t.packId.equals(packId))).get();
    if (totalLevels.isNotEmpty && correctLevelIds.length >= totalLevels.length) {
      completed.add('elaborate');
    }

    final completedQuiz = await (db.select(db.quizAttempts)
          ..where(
            (t) =>
                t.userId.equals(userId) & t.packId.equals(packId) & t.completedAt.isNotNull(),
          )
          ..limit(1))
        .getSingleOrNull();
    if (completedQuiz != null) completed.add('evaluate');

    return completed;
  }
}
