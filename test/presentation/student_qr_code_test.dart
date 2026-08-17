import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/db/database_provider.dart';
import 'package:physix_in_motion/data/session/student_profile_provider.dart';
import 'package:physix_in_motion/presentation/student/student_home_shell.dart';

/// Regression coverage for a real-device scan-reliability test that found
/// this app's original QR sizes (160/200px) rendered under ~0.5mm/module
/// on a real 440dpi phone — too dense to scan reliably screen-to-screen.
///
/// Only the Dashboard's "Show My QR Code" dialog is driven live here — the
/// automatic post-Evaluate popup renders the exact same [_StudentQrCode]
/// widget (see student_home_shell.dart), which no longer takes a `size`
/// parameter at all after this fix: it always uses [kStudentQrDisplaySize]
/// internally. That makes it a compile-time impossibility, not just a
/// runtime one, for the two dialogs to ever use different sizes again —
/// a stronger guarantee than re-deriving the same assertion through a
/// second, much harder to reliably drive live-UI path (completing a full
/// 10-question quiz end-to-end through IndexedStack-nested widget state).
void main() {
  Future<AppDatabase> seededDb() async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
    await saveStudentProfile(db, sectionPin: 'STEM11-A', studentId: 'S-001');
    return db;
  }

  Future<void> pumpShell(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: StudentHomeShell()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Show My QR Code dialog renders at least kStudentQrDisplaySize', (tester) async {
    final db = await seededDb();
    addTearDown(db.close);
    await pumpShell(tester, db);

    // StudentHomeShell's IndexedStack keeps all 6 tab screens mounted at
    // once (each with its own Scrollable), and the Dashboard's stat-tile
    // GridView nests a second Scrollable inside the outer ListView even
    // though its NeverScrollableScrollPhysics disables actual scrolling —
    // so scrollUntilVisible's default scrollable lookup is ambiguous two
    // ways over. `.first` resolves to the outer ListView's own Scrollable,
    // since find.byType visits ancestors before descendants.
    final qrButtonFinder = find.byKey(const Key('showMyQrCodeButton'));
    await tester.scrollUntilVisible(
      qrButtonFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(qrButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(qrButtonFinder);
    await tester.pumpAndSettle();

    final qrFinder = find.byType(QrImageView);
    expect(qrFinder, findsOneWidget);
    final qr = tester.widget<QrImageView>(qrFinder);
    expect(qr.size, greaterThanOrEqualTo(kStudentQrDisplaySize));
  });

  test('kStudentQrDisplaySize is at least 220 (the measured-safe floor)', () {
    expect(kStudentQrDisplaySize, greaterThanOrEqualTo(220.0));
  });
}
