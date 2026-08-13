import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/gamification/points_calculator.dart';
import '../db/database.dart';

/// Blueprint §7 Step 4.2: "points ledger writer triggered on
/// mission_attempts and quiz_attempts completion".
class PointsLedgerWriter {
  final AppDatabase db;

  const PointsLedgerWriter(this.db);

  Future<int> writeForMissionAttempt(MissionAttemptRow attempt) async {
    final points = pointsForMissionAttempt(
      isCorrect: attempt.isCorrect,
      attemptNumber: attempt.attemptNumber,
    );
    await db.into(db.pointsLedger).insert(PointsLedgerCompanion.insert(
          entryId: const Uuid().v4(),
          userId: Value(attempt.userId),
          sourceType: 'mission_attempt',
          sourceId: Value(attempt.attemptId),
          points: points,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
    return points;
  }

  Future<int> writeForQuizAttempt(QuizAttemptRow attempt) async {
    final responses = await (db.select(db.quizItemResponses)
          ..where((t) => t.attemptId.equals(attempt.attemptId)))
        .get();
    final correctCount = responses.where((r) => r.isCorrect).length;
    final points = pointsForQuizAttempt(correctCount: correctCount);
    await db.into(db.pointsLedger).insert(PointsLedgerCompanion.insert(
          entryId: const Uuid().v4(),
          userId: Value(attempt.userId),
          sourceType: 'quiz_attempt',
          sourceId: Value(attempt.attemptId),
          points: points,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
    return points;
  }
}
