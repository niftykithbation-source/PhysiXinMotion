import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/teacher/roster_providers.dart';
import '../widgets/section_dropdown.dart';
import 'student_detail_screen.dart';

/// Teacher — Class Roster. Blueprint §3.2/§7 Step 6, with multi-section
/// management: the Section Dropdown filters this list (shared with the
/// Dashboard tab via activeSectionIdProvider), and "Manage sections"
/// surfaces every section's school year and Section PIN for handing out
/// to students.
class RosterScreen extends ConsumerWidget {
  const RosterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterAsync = ref.watch(filteredRosterStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Roster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups_outlined),
            tooltip: 'Manage sections',
            onPressed: () => _showManageSectionsSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: const SectionDropdown(),
          ),
          Expanded(
            child: rosterAsync.when(
              data: (roster) => roster.isEmpty
                  ? const Center(child: Text('No students yet. Add one, or import results.'))
                  : ListView.builder(
                      itemCount: roster.length,
                      itemBuilder: (context, index) {
                        final entry = roster[index];
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(entry.user.displayName),
                          subtitle: Text(
                            [
                              if (entry.section != null) entry.section!.sectionName,
                              if (entry.user.officialStudentId != null)
                                'ID: ${entry.user.officialStudentId}',
                              if (entry.user.gradeLevel != null) entry.user.gradeLevel!,
                              if (entry.user.strand != null) entry.user.strand!,
                            ].join(' · ').ifEmpty('No section assigned'),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => StudentDetailScreen(student: entry.user),
                            ),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('$error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context, ref),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Future<void> _showAddStudentDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final studentIdController = TextEditingController();
    final gradeController = TextEditingController(text: 'Grade 11');
    final strandController = TextEditingController(text: 'STEM');
    final sections = await ref.read(classSectionsProvider.future);
    // Pre-select whichever section the Roster tab is currently filtered
    // to, if any — the common case is adding a student while already
    // looking at their section.
    String? selectedSectionId = ref.read(activeSectionIdProvider);
    if (selectedSectionId != null && !sections.any((s) => s.sectionId == selectedSectionId)) {
      selectedSectionId = null;
    }

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Add Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                TextField(
                  controller: studentIdController,
                  decoration: const InputDecoration(labelText: 'Student ID (LRN / class number)'),
                ),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Grade level'),
                ),
                TextField(
                  controller: strandController,
                  decoration: const InputDecoration(labelText: 'Strand'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue: selectedSectionId,
                  decoration: const InputDecoration(labelText: 'Section'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('No section')),
                    for (final section in sections)
                      DropdownMenuItem(value: section.sectionId, child: Text(section.sectionName)),
                  ],
                  onChanged: (value) => setState(() => selectedSectionId = value),
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
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                final db = ref.read(appDatabaseProvider);
                await db.into(db.users).insert(UsersCompanion.insert(
                      userId: const Uuid().v4(),
                      role: 'student',
                      displayName: nameController.text.trim(),
                      pinHash: '',
                      officialStudentId: Value(
                        studentIdController.text.trim().isEmpty
                            ? null
                            : studentIdController.text.trim(),
                      ),
                      gradeLevel: Value(gradeController.text.trim()),
                      strand: Value(strandController.text.trim()),
                      sectionId: Value(selectedSectionId),
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    ));
                ref.invalidate(rosterStudentsProvider);
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showManageSectionsSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => const _ManageSectionsSheet(),
    );
  }
}

class _ManageSectionsSheet extends ConsumerWidget {
  const _ManageSectionsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final sectionsAsync = ref.watch(classSectionsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Class Sections', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          sectionsAsync.when(
            data: (sections) => sections.isEmpty
                ? Text(
                    'No sections yet.',
                    style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6)),
                  )
                : Column(
                    children: [
                      for (final section in sections)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(section.sectionName),
                          subtitle: Text(
                            [
                              if (section.schoolYear != null) section.schoolYear!,
                              if (section.sectionPin != null) 'PIN: ${section.sectionPin}',
                            ].join(' · ').ifEmpty('No school year or PIN set'),
                          ),
                        ),
                    ],
                  ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('$error'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Section'),
              onPressed: () => showAddSectionDialog(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}

extension _StringOrDefault on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
