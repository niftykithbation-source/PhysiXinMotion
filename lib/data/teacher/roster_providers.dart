import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
