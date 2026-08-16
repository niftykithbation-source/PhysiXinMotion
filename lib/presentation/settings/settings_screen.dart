import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/profile/profile_providers.dart';
import '../../data/settings/app_settings_provider.dart';
import '../../data/settings/storage_info_provider.dart';
import '../validator/validator_checklist_screen.dart';

// Kept in sync with pubspec.yaml's `version:` field by hand — this build
// has no package-info dependency to read it at runtime.
const kAppVersion = '1.0.0 (build 1)';

/// Shared Settings screen shell (blueprint §3.2/§3.3), reachable via a
/// header icon from Profile & Badges (student) or the Dashboard (teacher)
/// rather than a bottom-nav tab. [showTeacherControls] adds the
/// teacher-only rows (Extended time, Class Leaderboard visibility) — pass
/// true only from the Teacher Portal.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, this.showTeacherControls = false});

  final bool showTeacherControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final simpleGraphics = ref.watch(simpleGraphicsControllerProvider);
    final validatorMode = ref.watch(validatorModeControllerProvider);
    final lastBackupAsync = ref.watch(lastBackupAtProvider);
    final storageAsync = ref.watch(offlineStorageBytesProvider);
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ButtonSegment(value: ThemeMode.system, label: Text('Match device')),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) => ref
                  .read(themeModeControllerProvider.notifier)
                  .setThemeMode(selection.first),
            ),
            const SizedBox(height: 28),
            Text('Accessibility', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Simple graphics'),
              subtitle: Text(
                'Disables chart animation and caps trial history at '
                '${SimpleGraphicsController.capWhenEnabled} points.',
              ),
              value: simpleGraphics,
              onChanged: (value) =>
                  ref.read(simpleGraphicsControllerProvider.notifier).setEnabled(value),
            ),
            const SizedBox(height: 28),
            Text('Validator', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Validator Mode'),
              subtitle: const Text(
                "Surfaces each Evaluation item's Table-of-Specifications tag for curriculum "
                'alignment review.',
              ),
              value: validatorMode,
              onChanged: (value) =>
                  ref.read(validatorModeControllerProvider.notifier).setEnabled(value),
            ),
            if (validatorMode) ...[
              const SizedBox(height: 4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.fact_check_outlined),
                title: const Text('Open Validator Checklist'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ValidatorChecklistScreen()),
                ),
              ),
            ],
            if (showTeacherControls) ...[
              const SizedBox(height: 28),
              Text('Teacher controls', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Consumer(
                builder: (context, ref, _) {
                  final extendedTime = ref.watch(extendedTimeControllerProvider);
                  final leaderboardVisible = ref.watch(leaderboardVisibilityControllerProvider);
                  return Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Extended time'),
                        subtitle: const Text(
                          'UDL accommodation for timed activities. Recorded for reference — '
                          "no screen currently enforces a hard timer.",
                        ),
                        value: extendedTime,
                        onChanged: (value) =>
                            ref.read(extendedTimeControllerProvider.notifier).setEnabled(value),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Class Leaderboard visibility'),
                        subtitle: const Text(
                          'Off by default (blueprint constraint 5). Turning this on makes '
                          'student rankings visible within this class.',
                        ),
                        value: leaderboardVisible,
                        onChanged: (value) => ref
                            .read(leaderboardVisibilityControllerProvider.notifier)
                            .setEnabled(value),
                      ),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 28),
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _AboutRow(label: 'App version', value: kAppVersion),
            _AboutRow(
              label: 'Last backup',
              value: lastBackupAsync.when(
                data: (time) => time == null ? 'Never' : time.toString(),
                loading: () => '…',
                error: (error, stackTrace) => '—',
              ),
            ),
            _AboutRow(
              label: 'Offline storage used',
              value: storageAsync.when(
                data: formatBytes,
                loading: () => '…',
                error: (error, stackTrace) => '—',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'PhysiX in Motion is fully offline — no data ever leaves this device '
              'except when you choose to Share My Results.',
              style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.5), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
