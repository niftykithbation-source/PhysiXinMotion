import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';

class ImportValidationException implements Exception {
  final String message;

  const ImportValidationException(this.message);

  @override
  String toString() => 'ImportValidationException: $message';
}

class ImportResult {
  final String studentUserId;
  final String studentDisplayName;
  final int predictionsImported;
  final int trialsImported;
  final int missionAttemptsImported;
  final int quizAttemptsImported;
  final int quizResponsesImported;
  final int pointsLedgerImported;
  final int badgesImported;

  const ImportResult({
    required this.studentUserId,
    required this.studentDisplayName,
    required this.predictionsImported,
    required this.trialsImported,
    required this.missionAttemptsImported,
    required this.quizAttemptsImported,
    required this.quizResponsesImported,
    required this.pointsLedgerImported,
    required this.badgesImported,
  });
}

/// Blueprint §1.3/§7 Step 6: Tier-1 sync. Imports a Tier-1 export bundle
/// (produced by [AutoBackupService.snapshotNow]) into the teacher's local
/// DB — creates/updates the student's roster entry, then upserts every
/// activity row. Upserts (not plain inserts) make re-importing the same
/// bundle safe: no duplicate rows, just refreshed data.
class TeacherImportService {
  final AppDatabase db;

  const TeacherImportService(this.db);

  Future<ImportResult> importBundle(
    String rawJson, {
    required String importedByTeacherId,
  }) async {
    final Map<String, dynamic> payload;
    try {
      payload = jsonDecode(rawJson) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw ImportValidationException('Not a valid JSON file: ${e.message}');
    }

    final userId = payload['user_id'] as String?;
    if (userId == null || userId.isEmpty) {
      throw const ImportValidationException(
        'Missing "user_id" — this doesn\'t look like a PhysiX export bundle.',
      );
    }
    final packId = payload['pack_id'] as String?;
    if (packId == null || packId.isEmpty) {
      throw const ImportValidationException(
        'Missing "pack_id" — this doesn\'t look like a PhysiX export bundle.',
      );
    }

    return db.transaction(() async {
      final studentInfo = payload['student'] as Map<String, dynamic>?;
      final displayName = await _upsertStudent(
        userId: userId,
        importedByTeacherId: importedByTeacherId,
        studentInfo: studentInfo,
      );

      final predictions = await _upsertRows(
        payload['prediction_log'],
        db.predictionLog,
        PredictionLogRow.fromJson,
      );
      final trials = await _upsertRows(
        payload['motion_trials'],
        db.motionTrials,
        MotionTrialRow.fromJson,
      );
      final missionAttempts = await _upsertRows(
        payload['mission_attempts'],
        db.missionAttempts,
        MissionAttemptRow.fromJson,
      );
      final quizAttempts = await _upsertRows(
        payload['quiz_attempts'],
        db.quizAttempts,
        QuizAttemptRow.fromJson,
      );
      final quizResponses = await _upsertRows(
        payload['quiz_item_responses'],
        db.quizItemResponses,
        QuizItemResponseRow.fromJson,
      );
      final pointsLedger = await _upsertRows(
        payload['points_ledger'],
        db.pointsLedger,
        PointsLedgerRow.fromJson,
      );
      final badges = await _upsertRows(
        payload['badges_earned'],
        db.badgesEarned,
        BadgeEarnedRow.fromJson,
      );

      await db.into(db.exportBundles).insert(ExportBundlesCompanion.insert(
            bundleId: const Uuid().v4(),
            userId: Value(userId),
            generatedAt: DateTime.now().millisecondsSinceEpoch,
            payloadJson: rawJson,
            importedByTeacherId: Value(importedByTeacherId),
            importedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ));

      return ImportResult(
        studentUserId: userId,
        studentDisplayName: displayName,
        predictionsImported: predictions,
        trialsImported: trials,
        missionAttemptsImported: missionAttempts,
        quizAttemptsImported: quizAttempts,
        quizResponsesImported: quizResponses,
        pointsLedgerImported: pointsLedger,
        badgesImported: badges,
      );
    });
  }

  Future<String> _upsertStudent({
    required String userId,
    required String importedByTeacherId,
    required Map<String, dynamic>? studentInfo,
  }) async {
    String? sectionId;
    final sectionName = studentInfo?['section_name'] as String?;
    if (sectionName != null && sectionName.isNotEmpty) {
      final existingSection = await (db.select(db.classSections)
            ..where(
              (t) => t.sectionName.equals(sectionName) & t.teacherId.equals(importedByTeacherId),
            ))
          .getSingleOrNull();
      if (existingSection != null) {
        sectionId = existingSection.sectionId;
      } else {
        sectionId = const Uuid().v4();
        await db.into(db.classSections).insert(ClassSectionsCompanion.insert(
              sectionId: sectionId,
              teacherId: Value(importedByTeacherId),
              sectionName: sectionName,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ));
      }
    }

    final displayName = (studentInfo?['display_name'] as String?)?.trim();
    final existing =
        await (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();

    if (existing == null) {
      await db.into(db.users).insert(UsersCompanion.insert(
            userId: userId,
            role: 'student',
            displayName: (displayName == null || displayName.isEmpty)
                ? 'Imported Student'
                : displayName,
            pinHash: '',
            gradeLevel: Value(studentInfo?['grade_level'] as String?),
            strand: Value(studentInfo?['strand'] as String?),
            sectionId: Value(sectionId),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ));
      return (displayName == null || displayName.isEmpty) ? 'Imported Student' : displayName;
    }

    await (db.update(db.users)..where((t) => t.userId.equals(userId))).write(
      UsersCompanion(
        displayName: Value(
          (displayName == null || displayName.isEmpty) ? existing.displayName : displayName,
        ),
        gradeLevel: Value(studentInfo?['grade_level'] as String? ?? existing.gradeLevel),
        strand: Value(studentInfo?['strand'] as String? ?? existing.strand),
        sectionId: Value(sectionId ?? existing.sectionId),
      ),
    );
    return (displayName == null || displayName.isEmpty) ? existing.displayName : displayName;
  }

  Future<int> _upsertRows<T extends Table, TRow extends Insertable<TRow>>(
    dynamic rawList,
    TableInfo<T, TRow> table,
    TRow Function(Map<String, dynamic>) fromJson,
  ) async {
    if (rawList is! List) return 0;
    var count = 0;
    for (final raw in rawList) {
      final row = fromJson(raw as Map<String, dynamic>);
      await db.into(table).insertOnConflictUpdate(row);
      count++;
    }
    return count;
  }
}
