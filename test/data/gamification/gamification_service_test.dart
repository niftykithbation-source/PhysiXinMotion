import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/gamification/points_calculator.dart';
import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/gamification/gamification_service.dart';

/// Acceptance test for Step 4's "done when" (blueprint §7 Step 4.3):
/// "completing both Mission Mode levels + scoring >=80% on Evaluation
/// Terminal unlocks the two badges defined in the seeded content pack."
///
/// Step 5 (the screens that actually write mission_attempts/quiz_attempts
/// from user interaction) doesn't exist yet, so this simulates what those
/// screens will do — insert the same rows a real playthrough would — and
/// drives the engine exactly as a future screen will: call
/// GamificationService right after each row is written.
void main() {
  late AppDatabase db;
  late GamificationService gamification;
  const packId = 'kinematics_v1';
  const userId = 'test-user-1';

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    gamification = GamificationService(db);

    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);

    await db.into(db.users).insert(UsersCompanion.insert(
          userId: userId,
          role: 'student',
          displayName: 'Test Student',
          pinHash: 'test-hash',
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
  });

  tearDown(() async {
    await db.close();
  });

  Future<MissionAttemptRow> recordMissionAttempt({
    required String levelId,
    required double submittedAnswer,
  }) async {
    return db.into(db.missionAttempts).insertReturning(MissionAttemptsCompanion.insert(
          attemptId: 'attempt-$levelId',
          userId: const Value(userId),
          levelId: Value(levelId),
          submittedAnswer: submittedAnswer,
          isCorrect: true,
          attemptNumber: 1,
          submittedAt: DateTime.now().millisecondsSinceEpoch,
        ));
  }

  Future<QuizAttemptRow> recordQuizAttempt({required int correctCount}) async {
    final attempt = await db.into(db.quizAttempts).insertReturning(
          QuizAttemptsCompanion.insert(
            attemptId: 'quiz-attempt-1',
            userId: const Value(userId),
            packId: const Value(packId),
            startedAt: DateTime.now().millisecondsSinceEpoch,
            completedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    for (var i = 1; i <= 10; i++) {
      await db.into(db.quizItemResponses).insert(QuizItemResponsesCompanion.insert(
            responseId: 'response-$i',
            attemptId: Value(attempt.attemptId),
            itemId: Value('kinematics_v1_q$i'),
            givenAnswer: 'A',
            isCorrect: i <= correctCount,
            answeredAt: DateTime.now().millisecondsSinceEpoch,
          ));
    }

    return attempt;
  }

  test('completing both mission levels unlocks Motion Master (and only after the 2nd)', () async {
    final attempt1 = await recordMissionAttempt(
      levelId: 'kinematics_v1_level_1',
      submittedAnswer: 10.0,
    );
    final outcome1 = await gamification.onMissionAttemptRecorded(attempt1);
    expect(outcome1.newlyUnlockedBadges, isEmpty);
    expect(outcome1.pointsAwarded, kPointsForFirstTryMissionCorrect);

    final attempt2 = await recordMissionAttempt(
      levelId: 'kinematics_v1_level_2',
      submittedAnswer: -3.0,
    );
    final outcome2 = await gamification.onMissionAttemptRecorded(attempt2);
    expect(outcome2.newlyUnlockedBadges.map((b) => b.badgeId), contains('motion_master'));
    expect(outcome2.pointsAwarded, kPointsForFirstTryMissionCorrect);

    final ledgerEntries = await db.select(db.pointsLedger).get();
    expect(ledgerEntries, hasLength(2));
    expect(
      ledgerEntries.every((e) => e.points == kPointsForFirstTryMissionCorrect),
      isTrue,
    );

    final earned = await (db.select(db.badgesEarned)..where((t) => t.userId.equals(userId))).get();
    expect(earned.map((e) => e.badgeId), contains('motion_master'));
  });

  test('scoring >=80% on the Evaluation Terminal unlocks Vector Voyager', () async {
    final attempt = await recordQuizAttempt(correctCount: 9); // 9/10 = 0.9
    final outcome = await gamification.onQuizAttemptCompleted(attempt);

    expect(outcome.newlyUnlockedBadges.map((b) => b.badgeId), contains('vector_voyager'));
    expect(outcome.pointsAwarded, 9 * kPointsPerCorrectQuizItem);

    final ledgerEntries = await db.select(db.pointsLedger).get();
    expect(ledgerEntries, hasLength(1));
    expect(ledgerEntries.single.points, 9 * kPointsPerCorrectQuizItem);
  });

  test('scoring below 80% does NOT unlock Vector Voyager', () async {
    final attempt = await recordQuizAttempt(correctCount: 7); // 7/10 = 0.7
    final outcome = await gamification.onQuizAttemptCompleted(attempt);

    expect(outcome.newlyUnlockedBadges.map((b) => b.badgeId), isNot(contains('vector_voyager')));

    final earned = await (db.select(db.badgesEarned)..where((t) => t.userId.equals(userId))).get();
    expect(earned, isEmpty);
  });

  test('re-checking an already-earned badge does not award it twice', () async {
    final attempt = await recordQuizAttempt(correctCount: 10);
    await gamification.onQuizAttemptCompleted(attempt);

    // Simulate a second, unrelated quiz_attempts completion for the same
    // user+pack — badge re-evaluation must not duplicate badges_earned.
    final secondAttempt = await db.into(db.quizAttempts).insertReturning(
          QuizAttemptsCompanion.insert(
            attemptId: 'quiz-attempt-2',
            userId: const Value(userId),
            packId: const Value(packId),
            startedAt: DateTime.now().millisecondsSinceEpoch,
            completedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    final secondOutcome = await gamification.onQuizAttemptCompleted(secondAttempt);

    expect(secondOutcome.newlyUnlockedBadges, isEmpty);

    final earned = await (db.select(db.badgesEarned)..where((t) => t.userId.equals(userId))).get();
    expect(earned.where((e) => e.badgeId == 'vector_voyager'), hasLength(1));
  });
}
