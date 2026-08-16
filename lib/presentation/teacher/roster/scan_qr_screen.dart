import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/session/current_teacher_provider.dart';
import '../../../data/teacher/qr_ingest_service.dart';
import '../../../data/teacher/roster_providers.dart';

/// Teacher — "Scan Student QR" (offline camera ingestion). Reads the
/// compressed payload from a student's "Show My QR Code" (see
/// _buildStudentQrPayload in student_home_shell.dart, including its 10-char
/// `ans` answer string), matches it against this device's local Drift
/// database, and upserts a roster entry, a quiz_attempts row, and — from
/// `ans` — the individual quiz_item_responses rows behind it (see
/// QrIngestService for the full matching and upsert rules). Stays open
/// after each scan so a teacher can work through a whole class in one
/// session; "Done" closes it.
class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({super.key});

  @override
  ConsumerState<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends ConsumerState<ScanQrScreen> {
  final _controller = MobileScannerController();
  bool _processing = false;
  String? _lastRawValue;
  DateTime? _lastHandledAt;
  int _scanCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDetect(BarcodeCapture capture) async {
    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue.isEmpty || _processing) return;

    // The camera keeps re-detecting the same frame every tick while the
    // code stays in view — ignore repeats of the identical payload within
    // a short window instead of re-ingesting it over and over.
    final now = DateTime.now();
    if (rawValue == _lastRawValue &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 3)) {
      return;
    }

    setState(() => _processing = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final teacher = await ref.read(currentTeacherProvider.future);
      final result = await QrIngestService(db).ingest(
        rawValue,
        importedByTeacherId: teacher.userId,
      );

      _lastRawValue = rawValue;
      _lastHandledAt = DateTime.now();

      ref.invalidate(rosterStudentsProvider);
      ref.invalidate(classSectionsProvider);

      if (mounted) {
        setState(() => _scanCount++);
        final trials = result.labTrials;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade700,
            content: Text(
              '${result.studentDisplayName} (${result.sectionName}) — '
              'Quiz ${result.quizScore} · ${result.completionPct}% complete'
              '${trials != null ? ' · $trials trials' : ''}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on QrIngestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_scanCount == 0 ? 'Scan Student QR' : 'Scan Student QR ($_scanCount scanned)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Toggle flash',
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _handleDetect),
          if (_processing)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black45,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.surfaceCard.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Point the camera at a student's QR code",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
