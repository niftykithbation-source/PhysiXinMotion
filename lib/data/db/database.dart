import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Users,
  ClassSections,
  ContentPacks,
  LessonStages,
  QuizItems,
  MissionLevels,
  PredictionLog,
  MotionTrials,
  MissionAttempts,
  QuizAttempts,
  QuizItemResponses,
  Badges,
  BadgesEarned,
  PointsLedger,
  ExportBundles,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v1 -> v2: Teacher Portal multi-section management (nullable,
          // additive columns only — see tables.dart).
          if (from < 2) {
            await m.addColumn(users, users.officialStudentId);
            await m.addColumn(classSections, classSections.schoolYear);
            await m.addColumn(classSections, classSections.sectionPin);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'physix_in_motion.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
