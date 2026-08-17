import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/presentation/teacher/lesson_plan/lesson_plan_viewer.dart';

/// Regression coverage for a bug where only the Evaluate stage's Answer Key
/// content actually rendered — Engage/Explore/Explain/Elaborate silently
/// showed nothing despite the underlying teacher_answer_key/teacher_solution
/// data being present in both the JSON and the database. One assertion per
/// stage, each checking for text that can only come from that stage's own
/// teacher-only field (not just that the screen didn't throw).
void main() {
  Future<AppDatabase> seededDb() async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    return db;
  }

  Future<void> pumpViewer(WidgetTester tester, AppDatabase db) async {
    // A realistic (narrow) phone width, but very tall — narrow so any
    // width-constraint bug (e.g. a Table collapsing to zero width inside a
    // horizontal scroll view, or a Row overflowing) actually surfaces here
    // instead of being masked by an unrealistically wide test viewport;
    // tall so every stage card is within the ListView's paint/cache extent
    // and actually gets mounted (a short viewport only mounts the first
    // card or two, which would make every other stage's answer-key content
    // look "missing" even when the widget code is fine).
    tester.view.physicalSize = const Size(360, 12000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: LessonPlanViewer()),
      ),
    );
    await tester.pumpAndSettle();

    // Catches layout-constraint bugs (RenderFlex overflow, a Table
    // collapsing to zero width, ...) that don't stop content from being
    // present in the tree but do make it visually broken — exactly the
    // class of bug that shipped here undetected.
    expect(tester.takeException(), isNull);
  }

  testWidgets('Engage shows teacher_answer_key.answer text', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);
    await pumpViewer(tester, db);

    expect(
      find.textContaining('A vehicle taking a longer, winding route can still cover more distance'),
      findsOneWidget,
    );
  });

  testWidgets('Explore shows sample_worked_trials and the Trial 3 teaching_note', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);
    await pumpViewer(tester, db);

    // From sample_worked_trials trial 3's movement column.
    final movementCell = find.text('Walk 8 m forward');
    expect(movementCell, findsOneWidget);
    // A regression guard for the zero-width Table bug: text can be present
    // in the tree while still being laid out one character per line, so
    // assert the cell actually got real horizontal room, not just that the
    // text exists somewhere.
    expect(tester.getSize(movementCell).width, greaterThan(100));
    // The Trial 3 teaching_note callout (zero net velocity, non-zero average speed).
    expect(find.textContaining('Trial 3 is the pedagogically important row'), findsOneWidget);
  });

  testWidgets('Explain shows graph_reading_summary lines', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);
    await pumpViewer(tester, db);

    expect(
      find.textContaining('Displacement-time (d-t) graph: slope = delta_d / delta_t = velocity (v)'),
      findsOneWidget,
    );
  });

  testWidgets('Elaborate shows each mission level teacher_solution given + steps', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);
    await pumpViewer(tester, db);

    expect(find.textContaining('Given: d = 4000 m, t = 400 s'), findsOneWidget);
    expect(find.text('v_avg = 4000 m / 400 s'), findsOneWidget);
    expect(find.textContaining('Given: v0 = 15 m/s, v = 0 m/s, t = 5 s'), findsOneWidget);
    expect(find.text('a = (0 - 15) / 5'), findsOneWidget);
  });

  testWidgets('Evaluate shows teacher_formula alongside explanation (unchanged)', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);
    await pumpViewer(tester, db);

    expect(find.textContaining('Formula: delta_x = x_final - x_initial'), findsOneWidget);
  });
}
