import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../evaluation/evaluation_providers.dart' show orderQuizItemsByNumber;
import '../session/current_student_provider.dart' show kActiveContentPackId;

class ItemLevelResponseRow {
  final String studentId;
  final String studentName;
  final String? section;
  final String itemId;
  final String prompt;
  final String? difficulty;
  final String? tosCompetency;
  final String givenAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String? attemptType;
  final int answeredAt;

  const ItemLevelResponseRow({
    required this.studentId,
    required this.studentName,
    required this.section,
    required this.itemId,
    required this.prompt,
    required this.difficulty,
    required this.tosCompetency,
    required this.givenAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.attemptType,
    required this.answeredAt,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'student_name': studentName,
        'section': section,
        'item_id': itemId,
        'prompt': prompt,
        'difficulty': difficulty,
        'tos_competency': tosCompetency,
        'given_answer': givenAnswer,
        'correct_answer': correctAnswer,
        'is_correct': isCorrect,
        'attempt_type': attemptType,
        'answered_at': DateTime.fromMillisecondsSinceEpoch(answeredAt).toIso8601String(),
      };
}

/// One row per completed quiz attempt, with answers spread across
/// positional q1_ans..qN_ans columns instead of one row per response —
/// the classic "response matrix" shape (student x item) that Excel/SPSS
/// users and manual Cronbach's-Alpha-by-formula work expect, and what the
/// Teacher Portal's CSV export produces (see [ReportsExportService.
/// fetchResponseMatrix] / [ReportsExportService.toResponseMatrixCsv]).
class ResponseMatrixRow {
  final String studentId;
  final String? section;
  final String quizScore;
  final List<String?> answers;
  final String timestamp;

  const ResponseMatrixRow({
    required this.studentId,
    required this.section,
    required this.quizScore,
    required this.answers,
    required this.timestamp,
  });
}

class ResponseMatrix {
  /// Number of q{n}_ans columns — the active pack's item count
  /// (orderQuizItemsByNumber), regardless of whether any rows exist yet.
  final int questionCount;
  final List<ResponseMatrixRow> rows;

  const ResponseMatrix({required this.questionCount, required this.rows});
}

/// Blueprint §3.3/§7 Step 6: "raw CSV/JSON export for research stats" —
/// item-level responses across the whole roster, shaped for a
/// Table-of-Specifications-aligned pre/post analysis, Cronbach's Alpha, and
/// Hake Gain (each needs per-item, per-student correct/incorrect data, not
/// just aggregate scores).
class ReportsExportService {
  final AppDatabase db;

  const ReportsExportService(this.db);

  Future<List<ItemLevelResponseRow>> fetchItemLevelResponses() async {
    final query = db.select(db.quizItemResponses).join([
      innerJoin(
        db.quizAttempts,
        db.quizAttempts.attemptId.equalsExp(db.quizItemResponses.attemptId),
      ),
      innerJoin(db.quizItems, db.quizItems.itemId.equalsExp(db.quizItemResponses.itemId)),
      innerJoin(db.users, db.users.userId.equalsExp(db.quizAttempts.userId)),
      leftOuterJoin(db.classSections, db.classSections.sectionId.equalsExp(db.users.sectionId)),
    ])
      ..orderBy([OrderingTerm.asc(db.quizItemResponses.answeredAt)]);

    final rows = await query.get();
    return rows.map((row) {
      final response = row.readTable(db.quizItemResponses);
      final attempt = row.readTable(db.quizAttempts);
      final item = row.readTable(db.quizItems);
      final student = row.readTable(db.users);
      final section = row.readTableOrNull(db.classSections);

      return ItemLevelResponseRow(
        studentId: student.userId,
        studentName: student.displayName,
        section: section?.sectionName,
        itemId: item.itemId,
        prompt: item.prompt,
        difficulty: item.difficulty,
        tosCompetency: item.tosCompetency,
        givenAnswer: response.givenAnswer,
        correctAnswer: item.correctAnswer,
        isCorrect: response.isCorrect,
        attemptType: attempt.attemptType,
        answeredAt: response.answeredAt,
      );
    }).toList();
  }

  String toJson(List<ItemLevelResponseRow> rows) {
    return jsonEncode(rows.map((r) => r.toJson()).toList());
  }

  String toCsv(List<ItemLevelResponseRow> rows) {
    final buffer = StringBuffer();
    const headers = [
      'student_id',
      'student_name',
      'section',
      'item_id',
      'prompt',
      'difficulty',
      'tos_competency',
      'given_answer',
      'correct_answer',
      'is_correct',
      'attempt_type',
      'answered_at',
    ];
    buffer.writeln(headers.join(','));

    for (final row in rows) {
      final json = row.toJson();
      buffer.writeln(headers.map((h) => _csvField(json[h])).join(','));
    }
    return buffer.toString();
  }

  String _csvField(dynamic value) {
    final text = value?.toString() ?? '';
    if (text.contains(',') || text.contains('"') || text.contains('\n')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }

  /// One row per completed quiz attempt across the whole roster (both
  /// full in-app Evaluation sessions and QR-scanned attempts — see
  /// QrIngestService), with per-item answers spread across q1_ans..qN_ans
  /// columns. Excel-ready CSV via [toResponseMatrixCsv].
  Future<ResponseMatrix> fetchResponseMatrix() async {
    final orderedItems = orderQuizItemsByNumber(
      await (db.select(db.quizItems)..where((t) => t.packId.equals(kActiveContentPackId))).get(),
    );

    final attempts = await (db.select(db.quizAttempts)
          ..where((t) => t.packId.equals(kActiveContentPackId) & t.completedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.asc(t.completedAt)]))
        .get();

    final rows = <ResponseMatrixRow>[];
    for (final attempt in attempts) {
      final userId = attempt.userId;
      if (userId == null) continue;
      final student =
          await (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingleOrNull();
      if (student == null) continue;
      final section = student.sectionId == null
          ? null
          : await (db.select(db.classSections)
                ..where((t) => t.sectionId.equals(student.sectionId!)))
              .getSingleOrNull();

      final responses = await (db.select(db.quizItemResponses)
            ..where((t) => t.attemptId.equals(attempt.attemptId)))
          .get();
      final byItemId = {for (final r in responses) r.itemId: r.givenAnswer};
      final answers = orderedItems.map((item) => byItemId[item.itemId]).toList();

      rows.add(ResponseMatrixRow(
        studentId: student.officialStudentId ?? student.userId,
        section: section?.sectionName,
        quizScore: (attempt.totalScore == null || attempt.maxScore == null)
            ? ''
            : '${attempt.totalScore!.toInt()}/${attempt.maxScore!.toInt()}',
        answers: answers,
        timestamp: attempt.completedAt == null
            ? ''
            : DateTime.fromMillisecondsSinceEpoch(attempt.completedAt!).toIso8601String(),
      ));
    }

    return ResponseMatrix(questionCount: orderedItems.length, rows: rows);
  }

  /// Headers: student_ID, section, quiz_score, q1_ans..qN_ans, timestamp.
  String toResponseMatrixCsv(ResponseMatrix matrix) {
    final headers = [
      'student_ID',
      'section',
      'quiz_score',
      for (var i = 1; i <= matrix.questionCount; i++) 'q${i}_ans',
      'timestamp',
    ];
    final buffer = StringBuffer()..writeln(headers.join(','));

    for (final row in matrix.rows) {
      final fields = [
        row.studentId,
        row.section ?? '',
        row.quizScore,
        for (var i = 0; i < matrix.questionCount; i++)
          (i < row.answers.length ? row.answers[i] : null) ?? '',
        row.timestamp,
      ];
      buffer.writeln(fields.map(_csvField).join(','));
    }
    return buffer.toString();
  }
}
