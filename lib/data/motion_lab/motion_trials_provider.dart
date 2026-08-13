import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_student_provider.dart';

/// The current student's motion_trials, ordered by trial_number. Shared by
/// Motion Lab (writes trials) and Graph Visualizer (reads them read-only,
/// per blueprint §7 Step 5.3).
final studentMotionTrialsProvider = FutureProvider.autoDispose<List<MotionTrialRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final student = await ref.watch(currentStudentProvider.future);
  final query = db.select(db.motionTrials)
    ..where((t) => t.userId.equals(student.userId))
    ..orderBy([(t) => OrderingTerm.asc(t.trialNumber)]);
  return query.get();
});
