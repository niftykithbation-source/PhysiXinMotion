import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/teacher/reports_export_service.dart';
import '../import/import_screen.dart';

enum _ExportKind { itemLevelCsv, itemLevelJson, responseMatrixCsv }

/// Teacher — Reports/Export. Blueprint §3.3/§7 Step 6. Two independent
/// export shapes for the same underlying quiz_item_responses data:
///  - Item-level (long format, CSV/JSON): one row per student per item —
///    suited to stats software doing item-level/regression-style work.
///  - Response matrix (wide format, CSV): one row per attempt with
///    q1_ans..qN_ans columns — the classic Excel/SPSS response matrix,
///    ready for a manual Cronbach's Alpha or paired t-test in a
///    spreadsheet. Both cover every completed attempt regardless of
///    source (full in-app Evaluation session or QR scan).
class ReportsExportScreen extends ConsumerStatefulWidget {
  const ReportsExportScreen({super.key});

  @override
  ConsumerState<ReportsExportScreen> createState() => _ReportsExportScreenState();
}

class _ReportsExportScreenState extends ConsumerState<ReportsExportScreen> {
  bool _exporting = false;
  int? _rowCount;

  Future<void> _export(_ExportKind kind) async {
    setState(() => _exporting = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final service = ReportsExportService(db);

      final String content;
      final String baseName;
      final String extension;
      final int rowCount;

      switch (kind) {
        case _ExportKind.itemLevelCsv:
        case _ExportKind.itemLevelJson:
          final rows = await service.fetchItemLevelResponses();
          content = kind == _ExportKind.itemLevelCsv ? service.toCsv(rows) : service.toJson(rows);
          baseName = 'item_level_responses';
          extension = kind == _ExportKind.itemLevelCsv ? 'csv' : 'json';
          rowCount = rows.length;
        case _ExportKind.responseMatrixCsv:
          final matrix = await service.fetchResponseMatrix();
          content = service.toResponseMatrixCsv(matrix);
          baseName = 'response_matrix';
          extension = 'csv';
          rowCount = matrix.rows.length;
      }

      final docsDir = await getApplicationDocumentsDirectory();
      final exportsDir = Directory(p.join(docsDir.path, 'exports'));
      await exportsDir.create(recursive: true);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File(p.join(exportsDir.path, '${baseName}_$timestamp.$extension'));
      await file.writeAsString(content);

      if (mounted) setState(() => _rowCount = rowCount);
      // Opens the system share sheet — email, Google Drive, Bluetooth,
      // or any other app the device offers for sending the file to a PC.
      await Share.shareXFiles([XFile(file.path)], text: 'PhysiX in Motion — $baseName');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Export')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Response matrix (Excel-ready)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'One row per completed quiz attempt: student_ID, section, quiz_score, '
                'q1_ans..q10_ans, timestamp. Opens directly in Excel or SPSS for a manual '
                "Cronbach's Alpha or paired t-test.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _exporting ? null : () => _export(_ExportKind.responseMatrixCsv),
                  icon: const Icon(Icons.grid_on_outlined),
                  label: const Text('Export Response Matrix (CSV)'),
                ),
              ),
              const SizedBox(height: 28),
              Text('Item-level responses (long format)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'One row per student per quiz item, with the Table of Specifications '
                'competency and difficulty tag. Suited for item-level analysis, Hake Gain, '
                'and TOS alignment review.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _exporting ? null : () => _export(_ExportKind.itemLevelCsv),
                  icon: const Icon(Icons.table_chart_outlined),
                  label: const Text('Export as CSV'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _exporting ? null : () => _export(_ExportKind.itemLevelJson),
                  icon: const Icon(Icons.data_object),
                  label: const Text('Export as JSON'),
                ),
              ),
              const SizedBox(height: 20),
              if (_exporting) const Center(child: CircularProgressIndicator()),
              if (_rowCount != null && !_exporting)
                Text(
                  'Exported $_rowCount row(s).',
                  style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6)),
                ),
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 12),
              Text('Tier-1 backup (secondary)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                "A full per-student JSON backup — every prediction, trial, mission attempt, "
                "and quiz response — for a cracked screen or a device that never gets "
                'scanned. Students generate it via "Share My Results"; bring it in here.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ImportScreen()),
                  ),
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Import Student Results (.json)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
