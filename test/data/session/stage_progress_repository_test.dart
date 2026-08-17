import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/session/stage_progress_repository.dart';

/// Regression coverage for a bug where Explore was marked complete (and
/// Stage 3 unlocked) after just 1 motion_trials row, not the 3 "Walk the
/// Line" actually requires (blueprint §3.3 — matches the teacher answer
/// key's 3 sample trials, and up to 5 allowed but never required).
void main() {
  late AppDatabase db;
  const userId = 'student-1';
  const packId = 'kinematics_v1';

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    await db.into(db.users).insert(UsersCompanion.insert(
          userId: userId,
          role: 'student',
          displayName: 'Student',
          pinHash: '',
          createdAt: 0,
        ));
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addTrials(int count, {int startingAt = 1}) async {
    for (var i = 0; i < count; i++) {
      final trialNumber = startingAt + i;
      await db.into(db.motionTrials).insert(MotionTrialsCompanion.insert(
            trialId: const Uuid().v4(),
            userId: const Value(userId),
            trialNumber: trialNumber,
            distanceM: 8.0,
            displacementM: 8.0,
            timeS: 4.0,
            computedSpeed: const Value(2.0),
            computedVelocity: const Value(2.0),
            recordedAt: trialNumber,
          ));
    }
  }

  test('kMotionLabMinTrials is 3 and kMotionLabMaxTrials is 5', () {
    expect(kMotionLabMinTrials, 3);
    expect(kMotionLabMaxTrials, 5);
  });

  test('explore is NOT complete at 1 trial', () async {
    await addTrials(1);
    final completed = await StageProgressRepository(db).completedStages(userId: userId, packId: packId);
    expect(completed.contains('explore'), isFalse);
  });

  test('explore is NOT complete at 2 trials', () async {
    await addTrials(2);
    final completed = await StageProgressRepository(db).completedStages(userId: userId, packId: packId);
    expect(completed.contains('explore'), isFalse);
  });

  test('explore IS complete at exactly 3 trials', () async {
    await addTrials(3);
    final completed = await StageProgressRepository(db).completedStages(userId: userId, packId: packId);
    expect(completed.contains('explore'), isTrue);
  });

  test('a 4th and 5th trial after unlocking does not re-lock or block explore', () async {
    await addTrials(3);
    final afterThree =
        await StageProgressRepository(db).completedStages(userId: userId, packId: packId);
    expect(afterThree.contains('explore'), isTrue);

    await addTrials(2, startingAt: 4); // trials 4 and 5
    final afterFive =
        await StageProgressRepository(db).completedStages(userId: userId, packId: packId);
    expect(afterFive.contains('explore'), isTrue);
  });
}
