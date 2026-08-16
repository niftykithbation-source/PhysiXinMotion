import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';

/// Local, single-device profile-completion gate shown on the Dashboard
/// before any 5E stage becomes reachable (blueprint §3.2's "role -> PIN ->
/// home flow" doesn't include a teacher-validated PIN yet, so this is
/// intentionally NOT a login/authentication mechanism: it's a one-time
/// local self-tagging step so a student's identity travels with their
/// Tier-1 export bundle).
///
/// Stored as two `app_settings` rows (not a schema migration) — this app
/// is single-student-per-device by design (see current_student_provider.dart),
/// so a flat, unkeyed pair of settings rows is sufficient; no need to key
/// by user_id the way per-user settings elsewhere in this file's siblings
/// don't either (ThemeModeController, SimpleGraphicsController, etc.).
class StudentProfile {
  const StudentProfile({required this.sectionPin, required this.studentId});

  /// Free-text section identifier the teacher hands out on paper/verbally
  /// (e.g. "11-STEM-A" or a short code). NOT validated against the
  /// teacher's Class Sections table — that table lives in a separate local
  /// database on the teacher's own device and is never synced live (see
  /// the Teacher Roster Integration notes further down this file). It is
  /// however matched by exact string against ClassSections.section_name
  /// on the teacher's side once imported — see [TeacherImportService] in
  /// lib/data/teacher/teacher_import_service.dart.
  final String sectionPin;

  /// Free-text student ID/number the school already assigns.
  final String studentId;

  bool get isComplete => sectionPin.trim().isNotEmpty && studentId.trim().isNotEmpty;

  static const empty = StudentProfile(sectionPin: '', studentId: '');
}

const _sectionPinKey = 'profile:section_pin';
const _studentIdKey = 'profile:student_id';

final studentProfileProvider = FutureProvider.autoDispose<StudentProfile>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rows = await (db.select(db.appSettings)
        ..where((t) => t.key.isIn(const [_sectionPinKey, _studentIdKey])))
      .get();
  final byKey = {for (final row in rows) row.key: row.value};
  return StudentProfile(
    sectionPin: byKey[_sectionPinKey] ?? '',
    studentId: byKey[_studentIdKey] ?? '',
  );
});

Future<void> saveStudentProfile(
  AppDatabase db, {
  required String sectionPin,
  required String studentId,
}) async {
  await db.into(db.appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: _sectionPinKey, value: sectionPin.trim()),
      );
  await db.into(db.appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: _studentIdKey, value: studentId.trim()),
      );
}
