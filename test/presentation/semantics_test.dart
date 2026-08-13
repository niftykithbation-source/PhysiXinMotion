import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/presentation/student/evaluation/evaluation_terminal_screen.dart';
import 'package:physix_in_motion/presentation/student/profile/profile_screen.dart';

/// Blueprint §7 Step 7.2/7.5: spot-checks that a screen reader has
/// something meaningful to announce for the flow's most important
/// controls — the full Engage→Evaluate flow can't be exhaustively
/// simulated without a real screen reader, but Material widgets expose
/// semantics by construction (ListTile/RadioListTile title, InputDecoration
/// labelText, button text), so these checks anchor that construction is
/// actually working as intended, not just assumed.
void main() {
  testWidgets('Evaluation Terminal: each MCQ choice exposes its own text as a semantic '
      'label', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);

    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: EvaluationTerminalScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // q1's choices, per kinematics_v1.json.
    for (final choiceText in ['A. 6 km', 'B. 3 km', 'C. 0 km', 'D. 1.5 km']) {
      expect(
        find.bySemanticsLabel(choiceText),
        findsOneWidget,
        reason: 'Choice "$choiceText" should be reachable by its own text as a semantic label',
      );
    }

    handle.dispose();
  });

  testWidgets('Profile screen: the Settings icon button has a semantic label', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Settings'), findsOneWidget);

    handle.dispose();
  });
}
