import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';

const _tourSeenKey = 'teacher_portal:tour_seen';

const _steps = [
  (
    icon: Icons.dashboard_outlined,
    title: 'Dashboard',
    body: 'See class-wide progress at a glance: average pre/post score change, how far each '
        '5E stage has been completed, and the item most students are missing.',
  ),
  (
    icon: Icons.groups_outlined,
    title: 'Class Roster',
    body: 'Add students by hand, or bring in results a student shared from their own device '
        'via "Import Student Results". Tap any student for their full activity detail.',
  ),
  (
    icon: Icons.menu_book_outlined,
    title: 'Lesson Plan',
    body: 'The 5E lesson plan, read-only — with "Open in app" on every stage so you can jump '
        'straight into the matching student screen for a live classroom demo.',
  ),
  (
    icon: Icons.ios_share,
    title: 'Reports & Export',
    body: 'Export every item-level response across the roster as CSV or JSON — ready for '
        'pre/post analysis, Cronbach\'s Alpha, or Hake Gain.',
  ),
];

/// Blueprint §7 Step 6: "Include a 3-4 step first-run guided tour."
Future<void> maybeShowTeacherGuidedTour(BuildContext context, WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  final seen =
      await (db.select(db.appSettings)..where((t) => t.key.equals(_tourSeenKey)))
          .getSingleOrNull();
  if (seen != null) return;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => const _TourDialog(),
  );

  await db.into(db.appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: _tourSeenKey, value: 'true'),
      );
}

class _TourDialog extends StatefulWidget {
  const _TourDialog();

  @override
  State<_TourDialog> createState() => _TourDialogState();
}

class _TourDialogState extends State<_TourDialog> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final step = _steps[_index];

    return AlertDialog(
      title: Row(
        children: [
          Icon(step.icon, color: colors.primaryAccent),
          const SizedBox(width: 12),
          Expanded(child: Text(step.title)),
        ],
      ),
      content: Text(step.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_index < _steps.length - 1) {
              setState(() => _index++);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(_index < _steps.length - 1 ? 'Next' : 'Done'),
        ),
      ],
    );
  }
}
