import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';
import '../session/stage_progress_repository.dart';

/// Step 5.6 (blueprint §7): on completion of every 5E stage, silently
/// snapshot that student's session data to a local backup file — no user
/// action required. "Share My Results" (Profile & Badges) sends this
/// existing backup rather than assembling one on tap.
///
/// Tracks "the last set of stages we backed up after" per user in
/// app_settings, so any screen can call [checkAndBackupIfStageCompleted]
/// after writing its data without having to know what was complete before.
class AutoBackupService {
  final AppDatabase db;
  final StageProgressRepository _stageProgress;

  AutoBackupService(this.db) : _stageProgress = StageProgressRepository(db);

  static String _lastKnownKey(String userId) => 'backup:completed_stages:$userId';

  Future<void> checkAndBackupIfStageCompleted({
    required String userId,
    required String packId,
  }) async {
    final nowCompleted = await _stageProgress.completedStages(userId: userId, packId: packId);

    final lastKnownRow = await (db.select(db.appSettings)
          ..where((t) => t.key.equals(_lastKnownKey(userId))))
        .getSingleOrNull();
    final lastKnown = lastKnownRow == null
        ? const <String>{}
        : lastKnownRow.value.split(',').where((s) => s.isNotEmpty).toSet();

    if (nowCompleted.difference(lastKnown).isEmpty) return;

    await snapshotNow(userId: userId, packId: packId);

    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _lastKnownKey(userId), value: nowCompleted.join(',')),
        );
  }

  /// Writes a backup unconditionally (used by the periodic check above, and
  /// directly by "Share My Results" per the blueprint's Step 5.6 note).
  Future<File> snapshotNow({required String userId, required String packId}) async {
    final payload = await _buildPayload(userId: userId, packId: packId);
    final payloadJson = jsonEncode(payload);
    final bundleId = const Uuid().v4();

    await db.into(db.exportBundles).insert(ExportBundlesCompanion.insert(
          bundleId: bundleId,
          userId: Value(userId),
          generatedAt: DateTime.now().millisecondsSinceEpoch,
          payloadJson: payloadJson,
        ));

    final docsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(docsDir.path, 'backups'));
    await backupDir.create(recursive: true);
    final file = File(p.join(backupDir.path, 'backup_$bundleId.json'));
    return file.writeAsString(payloadJson);
  }

  /// Most recent export_bundles.generated_at for this user, or null if
  /// none exists yet — drives the ">24h since last export" banner.
  Future<DateTime?> lastBackupAt({required String userId}) async {
    final query = db.select(db.exportBundles)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.generatedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(row.generatedAt);
  }

  Future<Map<String, dynamic>> _buildPayload({
    required String userId,
    required String packId,
  }) async {
    final student =
        await (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
    final section = student?.sectionId == null
        ? null
        : await (db.select(db.classSections)
              ..where((t) => t.sectionId.equals(student!.sectionId!)))
            .getSingleOrNull();

    final predictions =
        await (db.select(db.predictionLog)..where((t) => t.userId.equals(userId))).get();
    final trials = await (db.select(db.motionTrials)..where((t) => t.userId.equals(userId))).get();
    final missionAttempts =
        await (db.select(db.missionAttempts)..where((t) => t.userId.equals(userId))).get();
    final quizAttempts = await (db.select(db.quizAttempts)
          ..where((t) => t.userId.equals(userId) & t.packId.equals(packId)))
        .get();
    final attemptIds = quizAttempts.map((a) => a.attemptId).toList();
    final quizResponses = attemptIds.isEmpty
        ? <QuizItemResponseRow>[]
        : await (db.select(db.quizItemResponses)..where((t) => t.attemptId.isIn(attemptIds))).get();
    final pointsLedger =
        await (db.select(db.pointsLedger)..where((t) => t.userId.equals(userId))).get();
    final badgesEarned =
        await (db.select(db.badgesEarned)..where((t) => t.userId.equals(userId))).get();

    return {
      'user_id': userId,
      'pack_id': packId,
      'generated_at': DateTime.now().toIso8601String(),
      // Student profile — lets an importing teacher's device create/update
      // a meaningful roster entry rather than just an opaque user_id.
      'student': student == null
          ? null
          : {
              'display_name': student.displayName,
              'grade_level': student.gradeLevel,
              'strand': student.strand,
              'section_name': section?.sectionName,
            },
      'prediction_log': predictions.map((r) => r.toJson()).toList(),
      'motion_trials': trials.map((r) => r.toJson()).toList(),
      'mission_attempts': missionAttempts.map((r) => r.toJson()).toList(),
      'quiz_attempts': quizAttempts.map((r) => r.toJson()).toList(),
      'quiz_item_responses': quizResponses.map((r) => r.toJson()).toList(),
      'points_ledger': pointsLedger.map((r) => r.toJson()).toList(),
      'badges_earned': badgesEarned.map((r) => r.toJson()).toList(),
    };
  }
}
