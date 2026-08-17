import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/presentation/student/motion_lab/motion_lab_screen.dart';

/// Regression coverage for Motion Lab's trial cap — "Walk the Line"'s real
/// structure (blueprint §3.3): minimum 3 trials before advancing, maximum
/// 5, and a student is never required to do all 5. See also
/// stage_progress_repository_test.dart for the stage-unlock side of this
/// same fix.
const _userId = 'test-student';

void main() {
  Future<AppDatabase> seededDbWithTrials(int trialCount) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    await db.into(db.users).insert(UsersCompanion.insert(
          userId: _userId,
          role: 'student',
          displayName: 'Student',
          pinHash: '',
          createdAt: 0,
        ));
    for (var i = 1; i <= trialCount; i++) {
      await db.into(db.motionTrials).insert(MotionTrialsCompanion.insert(
            trialId: const Uuid().v4(),
            userId: const Value(_userId),
            trialNumber: i,
            distanceM: 8.0,
            displacementM: 8.0,
            timeS: 4.0,
            computedSpeed: const Value(2.0),
            computedVelocity: const Value(2.0),
            recordedAt: i,
          ));
    }
    return db;
  }

  Future<void> pumpMotionLab(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        // A real (non-null) callback matters here: MotionLabScreen's Send
        // button is `trials.length >= kMotionLabMinTrials ? callback :
        // null` — with a null callback passed in, onPressed would be null
        // at every trial count, masking whether the >=3 gate is actually
        // being applied.
        child: MaterialApp(home: MotionLabScreen(onSendToGraphVisualizer: () {})),
      ),
    );
    await tester.pumpAndSettle();
  }

  bool addTrialEnabled(WidgetTester tester) =>
      tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Add Trial')).onPressed !=
      null;

  bool sendEnabled(WidgetTester tester) =>
      tester
          .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Send to Graph Visualizer'))
          .onPressed !=
      null;

  for (final count in [0, 1, 2]) {
    testWidgets('Send to Graph Visualizer stays disabled at $count trials (below minimum)',
        (tester) async {
      final db = await seededDbWithTrials(count);
      addTearDown(db.close);
      await pumpMotionLab(tester, db);

      expect(sendEnabled(tester), isFalse);
    });
  }

  testWidgets('Send to Graph Visualizer enables at exactly 3 trials', (tester) async {
    final db = await seededDbWithTrials(3);
    addTearDown(db.close);
    await pumpMotionLab(tester, db);

    expect(sendEnabled(tester), isTrue);
  });

  testWidgets('Add Trial button is disabled once 5 trials exist, with the max-reached note',
      (tester) async {
    final db = await seededDbWithTrials(5);
    addTearDown(db.close);
    await pumpMotionLab(tester, db);

    expect(addTrialEnabled(tester), isFalse);
    expect(find.text('Maximum 5 trials — remove one to add another.'), findsOneWidget);
  });

  testWidgets('Add Trial button is enabled below 5 trials, with no max-reached note',
      (tester) async {
    final db = await seededDbWithTrials(4);
    addTearDown(db.close);
    await pumpMotionLab(tester, db);

    expect(addTrialEnabled(tester), isTrue);
    expect(find.text('Maximum 5 trials — remove one to add another.'), findsNothing);
  });

  testWidgets('removing a trial at the 5-trial cap re-enables Add Trial', (tester) async {
    final db = await seededDbWithTrials(5);
    addTearDown(db.close);
    await pumpMotionLab(tester, db);

    expect(addTrialEnabled(tester), isFalse);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    expect(addTrialEnabled(tester), isTrue);
    expect(find.text('Maximum 5 trials — remove one to add another.'), findsNothing);

    final remaining = await (db.select(db.motionTrials)..where((t) => t.userId.equals(_userId))).get();
    expect(remaining, hasLength(4));
    // Renumbered contiguously (1..4), no gap left by the delete.
    expect(remaining.map((t) => t.trialNumber).toList()..sort(), [1, 2, 3, 4]);
  });
}
