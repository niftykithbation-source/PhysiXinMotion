import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database.dart';
import '../../../data/teacher/lesson_plan_providers.dart';
import '../../student/evaluation/evaluation_terminal_screen.dart';
import '../../student/graph_visualizer/graph_visualizer_screen.dart';
import '../../student/mission_mode/mission_mode_screen.dart';
import '../../student/motion_lab/motion_lab_screen.dart';
import '../../student/trip_tracker/trip_tracker_screen.dart';

const _stageDescriptionKeys = {
  'engage': 'hook_question',
  'explore': 'instructions',
  'explain': null, // definitions list, handled specially
  'elaborate': 'intro',
  'evaluate': 'instructions',
};

/// Teacher — Lesson Plan viewer. Blueprint §3.3: renders the 5E lesson
/// plan read-only, with "Open in app" deep-links to the matching student
/// module for live classroom demo.
class LessonPlanScreen extends ConsumerWidget {
  const LessonPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(lessonPlanStagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson Plan')),
      body: stagesAsync.when(
        data: (stages) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            for (final stage in stages) _StageCard(stage: stage),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({required this.stage});

  final LessonStageRow stage;

  Widget? _openInAppScreen() {
    return switch (stage.stageName) {
      'engage' => const TripTrackerScreen(),
      'explore' => const MotionLabScreen(),
      'explain' => const GraphVisualizerScreen(),
      'elaborate' => const MissionModeScreen(),
      'evaluate' => const EvaluationTerminalScreen(),
      _ => null,
    };
  }

  String _description(Map<String, dynamic> body) {
    final key = _stageDescriptionKeys[stage.stageName];
    if (key != null && body[key] is String) return body[key] as String;
    if (stage.stageName == 'explain' && body['definitions'] is List) {
      final terms = (body['definitions'] as List)
          .cast<Map<String, dynamic>>()
          .map((d) => d['term'] as String)
          .join(', ');
      return 'Covers: $terms';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final body = jsonDecode(stage.bodyJson) as Map<String, dynamic>;
    final openInApp = _openInAppScreen();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryAccent,
          child: Text('${stage.sequenceOrder}'),
        ),
        title: Text(stage.displayTitle),
        subtitle: Text(stage.stageName.toUpperCase()),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_description(body)),
                const SizedBox(height: 12),
                if (openInApp != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open in app'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => openInApp),
                      ),
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
