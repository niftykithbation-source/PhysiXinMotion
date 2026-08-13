import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/database.dart';

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
}
