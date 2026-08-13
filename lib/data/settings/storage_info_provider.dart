import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Size on disk of the local SQLite DB (the bulk of this app's offline
/// storage), for Settings' About section.
final offlineStorageBytesProvider = FutureProvider.autoDispose<int>((ref) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(docsDir.path, 'physix_in_motion.sqlite'));
  if (!await dbFile.exists()) return 0;
  return dbFile.length();
});

String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(1)} MB';
}
