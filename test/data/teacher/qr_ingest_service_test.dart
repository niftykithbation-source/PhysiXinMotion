import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/teacher/qr_ingest_service.dart';

/// Regression coverage for dropping `studentName` from the QR payload
/// (see student_home_shell.dart's payload builder) — the display name must
/// now resolve from whatever roster entry already matches the scan's
/// studentId/userId, never from the payload itself (which no longer
/// carries one).
void main() {
  late AppDatabase db;
  const teacherId = 'teacher-1';
  const sectionId = 'section-1';

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    await db.into(db.classSections).insert(ClassSectionsCompanion.insert(
          sectionId: sectionId,
          teacherId: const Value(teacherId),
          sectionName: 'STEM 11-A',
          sectionPin: const Value('STEM11-A'),
          createdAt: 0,
        ));
  });

  tearDown(() async {
    await db.close();
  });

  String payloadWithoutName({required String studentId, String? userId}) => jsonEncode({
        // ignore: use_null_aware_elements
        if (userId != null) 'userId': userId,
        'studentId': studentId,
        'sectionPin': 'STEM11-A',
        'quizScore': '8/10',
        'ans': 'CCCCBBCBAA',
        'labTrials': 5,
        'completionPct': 100,
        'generatedAt': '2026-08-17T12:00:00.000',
      });

  test('resolves the display name from an existing roster entry, does not overwrite it', () async {
    await db.into(db.users).insert(UsersCompanion.insert(
          userId: 'roster-user-1',
          role: 'student',
          displayName: 'Jane Dela Cruz',
          pinHash: '',
          officialStudentId: const Value('S-100'),
          sectionId: const Value(sectionId),
          createdAt: 0,
        ));

    final result = await QrIngestService(db).ingest(
      payloadWithoutName(studentId: 'S-100'),
      importedByTeacherId: teacherId,
    );

    expect(result.studentDisplayName, 'Jane Dela Cruz');
    final row = await (db.select(db.users)..where((t) => t.userId.equals('roster-user-1'))).getSingle();
    expect(row.displayName, 'Jane Dela Cruz');
  });

  test('resolves the display name via userId match even if studentId differs from roster', () async {
    await db.into(db.users).insert(UsersCompanion.insert(
          userId: 'device-user-42',
          role: 'student',
          displayName: 'Mark Santos',
          pinHash: '',
          createdAt: 0,
        ));

    final result = await QrIngestService(db).ingest(
      payloadWithoutName(studentId: 'S-200', userId: 'device-user-42'),
      importedByTeacherId: teacherId,
    );

    expect(result.studentDisplayName, 'Mark Santos');
  });

  test('falls back to a generic placeholder for a student never seen before', () async {
    final result = await QrIngestService(db).ingest(
      payloadWithoutName(studentId: 'S-999'),
      importedByTeacherId: teacherId,
    );

    expect(result.studentDisplayName, 'Scanned Student (S-999)');
  });

  test('still populates real per-item quiz_item_responses from ans (unaffected by the name change)',
      () async {
    await QrIngestService(db).ingest(
      payloadWithoutName(studentId: 'S-300'),
      importedByTeacherId: teacherId,
    );

    final responses = await db.select(db.quizItemResponses).get();
    expect(responses, hasLength(10));
  });
}
