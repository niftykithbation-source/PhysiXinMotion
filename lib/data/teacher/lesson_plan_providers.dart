import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_student_provider.dart';

final lessonPlanStagesProvider = FutureProvider.autoDispose<List<LessonStageRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.lessonStages)
    ..where((t) => t.packId.equals(kActiveContentPackId))
    ..orderBy([(t) => OrderingTerm.asc(t.sequenceOrder)]);
  return query.get();
});

/// The active content pack's own metadata (topic name, MELC codes) — shown
/// as a header on the unified Lesson Plan Viewer.
final activeContentPackProvider = FutureProvider.autoDispose<ContentPackRow?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.contentPacks)..where((t) => t.packId.equals(kActiveContentPackId)))
      .getSingleOrNull();
});
