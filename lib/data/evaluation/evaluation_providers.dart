import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/database_provider.dart';
import '../session/current_student_provider.dart';

final _trailingNumber = RegExp(r'(\d+)$');

/// This pack's quiz_items, ordered q1..q10 by the numeric suffix of
/// item_id (quiz_items has no explicit sequence column in the schema, only
/// lesson_stages does).
final activeQuizItemsProvider = FutureProvider.autoDispose<List<QuizItemRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final items =
      await (db.select(db.quizItems)..where((t) => t.packId.equals(kActiveContentPackId))).get();
  items.sort((a, b) {
    final aNum = int.tryParse(_trailingNumber.firstMatch(a.itemId)?.group(1) ?? '');
    final bNum = int.tryParse(_trailingNumber.firstMatch(b.itemId)?.group(1) ?? '');
    if (aNum != null && bNum != null) return aNum.compareTo(bNum);
    return a.itemId.compareTo(b.itemId);
  });
  return items;
});
