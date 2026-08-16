import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database_provider.dart';
import '../../../data/session/current_teacher_provider.dart';
import '../../../data/teacher/roster_providers.dart';

/// Shared "active section" filter for the Dashboard and Class Roster tabs
/// (multi-section requirement). Selecting "All sections" clears
/// [activeSectionIdProvider]; the trailing "+" opens [showAddSectionDialog]
/// — the single Add Section entry point used everywhere in the app.
class SectionDropdown extends ConsumerWidget {
  const SectionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(classSectionsProvider);
    final activeSectionId = ref.watch(activeSectionIdProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: sectionsAsync.when(
            data: (sections) {
              // A previously-selected section can disappear (e.g. deleted
              // elsewhere); fall back to "All sections" rather than crash
              // the dropdown on an unknown value.
              final validIds = sections.map((s) => s.sectionId).toSet();
              final value = activeSectionId != null && validIds.contains(activeSectionId)
                  ? activeSectionId
                  : null;
              return DropdownButtonFormField<String?>(
                initialValue: value,
                decoration: const InputDecoration(labelText: 'Section', isDense: true),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All sections')),
                  for (final section in sections)
                    DropdownMenuItem(value: section.sectionId, child: Text(section.sectionName)),
                ],
                onChanged: (newValue) => ref.read(activeSectionIdProvider.notifier).state =
                    newValue,
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text('$error'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add section',
          onPressed: () => showAddSectionDialog(context, ref),
        ),
      ],
    );
  }
}

/// "Add Section" modal: name, school year, and a custom Section PIN
/// (handed out to students so their own device's local profile / QR
/// export self-tags into this section — see student_profile_provider.dart
/// and qr_ingest_service.dart).
Future<void> showAddSectionDialog(BuildContext context, WidgetRef ref) async {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final pinController = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      var saving = false;
      return StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Add Section'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Section name (e.g. STEM 11-A)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(labelText: 'School year (e.g. 2025-2026)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pinController,
                  decoration: const InputDecoration(labelText: 'Section PIN (given to students)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;
                      setState(() => saving = true);

                      final db = ref.read(appDatabaseProvider);
                      final teacher = await ref.read(currentTeacherProvider.future);
                      await createClassSection(
                        db,
                        teacherId: teacher.userId,
                        sectionName: name,
                        schoolYear: yearController.text.trim().isEmpty
                            ? null
                            : yearController.text.trim(),
                        sectionPin: pinController.text.trim().isEmpty
                            ? null
                            : pinController.text.trim(),
                      );
                      ref.invalidate(classSectionsProvider);
                      if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                    },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    },
  );
}
