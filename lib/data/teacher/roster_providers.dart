import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_teacher_provider.dart';

class RosterStudent {
  final UserRow user;
  final ClassSectionRow? section;

  const RosterStudent({required this.user, this.section});
}

final rosterStudentsProvider = FutureProvider.autoDispose<List<RosterStudent>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final students =
      await (db.select(db.users)..where((t) => t.role.equals('student'))).get();

  final result = <RosterStudent>[];
  for (final student in students) {
    ClassSectionRow? section;
    if (student.sectionId != null) {
      section = await (db.select(db.classSections)
            ..where((t) => t.sectionId.equals(student.sectionId!)))
          .getSingleOrNull();
    }
    result.add(RosterStudent(user: student, section: section));
  }
  result.sort((a, b) => a.user.displayName.compareTo(b.user.displayName));
  return result;
});

final classSectionsProvider = FutureProvider.autoDispose<List<ClassSectionRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final teacher = await ref.watch(currentTeacherProvider.future);
  final query = db.select(db.classSections)
    ..where((t) => t.teacherId.equals(teacher.userId))
    ..orderBy([(t) => OrderingTerm.asc(t.sectionName)]);
  return query.get();
});

/// The section the Dashboard/Class Roster tabs are currently filtered to.
/// Null means "All sections". Shared across tabs (not shell-local state)
/// so switching sections on one tab is reflected on the other — see
/// SectionDropdown in lib/presentation/teacher/widgets/section_dropdown.dart.
final activeSectionIdProvider = StateProvider<String?>((ref) => null);

/// [rosterStudentsProvider] narrowed to [activeSectionIdProvider], or the
/// full roster when "All sections" is selected.
final filteredRosterStudentsProvider = Provider.autoDispose<AsyncValue<List<RosterStudent>>>((
  ref,
) {
  final roster = ref.watch(rosterStudentsProvider);
  final activeSectionId = ref.watch(activeSectionIdProvider);
  if (activeSectionId == null) return roster;
  return roster.whenData(
    (students) => students.where((s) => s.section?.sectionId == activeSectionId).toList(),
  );
});

/// Creates a new class section — see the "Add Section" modal in
/// section_dropdown.dart. [sectionPin] is the code handed out to students
/// so their own device's local profile / QR export can self-tag into this
/// section (see student_profile_provider.dart); it is plain text, not a
/// login credential.
Future<void> createClassSection(
  AppDatabase db, {
  required String teacherId,
  required String sectionName,
  String? schoolYear,
  String? sectionPin,
}) async {
  await db.into(db.classSections).insert(ClassSectionsCompanion.insert(
        sectionId: const Uuid().v4(),
        teacherId: Value(teacherId),
        sectionName: sectionName,
        schoolYear: Value(schoolYear),
        sectionPin: Value(sectionPin),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
}
