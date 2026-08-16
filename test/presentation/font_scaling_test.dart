import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/presentation/role_select/role_select_screen.dart';
import 'package:physix_in_motion/presentation/settings/settings_screen.dart';
import 'package:physix_in_motion/presentation/student/evaluation/evaluation_terminal_screen.dart';
import 'package:physix_in_motion/presentation/student/graph_visualizer/graph_visualizer_screen.dart';
import 'package:physix_in_motion/presentation/student/mission_mode/mission_mode_screen.dart';
import 'package:physix_in_motion/presentation/student/motion_lab/motion_lab_screen.dart';
import 'package:physix_in_motion/presentation/student/profile/profile_screen.dart';
import 'package:physix_in_motion/presentation/student/trip_tracker/trip_tracker_screen.dart';
import 'package:physix_in_motion/presentation/teacher/dashboard/dashboard_screen.dart';
import 'package:physix_in_motion/presentation/teacher/lesson_plan/lesson_plan_viewer.dart';
import 'package:physix_in_motion/presentation/teacher/reports/reports_export_screen.dart';
import 'package:physix_in_motion/presentation/teacher/roster/roster_screen.dart';
import 'package:physix_in_motion/presentation/validator/validator_checklist_screen.dart';

/// Blueprint §7 Step 7.1: "Run through every screen with system font
/// scaling at 200% — nothing should clip or overlap." A Flutter RenderFlex
/// overflow reports a FlutterError during layout, which flutter_test
/// surfaces as a failed test rather than a silently-passing one — so a
/// green run here is real evidence, not just "it didn't crash".
void main() {
  Future<AppDatabase> seededDb() async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    return db;
  }

  Future<void> pumpAt200Percent(WidgetTester tester, AppDatabase db, Widget screen) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2.0)),
            child: child!,
          ),
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final screens = <String, Widget Function()>{
    'RoleSelectScreen': () => const RoleSelectScreen(),
    'TripTrackerScreen': () => const TripTrackerScreen(),
    'MotionLabScreen': () => const MotionLabScreen(),
    'GraphVisualizerScreen': () => const GraphVisualizerScreen(),
    'MissionModeScreen': () => const MissionModeScreen(),
    'EvaluationTerminalScreen': () => const EvaluationTerminalScreen(),
    'ProfileScreen': () => const ProfileScreen(),
    'SettingsScreen': () => const SettingsScreen(),
    'Teacher DashboardScreen': () => const DashboardScreen(),
    'Teacher RosterScreen': () => const RosterScreen(),
    'Teacher LessonPlanViewer': () => const LessonPlanViewer(),
    'Teacher ReportsExportScreen': () => const ReportsExportScreen(),
    'ValidatorChecklistScreen': () => const ValidatorChecklistScreen(),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key} has no layout overflow at 200% text scale', (tester) async {
      final db = await seededDb();
      addTearDown(db.close);

      await pumpAt200Percent(tester, db, entry.value());

      expect(tester.takeException(), isNull);
    });
  }
}
