import 'package:drift/drift.dart';

import '../db/database.dart';

/// Tracks per-student, per-module interaction counts (e.g. "opened Graph
/// Visualizer") using the generic `app_settings` key-value table, since the
/// locked §5 schema has no dedicated interaction-log table. This is the
/// real signal `StudentStatsRepository.moduleViewCounts` needed — until a
/// screen calls [recordView], that map stays empty and any
/// `module_interaction` badge rule (e.g. Graph Reader) can never unlock.
class ModuleInteractionTracker {
  final AppDatabase db;

  const ModuleInteractionTracker(this.db);

  static String _prefix(String userId) => 'module_views:$userId:';
  static String _key(String userId, String moduleKey) => '${_prefix(userId)}$moduleKey';

  Future<int> recordView({required String userId, required String moduleKey}) async {
    final key = _key(userId, moduleKey);
    final current = await viewCount(userId: userId, moduleKey: moduleKey);
    final next = current + 1;
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: '$next'),
        );
    return next;
  }

  Future<int> viewCount({required String userId, required String moduleKey}) async {
    final row = await (db.select(db.appSettings)
          ..where((t) => t.key.equals(_key(userId, moduleKey))))
        .getSingleOrNull();
    return row == null ? 0 : (int.tryParse(row.value) ?? 0);
  }

  Future<Map<String, int>> allViewCounts({required String userId}) async {
    final prefix = _prefix(userId);
    final rows = await (db.select(db.appSettings)..where((t) => t.key.like('$prefix%'))).get();
    return {
      for (final row in rows) row.key.substring(prefix.length): int.tryParse(row.value) ?? 0,
    };
  }
}
