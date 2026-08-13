import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/teacher/reports_export_service.dart';

/// Teacher — Reports/Export. Blueprint §3.3/§7 Step 6.
class ReportsExportScreen extends ConsumerStatefulWidget {
  const ReportsExportScreen({super.key});

  @override
  ConsumerState<ReportsExportScreen> createState() => _ReportsExportScreenState();
}

class _ReportsExportScreenState extends ConsumerState<ReportsExportScreen> {
  bool _exporting = false;
  int? _rowCount;

  Future<void> _export({required bool asCsv}) async {
    setState(() => _exporting = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final service = ReportsExportService(db);
      final rows = await service.fetchItemLevelResponses();
      final content = asCsv ? service.toCsv(rows) : service.toJson(rows);
      final extension = asCsv ? 'csv' : 'json';

      final docsDir = await getApplicationDocumentsDirectory();
      final exportsDir = Directory(p.join(docsDir.path, 'exports'));
      await exportsDir.create(recursive: true);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File(p.join(exportsDir.path, 'item_level_responses_$timestamp.$extension'));
      await file.writeAsString(content);

      if (mounted) setState(() => _rowCount = rows.length);
      await Share.shareXFiles([XFile(file.path)], text: 'PhysiX in Motion — item-level responses');
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
              Text(
                'Raw item-level responses across the whole roster — one row per student per '
                'quiz item, with the Table of Specifications competency and difficulty tag. '
                'Suited for pre/post analysis, Cronbach\'s Alpha, and Hake Gain.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _exporting ? null : () => _export(asCsv: true),
                  icon: const Icon(Icons.table_chart_outlined),
                  label: const Text('Export as CSV'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _exporting ? null : () => _export(asCsv: false),
                  icon: const Icon(Icons.data_object),
                  label: const Text('Export as JSON'),
                ),
              ),
              const SizedBox(height: 20),
              if (_exporting) const Center(child: CircularProgressIndicator()),
              if (_rowCount != null && !_exporting)
                Text(
                  'Exported $_rowCount response rows.',
                  style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

