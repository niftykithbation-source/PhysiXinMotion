import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database.dart';
import '../../../data/mission_mode/mission_mode_providers.dart';
import '../widgets/five_e_progress_pips.dart';
import 'mission_level_screen.dart';

/// Student — Mission Mode (Elaborate): level select. Blueprint §3.3.
class MissionModeScreen extends ConsumerWidget {
  const MissionModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(missionLevelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mission Mode')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FiveEProgressPips(
                current: 'elaborate',
                completedStages: {'engage', 'explore', 'explain'},
              ),
              const SizedBox(height: 20),
              Text('Commute Challenge', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Use the kinematic equations to solve real commute scenarios.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: levelsAsync.when(
                  data: (levels) => ListView.separated(
                    itemCount: levels.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _LevelCard(level: levels[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text('$error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends ConsumerWidget {
  const _LevelCard({required this.level});

  final MissionLevelRow level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final solvedAsync = ref.watch(missionLevelSolvedProvider(level.levelId));
    final solved = solvedAsync.maybeWhen(data: (v) => v, orElse: () => false);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: solved ? colors.secondaryAccent : colors.primaryAccent,
          foregroundColor: colors.onAccentText,
          child: Text('${level.levelNumber}'),
        ),
        title: Text(level.title),
        subtitle: Text(level.scenarioText, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: solved ? const Icon(Icons.check_circle) : const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MissionLevelScreen(level: level)),
        ),
      ),
    );
  }
}
