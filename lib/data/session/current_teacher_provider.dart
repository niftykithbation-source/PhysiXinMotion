import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../db/database.dart';
import '../db/database_provider.dart';

/// This build supports a single implicit local teacher per device, mirroring
/// [currentStudentProvider] — no PIN gate yet. Finds the existing teacher
/// row, or silently creates one on first use.
final currentTeacherProvider = FutureProvider<UserRow>((ref) async {
  final db = ref.watch(appDatabaseProvider);

  final existing =
      await (db.select(db.users)..where((t) => t.role.equals('teacher'))).getSingleOrNull();
  if (existing != null) return existing;

  final userId = const Uuid().v4();
  await db.into(db.users).insert(UsersCompanion.insert(
        userId: userId,
        role: 'teacher',
        displayName: 'Teacher',
        pinHash: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
  return (db.select(db.users)..where((t) => t.userId.equals(userId))).getSingle();
});
