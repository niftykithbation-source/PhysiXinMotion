import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_student_provider.dart';

final missionLevelsProvider = FutureProvider.autoDispose<List<MissionLevelRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.missionLevels)
    ..where((t) => t.packId.equals(kActiveContentPackId))
    ..orderBy([(t) => OrderingTerm.asc(t.levelNumber)]);
  return query.get();
});

/// Whether the current student has a correct attempt on file for [levelId].
final missionLevelSolvedProvider = FutureProvider.autoDispose.family<bool, String>((
  ref,
  levelId,
) async {
  final db = ref.watch(appDatabaseProvider);
  final student = await ref.watch(currentStudentProvider.future);
  final row = await (db.select(db.missionAttempts)
        ..where(
          (t) =>
              t.userId.equals(student.userId) &
              t.levelId.equals(levelId) &
              t.isCorrect.equals(true),
        ))
      .getSingleOrNull();
  return row != null;
});
