import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';
import '../evaluation/evaluation_providers.dart' show orderQuizItemsByNumber;
import '../session/current_student_provider.dart' show kActiveContentPackId;

class QrIngestException implements Exception {
  final String message;

  const QrIngestException(this.message);

  @override
  String toString() => 'QrIngestException: $message';
}

class QrIngestResult {
  final String studentDisplayName;
  final String sectionName;
  final String quizScore;
  final int? labTrials;
  final int completionPct;

  const QrIngestResult({
    required this.studentDisplayName,
    required this.sectionName,
    required this.quizScore,
    required this.labTrials,
    required this.completionPct,
  });
}

/// Ingests the compressed QR payload produced by the Student Portal's
/// "Show My QR Code" / Evaluate-stage score dialog (see
/// _buildStudentQrPayload in student_home_shell.dart:
/// {userId, studentId, sectionPin, studentName, quizScore, ans, labTrials,
/// completionPct, generatedAt}).
///
/// This is a lighter-weight sibling of [TeacherImportService], which
/// handles the full Tier-1 file bundle — see the Teacher Roster
/// Integration notes near the top of student_home_shell.dart for how the
/// two relate. `ans` is a 10-character string, one letter per quiz item in
/// [orderQuizItemsByNumber] order (e.g. "AABCDABCDA") — compact enough to
/// fit a single QR frame while still carrying real per-item data, so a
/// scan DOES populate quiz_item_responses (unlike a plain summary score),
/// and therefore does feed the Reports/Export item-level analyses
/// (Cronbach's Alpha, most-missed item) and the per-question breakdown on
/// the student detail screen. If `ans` is missing or the wrong length,
/// ingestion falls back to a summary-only quiz_attempts row.
class QrIngestService {
  final AppDatabase db;

  const QrIngestService(this.db);

  Future<QrIngestResult> ingest(String rawPayload, {required String importedByTeacherId}) async {
    final Map<String, dynamic> payload;
    try {
      payload = jsonDecode(rawPayload) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw QrIngestException('Not a valid QR payload: ${e.message}');
    }

    final sectionPin = (payload['sectionPin'] as String?)?.trim();
    if (sectionPin == null || sectionPin.isEmpty) {
      throw const QrIngestException("This QR code doesn't have a Section PIN.");
    }
    final studentId = (payload['studentId'] as String?)?.trim();
    if (studentId == null || studentId.isEmpty) {
      throw const QrIngestException("This QR code doesn't have a Student ID.");
    }

    final section = await (db.select(db.classSections)
          ..where(
            (t) => t.teacherId.equals(importedByTeacherId) & t.sectionPin.equals(sectionPin),
          ))
        .getSingleOrNull();
    if (section == null) {
      throw QrIngestException(
        'No section with PIN "$sectionPin" — add it under Class Roster first.',
      );
    }

    final payloadUserId = (payload['userId'] as String?)?.trim();
    final studentName = (payload['studentName'] as String?)?.trim();
    final quizScore = (payload['quizScore'] as String?) ?? 'Not attempted';
    final ans = payload['ans'] as String?;
    final labTrials = payload['labTrials'] is int ? payload['labTrials'] as int : null;
    final completionPct = payload['completionPct'] is int ? payload['completionPct'] as int : 0;
    final generatedAt = payload['generatedAt'] as String?;

    return db.transaction(() async {
      final student = await _upsertStudent(
        payloadUserId: payloadUserId,
        studentId: studentId,
        studentName: studentName,
        sectionId: section.sectionId,
      );

      await _upsertQuizAttempt(
        userId: student.userId,
        quizScore: quizScore,
        ans: ans,
        generatedAt: generatedAt,
      );

      return QrIngestResult(
        studentDisplayName: student.displayName,
        sectionName: section.sectionName,
        quizScore: quizScore,
        labTrials: labTrials,
        completionPct: completionPct,
      );
    });
  }

  Future<UserRow> _upsertStudent({
    required String? payloadUserId,
    required String studentId,
    required String? studentName,
    required String sectionId,
  }) async {
    // Primary match: the exact userId from the student's own device — the
    // most authoritative key, and the same one TeacherImportService keys
    // its Tier-1 file import on, so a later file import merges cleanly
    // into whatever a QR scan already created here.
    UserRow? existing;
    if (payloadUserId != null && payloadUserId.isNotEmpty) {
      existing = await (db.select(db.users)..where((t) => t.userId.equals(payloadUserId)))
          .getSingleOrNull();
    }

    // Fallback: a roster entry the teacher already created by hand with
    // this official Student ID inside this section (e.g. added via "Add
    // Student" before the first scan ever happened) — link it instead of
    // creating a duplicate. This is the "prevent student name conflicts"
    // guarantee: matching is by ID, never by display name.
    existing ??= await (db.select(db.users)
          ..where(
            (t) =>
                t.officialStudentId.equals(studentId) &
                t.sectionId.equals(sectionId) &
                t.role.equals('student'),
          ))
        .getSingleOrNull();

    if (existing != null) {
      final matchedId = existing.userId;
      final resolvedName = (studentName != null && studentName.isNotEmpty)
          ? studentName
          : existing.displayName;
      await (db.update(db.users)..where((t) => t.userId.equals(matchedId))).write(
        UsersCompanion(
          displayName: Value(resolvedName),
          officialStudentId: Value(studentId),
          sectionId: Value(sectionId),
        ),
      );
      return (db.select(db.users)..where((t) => t.userId.equals(matchedId))).getSingle();
    }

    final newUserId =
        (payloadUserId != null && payloadUserId.isNotEmpty) ? payloadUserId : const Uuid().v4();
    await db.into(db.users).insert(UsersCompanion.insert(
          userId: newUserId,
          role: 'student',
          displayName: (studentName != null && studentName.isNotEmpty)
              ? studentName
              : 'Scanned Student',
          pinHash: '',
          officialStudentId: Value(studentId),
          sectionId: Value(sectionId),
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
    return (db.select(db.users)..where((t) => t.userId.equals(newUserId))).getSingle();
  }

  Future<void> _upsertQuizAttempt({
    required String userId,
    required String quizScore,
    required String? ans,
    required String? generatedAt,
  }) async {
    final parts = quizScore.split('/');
    if (parts.length != 2) return;
    final total = double.tryParse(parts[0].trim());
    final max = double.tryParse(parts[1].trim());
    if (total == null || max == null) return;

    // Deterministic id: re-scanning the same QR frame (same generatedAt)
    // safely upserts in place instead of piling up duplicate attempts.
    final attemptId = 'qr_${userId}_${generatedAt ?? '${total}_$max'}';
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.into(db.quizAttempts).insertOnConflictUpdate(
          QuizAttemptsCompanion.insert(
            attemptId: attemptId,
            userId: Value(userId),
            packId: const Value(kActiveContentPackId),
            attemptType: const Value('formative'),
            startedAt: now,
            completedAt: Value(now),
            totalScore: Value(total),
            maxScore: Value(max),
          ),
        );

    await _upsertItemResponses(attemptId: attemptId, ans: ans, answeredAt: now);
  }

  /// Maps each character of the compressed `ans` string to a quiz item by
  /// position (see [orderQuizItemsByNumber]) and upserts one
  /// quiz_item_responses row per character. Silently does nothing if
  /// `ans` is absent or doesn't match the pack's item count — the summary
  /// quiz_attempts row above still lands either way.
  Future<void> _upsertItemResponses({
    required String attemptId,
    required String? ans,
    required int answeredAt,
  }) async {
    if (ans == null || ans.isEmpty) return;

    final packItems = await (db.select(db.quizItems)
          ..where((t) => t.packId.equals(kActiveContentPackId)))
        .get();
    final orderedItems = orderQuizItemsByNumber(packItems);
    if (ans.length != orderedItems.length) return;

    for (var i = 0; i < orderedItems.length; i++) {
      final item = orderedItems[i];
      final givenAnswer = ans[i];
      final responseId = '${attemptId}_${item.itemId}';
      await db.into(db.quizItemResponses).insertOnConflictUpdate(
            QuizItemResponsesCompanion.insert(
              responseId: responseId,
              attemptId: Value(attemptId),
              itemId: Value(item.itemId),
              givenAnswer: givenAnswer,
              isCorrect: givenAnswer == item.correctAnswer,
              answeredAt: answeredAt,
            ),
          );
    }
  }
}
