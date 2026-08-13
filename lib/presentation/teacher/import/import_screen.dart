import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/session/current_teacher_provider.dart';
import '../../../data/teacher/roster_providers.dart';
import '../../../data/teacher/teacher_import_service.dart';

/// Teacher — "Import Student Results" (Tier-1 sync entry point). Blueprint
/// §1.3/§3.3/§7 Step 6.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  bool _importing = false;
  ImportResult? _lastResult;
  String? _error;

  Future<void> _pickAndImport() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = picked?.files.singleOrNull?.path;
    if (path == null) return;

    setState(() {
      _importing = true;
      _error = null;
    });

    try {
      final rawJson = await File(path).readAsString();
      final db = ref.read(appDatabaseProvider);
      final teacher = await ref.read(currentTeacherProvider.future);
      final result = await TeacherImportService(db).importBundle(
        rawJson,
        importedByTeacherId: teacher.userId,
      );
      ref.invalidate(rosterStudentsProvider);
      ref.invalidate(classSectionsProvider);
      if (mounted) setState(() => _lastResult = result);
    } on ImportValidationException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Import Student Results')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PhysiX in Motion is fully offline, so students share their results as a file '
                '(via "Share My Results" in Profile & Badges) — by Bluetooth, email, USB, or any '
                'app they choose. Once that file is on this device, select it here to bring the '
                'student\'s data into your roster and dashboard.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _importing ? null : _pickAndImport,
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(_importing ? 'Importing…' : 'Select export file (.json)'),
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_error!)),
                    ],
                  ),
                ),
              if (_lastResult != null) _ImportResultCard(result: _lastResult!),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportResultCard extends StatelessWidget {
  const _ImportResultCard({required this.result});

  final ImportResult result;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: colors.secondaryAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Imported ${result.studentDisplayName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${result.predictionsImported} predictions · ${result.trialsImported} trials · '
            '${result.missionAttemptsImported} mission attempts · '
            '${result.quizAttemptsImported} quiz attempts · '
            '${result.quizResponsesImported} quiz responses · '
            '${result.pointsLedgerImported} points entries · '
            '${result.badgesImported} badges',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
