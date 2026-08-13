import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/theme/app_theme.dart';
import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/data/settings/app_settings_provider.dart';
import 'package:physix_in_motion/presentation/settings/settings_screen.dart';

/// Blueprint §7 Step 7: "Verify the dark/light/match-device Settings toggle
/// switches without requiring an app restart." Mirrors main.dart's
/// MaterialApp(themeMode: ref.watch(themeModeControllerProvider)) wiring, so
/// a pass here is evidence the same mechanism used in the real app updates
/// the live widget tree in place — no tester.pumpWidget() re-call (which
/// would simulate a fresh app start) happens between the toggle tap and the
/// assertion.
class _ThemedApp extends ConsumerWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const SettingsScreen(),
    );
  }
}

void main() {
  testWidgets(
    'toggling Appearance in Settings updates the live theme immediately, without a restart',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
      await ContentImporter(db).importIfNeeded(rawJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const _ThemedApp(),
        ),
      );
      await tester.pumpAndSettle();

      Brightness currentBrightness() =>
          Theme.of(tester.element(find.byType(Scaffold).first)).brightness;

      // Starts on ThemeMode.system; force to Light first for a known baseline.
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(currentBrightness(), Brightness.light);

      // Switch to Dark — same widget tree, same test, no pumpWidget() re-call.
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(
        currentBrightness(),
        Brightness.dark,
        reason: 'Dark mode should apply immediately to the live tree, not require a restart',
      );

      // Switch back to Light again, confirming the toggle works both ways in place.
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(currentBrightness(), Brightness.light);
    },
  );
}
