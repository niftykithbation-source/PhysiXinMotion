import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database_provider.dart';
import 'content_importer.dart';

const kinematicsV1AssetPath = 'assets/content/kinematics_v1.json';

/// Runs the Step 2 content import against the bundled kinematics_v1 pack on
/// app startup. Resolves to the seeded quiz_items count (0 if a pack with
/// this pack_id was already imported on a previous launch); throws
/// [ContentValidationException] if the bundled JSON fails Step 2.3
/// validation, which the UI surfaces instead of showing a blank/crashed app.
final contentImportProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rawJson = await rootBundle.loadString(kinematicsV1AssetPath);
  await ContentImporter(db).importIfNeeded(rawJson);
  final quizItemCount = (await db.select(db.quizItems).get()).length;
  debugPrint('PhysiX content import ready: $quizItemCount quiz items seeded.');
  return quizItemCount;
});
