import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';
import '../db/database_provider.dart';

/// This build supports a single implicit local student per device — no PIN
/// gate yet (blueprint §3.2 describes the full role -> PIN -> home flow a
/// multi-student-per-device build would need). Finds the existing student
/// row, or silently creates one on first use.
final currentStudentProvider = FutureProvider<UserRow>((ref) async {
  final db = ref.watch(appDatabaseProvider);

  final existing =
      await (db.select(db.users)..where((t) => t.role.equals('student'))).getSingleOrNull();
  if (existing != null) return existing;

  final userId = const Uuid().v4();
  await db.into(db.users).insert(UsersCompanion.insert(
        userId: userId,
        role: 'student',
        displayName: 'Student',
        pinHash: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
  return (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingle();
});

/// The kinematics_v1 pack_id, used throughout the student portal wherever a
/// screen needs to scope a query to "the currently seeded content pack".
const kActiveContentPackId = 'kinematics_v1';
