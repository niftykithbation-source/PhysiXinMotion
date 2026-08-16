import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/session/stage_progress_repository.dart';
import '../../../data/teacher/dashboard_repository.dart';
import '../../../data/teacher/roster_providers.dart';
import '../../settings/settings_screen.dart';
import '../import/import_screen.dart';
import '../roster/scan_qr_screen.dart';
import '../roster/student_detail_screen.dart';
import '../widgets/section_dropdown.dart';

final _dashboardMetricsProvider = FutureProvider.autoDispose<DashboardMetrics>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  // Rebuild whenever the roster changes or the active section filter
  // switches (Scan Student QR / Import Student Results both invalidate
  // rosterStudentsProvider, which this depends on transitively).
  ref.watch(rosterStudentsProvider);
  final sectionId = ref.watch(activeSectionIdProvider);
  return DashboardRepository(db).computeMetrics(sectionId: sectionId);
});

/// Teacher — Dashboard. Blueprint §3.3: class-wide summary cards (capped
/// per §3.1 principle 5) + per-student row list + Import/Scan entry
/// points, all filterable to a single section via the Section Dropdown.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(_dashboardMetricsProvider);
    final rosterAsync = ref.watch(filteredRosterStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Import Student Results',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImportScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen(showTeacherControls: true)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(_dashboardMetricsProvider);
            ref.invalidate(rosterStudentsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SectionDropdown(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Student QR'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              metricsAsync.when(
                data: (metrics) => _MetricsGrid(metrics: metrics),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text('$error'),
              ),
              const SizedBox(height: 28),
              Text('Students', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              rosterAsync.when(
                data: (roster) => roster.isEmpty
                    ? const Text('No students in this section yet.')
                    : Column(
                        children: [
                          for (final entry in roster)
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.person_outline),
                                title: Text(entry.user.displayName),
                                subtitle: Text(entry.section?.sectionName ?? 'No section'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StudentDetailScreen(student: entry.user),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text('$error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${metrics.studentCount} students', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        _MetricCard(
          title: 'Class average',
          value: metrics.avgQuizScorePct == null
              ? 'No completed attempts yet'
              : '${(metrics.avgQuizScorePct! * 100).toStringAsFixed(0)}%',
          subtitle: 'Average best-attempt quiz score across this section.',
        ),
        const SizedBox(height: 12),
        _MetricCard(
          title: 'Avg. pre/post score delta',
          value: metrics.avgPrePostDelta == null
              ? 'Not enough data yet'
              : '${(metrics.avgPrePostDelta! * 100).toStringAsFixed(1)} pts',
          subtitle: metrics.avgPrePostDelta == null
              ? 'Needs both a pretest and posttest attempt for at least one student.'
              : null,
        ),
        const SizedBox(height: 12),
        _StageCompletionCard(rates: metrics.stageCompletionRates),
        const SizedBox(height: 12),
        _MetricCard(
          title: 'Most-missed item',
          value: metrics.mostMissedItem == null
              ? 'No quiz responses yet'
              : '${(metrics.mostMissedItem!.missRate * 100).toStringAsFixed(0)}% missed',
          subtitle: metrics.mostMissedItem?.prompt,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, this.subtitle});

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _StageCompletionCard extends StatelessWidget {
  const _StageCompletionCard({required this.rates});

  final Map<String, double> rates;

  static const _labels = {
    'engage': 'Engage',
    'explore': 'Explore',
    'explain': 'Explain',
    'elaborate': 'Elaborate',
    'evaluate': 'Evaluate',
  };

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.surfaceCard, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('% completed each 5E stage', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          for (final stage in kFiveEStages)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 70, child: Text(_labels[stage]!)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: rates[stage] ?? 0,
                        minHeight: 8,
                        color: colors.primaryAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${((rates[stage] ?? 0) * 100).round()}%',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
