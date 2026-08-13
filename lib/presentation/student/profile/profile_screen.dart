import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/backup/auto_backup_service.dart';
import '../../../data/db/database.dart';
import '../../../data/db/database_provider.dart';
import '../../../data/profile/profile_providers.dart';
import '../../../data/session/current_student_provider.dart';
import '../../settings/settings_screen.dart';

const _pointsPerLevel = 100;

/// Student — Profile & Badges. Blueprint §3.3.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(totalPointsProvider);
    final earnedIdsAsync = ref.watch(earnedBadgeIdsProvider);
    final allBadgesAsync = ref.watch(allBadgesProvider);
    final lastBackupAsync = ref.watch(lastBackupAtProvider);
    final colors = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Badges'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: colors.primaryAccent,
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            pointsAsync.when(
              data: (points) => _XpBar(points: points),
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
            ),
            const SizedBox(height: 28),
            Text('Badges', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            allBadgesAsync.when(
              data: (allBadges) => earnedIdsAsync.when(
                data: (earnedIds) => GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    for (final badge in allBadges)
                      _BadgeTile(badge: badge, earned: earnedIds.contains(badge.badgeId)),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text('$error'),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('$error'),
            ),
            const SizedBox(height: 28),
            lastBackupAsync.maybeWhen(
              data: (lastBackup) => Text(
                lastBackup == null
                    ? 'No backup yet.'
                    : 'Last backup: ${_relativeTime(lastBackup)}',
                style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6)),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.ios_share),
                label: const Text('Share My Results'),
                onPressed: () => _shareResults(ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareResults(WidgetRef ref) async {
    final db = ref.read(appDatabaseProvider);
    final student = await ref.read(currentStudentProvider.future);
    final file = await AutoBackupService(db)
        .snapshotNow(userId: student.userId, packId: kActiveContentPackId);
    ref.invalidate(lastBackupAtProvider);
    await Share.shareXFiles([XFile(file.path)], text: 'My PhysiX in Motion results');
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return '${diff.inHours} h ago';
    return '${diff.inDays} d ago';
  }
}

class _XpBar extends StatelessWidget {
  const _XpBar({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    final level = points ~/ _pointsPerLevel + 1;
    final progress = (points % _pointsPerLevel) / _pointsPerLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level $level · $points XP', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: progress, minHeight: 10),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.earned});

  final BadgeRow badge;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Tooltip(
      message: badge.description,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: earned ? colors.secondaryAccent : colors.surfaceCard,
            child: Icon(
              Icons.emoji_events,
              color: earned ? colors.onAccentText : colors.textPrimary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.badgeName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: earned ? colors.textPrimary : colors.textPrimary.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
