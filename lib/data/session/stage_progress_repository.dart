import 'package:drift/drift.dart';

import '../db/database.dart';
import '../gamification/module_interaction_tracker.dart';

/// The 5E stage names, in order — matches lesson_stages.stage_name's CHECK
/// constraint and drives the shared progress-pip indicator.
const kFiveEStages = ['engage', 'explore', 'explain', 'elaborate', 'evaluate'];

/// "Walk the Line"'s real structure (blueprint §3.3): a student must record
/// at least this many trials before Explore is complete / Explain unlocks.
const kMotionLabMinTrials = 3;

/// Upper bound on how many trials Motion Lab accepts — beyond
/// [kMotionLabMinTrials], more trials are allowed but never required.
const kMotionLabMaxTrials = 5;

/// Determines which 5E stages a student has completed, for the progress
/// pips shown on Student Portal screens and for Step 5.6's
/// completion-triggered auto-backup. Each stage's "complete" signal is the
/// most direct evidence the current schema offers for that stage:
/// - engage: a prediction_log row exists for this pack's engage stage
/// - explore: at least [kMotionLabMinTrials] motion_trials rows exist (not
///   pack-scoped in the schema, so this is per-user rather than per-pack)
///   — matches "Walk the Line"'s real structure (blueprint §3.3): 3
///   trials required, up to 5 allowed but never required, and completion
///   triggers the moment the 3rd lands, not before and not held back
///   waiting for a 4th/5th. Monotonic in trial count, so a student who
///   goes on to record a 4th or 5th trial after unlocking Explain stays
///   unlocked — this never re-evaluates to false once true.
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

    final trials = await (db.select(db.motionTrials)..where((t) => t.userId.equals(userId))).get();
    if (trials.length >= kMotionLabMinTrials) completed.add('explore');

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
