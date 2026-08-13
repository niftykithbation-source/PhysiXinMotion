import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_student_provider.dart';

/// Fetches a lesson_stages row for the active content pack by its
/// stage_name ('engage', 'explore', 'explain', 'elaborate', 'evaluate').
/// Every stage screen reads its scenario/content from here rather than
/// hardcoding copy (CLAUDE.md: "Content is JSON, not hardcoded").
final lessonStageByNameProvider = FutureProvider.family<LessonStageRow, String>((
  ref,
  stageName,
) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.lessonStages)
        ..where((t) => t.packId.equals(kActiveContentPackId) & t.stageName.equals(stageName)))
      .getSingle();
});
