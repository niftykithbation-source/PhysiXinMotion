import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/presentation/settings/settings_screen.dart';

/// Blueprint §7 Step 9 item 6: Validator Mode is off by default, and
/// toggling it on in Settings is what surfaces the Validator Checklist —
/// which in turn shows each item's Table-of-Specifications tag.
void main() {
  Future<AppDatabase> seededDb() async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    return db;
  }

  testWidgets(
    'Validator Mode is off by default, and enabling it surfaces the Validator Checklist entry',
    (tester) async {
      final db = await seededDb();
      addTearDown(db.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Validator Mode'), findsOneWidget);
      expect(find.text('Open Validator Checklist'), findsNothing);

      await tester.tap(find.text('Validator Mode'));
      await tester.pumpAndSettle();

      expect(find.text('Open Validator Checklist'), findsOneWidget);
    },
  );

  testWidgets('Validator Checklist shows each item\'s ToS competency tag', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Validator Mode'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Validator Checklist'));
    await tester.pumpAndSettle();

    expect(find.text('Validator Checklist'), findsOneWidget);
    // q1's tos_competency per kinematics_v1.json.
    expect(find.text('differentiate distance from displacement'), findsOneWidget);
  });
}
