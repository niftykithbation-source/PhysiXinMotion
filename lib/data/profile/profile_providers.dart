import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backup/auto_backup_service.dart';
import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_student_provider.dart';

final totalPointsProvider = FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final student = await ref.watch(currentStudentProvider.future);
  final rows =
      await (db.select(db.pointsLedger)..where((t) => t.userId.equals(student.userId))).get();
  return rows.fold<int>(0, (sum, r) => sum + r.points);
});

final earnedBadgeIdsProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final student = await ref.watch(currentStudentProvider.future);
  final rows =
      await (db.select(db.badgesEarned)..where((t) => t.userId.equals(student.userId))).get();
  return rows.map((r) => r.badgeId).toSet();
});

final allBadgesProvider = FutureProvider.autoDispose<List<BadgeRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.badges).get();
});

final lastBackupAtProvider = FutureProvider.autoDispose<DateTime?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final student = await ref.watch(currentStudentProvider.future);
  return AutoBackupService(db).lastBackupAt(userId: student.userId);
});
