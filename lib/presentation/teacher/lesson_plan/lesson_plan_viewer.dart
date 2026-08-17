import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database.dart';
import '../../../data/evaluation/evaluation_providers.dart';
import '../../../data/mission_mode/mission_mode_providers.dart';
import '../../../data/teacher/lesson_plan_providers.dart';
import '../../student/evaluation/evaluation_terminal_screen.dart';
import '../../student/graph_visualizer/graph_visualizer_screen.dart';
import '../../student/mission_mode/mission_mode_screen.dart';
import '../../student/motion_lab/motion_lab_screen.dart';
import '../../student/trip_tracker/trip_tracker_screen.dart';

/// Hand-authored, per-stage teacher-facing copy — grounded in what each
/// screen actually does (read from the real widget code, not guessed) and
/// in the content pack's own body_json, but not literally sourced from
/// either, since neither the seed JSON nor the DB schema carries a
/// separate "teacher objective" or "expected simulation result" field.
class _StageTeacherNotes {
  final String objective;
  final String expectedSimulationResult;

  const _StageTeacherNotes({required this.objective, required this.expectedSimulationResult});
}

const _teacherNotesByStage = {
  'engage': _StageTeacherNotes(
    objective: 'Students form and test an intuitive prediction about which of two vehicles '
        '"arrives first," surfacing the everyday conflation of distance and speed before '
        'formal definitions are introduced.',
    expectedSimulationResult:
        'Both vehicle icons animate along their routes; the vehicle with the shorter, more '
        'direct path finishes first regardless of which one "looks" faster — demonstrating '
        'that displacement, not just speed, determines arrival time.',
  ),
  'explore': _StageTeacherNotes(
    objective: 'Students collect their own distance, displacement, and time data from a real '
        'walked path, and see speed and velocity computed directly from measurements they '
        'took themselves.',
    expectedSimulationResult:
        'Each recorded trial replays as a short animation and adds a point to the live '
        'displacement-time chart; speed and velocity are computed automatically from the '
        'distance, displacement, and time entered.',
  ),
  'explain': _StageTeacherNotes(
    objective: 'Students connect the graphical (slope, area) and algebraic (the four '
        'kinematic equations) representations of motion to the scalar/vector definitions of '
        'distance, displacement, speed, velocity, and acceleration.',
    expectedSimulationResult:
        'Tapping two points on a displacement-time or velocity-time graph reveals the slope '
        '(velocity or acceleration) or, on the velocity-time graph, the shaded area under '
        'the curve (displacement).',
  ),
  'elaborate': _StageTeacherNotes(
    objective: 'Students apply the kinematic equations to solve realistic commute scenarios, '
        'transferring the formulas from the Explain stage to problems with only some values '
        'given.',
    expectedSimulationResult:
        'Each level accepts a numeric answer and checks it within the level\'s tolerance; a '
        'correct answer unlocks the next level and awards points.',
  ),
  'evaluate': _StageTeacherNotes(
    objective: 'Students demonstrate independent mastery of distance, displacement, speed, '
        'velocity, acceleration, and the kinematic equations across a 10-item formative '
        'assessment.',
    expectedSimulationResult:
        'Each item gives immediate correct/incorrect feedback with an explanation before '
        'advancing; the summary screen shows score, points earned, and any newly unlocked '
        'badges.',
  ),
};

/// Teacher — Unified 5E Lesson Plan Viewer. Blueprint §3.3: the whole 5E
/// plan as one continuous scrollable document (Engage through Evaluate),
/// not five separate sub-screens the teacher has to tap into — each
/// stage's objectives, guided physics concepts, and expected simulation
/// result are all visible inline, with a single "Launch Demo" button per
/// stage for live classroom instruction. The Evaluate section additionally
/// renders the complete, read-only 10-item Answer Key (see
/// _AnswerKeySection) with correct choices and item rationales.
class LessonPlanViewer extends ConsumerWidget {
  const LessonPlanViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(lessonPlanStagesProvider);
    final packAsync = ref.watch(activeContentPackProvider);
    final quizItemsAsync = ref.watch(activeQuizItemsProvider);
    final missionLevelsAsync = ref.watch(missionLevelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('5E Lesson Plan')),
      body: stagesAsync.when(
        data: (stages) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            packAsync.maybeWhen(
              data: (pack) => pack == null ? const SizedBox.shrink() : _UnitHeader(pack: pack),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            for (final stage in stages) ...[
              _StageSection(
                stage: stage,
                quizItemsAsync: stage.stageName == 'evaluate' ? quizItemsAsync : null,
                missionLevelsAsync: stage.stageName == 'elaborate' ? missionLevelsAsync : null,
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
      ),
    );
  }
}

class _UnitHeader extends StatelessWidget {
  const _UnitHeader({required this.pack});

  final ContentPackRow pack;

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
          Text(pack.topicName, style: Theme.of(context).textTheme.titleMedium),
          if (pack.melcCodes != null) ...[
            const SizedBox(height: 4),
            Text(
              'MELC: ${pack.melcCodes}',
              style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

Widget? _demoScreenFor(String stageName) {
  return switch (stageName) {
    'engage' => const TripTrackerScreen(),
    'explore' => const MotionLabScreen(),
    'explain' => const GraphVisualizerScreen(),
    'elaborate' => const MissionModeScreen(),
    'evaluate' => const EvaluationTerminalScreen(),
    _ => null,
  };
}

class _StageSection extends StatelessWidget {
  const _StageSection({
    required this.stage,
    required this.quizItemsAsync,
    required this.missionLevelsAsync,
  });

  final LessonStageRow stage;
  final AsyncValue<List<QuizItemRow>>? quizItemsAsync;
  final AsyncValue<List<MissionLevelRow>>? missionLevelsAsync;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final body = jsonDecode(stage.bodyJson) as Map<String, dynamic>;
    final notes = _teacherNotesByStage[stage.stageName];
    final demoScreen = _demoScreenFor(stage.stageName);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryAccent,
                  foregroundColor: colors.onAccentText,
                  child: Text('${stage.sequenceOrder}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stage.displayTitle, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        stage.stageName.toUpperCase(),
                        style: TextStyle(
                          color: colors.textPrimary.withValues(alpha: 0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (notes != null) ...[
              const SizedBox(height: 16),
              _Label('Learning objective'),
              const SizedBox(height: 4),
              Text(notes.objective),
              const SizedBox(height: 12),
              _Label('Expected simulation result'),
              const SizedBox(height: 4),
              Text(notes.expectedSimulationResult),
            ],
            const SizedBox(height: 12),
            _Label('Guided physics concepts'),
            const SizedBox(height: 4),
            _StageConcepts(
              stageName: stage.stageName,
              body: body,
              missionLevelsAsync: missionLevelsAsync,
            ),
            if (quizItemsAsync != null) ...[
              const SizedBox(height: 16),
              _AnswerKeySection(quizItemsAsync: quizItemsAsync!),
            ],
            if (demoScreen != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Launch Demo'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => demoScreen),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The stage-specific curriculum content pulled directly from
/// lesson_stages.body_json (plus mission_levels for Elaborate) — full
/// detail, not a truncated one-line summary.
class _StageConcepts extends StatelessWidget {
  const _StageConcepts({
    required this.stageName,
    required this.body,
    required this.missionLevelsAsync,
  });

  final String stageName;
  final Map<String, dynamic> body;
  final AsyncValue<List<MissionLevelRow>>? missionLevelsAsync;

  @override
  Widget build(BuildContext context) {
    switch (stageName) {
      case 'engage':
        final predictionOptions =
            (body['prediction_options'] as List).cast<Map<String, dynamic>>();
        final teacherAnswerKey = body['teacher_answer_key'] as Map<String, dynamic>?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body['hook_question'] as String),
            const SizedBox(height: 8),
            Text(body['scenario'] as String),
            const SizedBox(height: 8),
            Text(
              'Prediction choices: '
              '${predictionOptions.map((o) => o['label']).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (teacherAnswerKey != null) ...[
              const SizedBox(height: 12),
              _TeacherAnswerKeyCard(
                children: [
                  Text(teacherAnswerKey['answer'] as String),
                  const SizedBox(height: 8),
                  _TeachingNote(teacherAnswerKey['teaching_note'] as String),
                ],
              ),
            ],
          ],
        );

      case 'explore':
        final teacherAnswerKey = body['teacher_answer_key'] as Map<String, dynamic>?;
        final sampleTrials = teacherAnswerKey == null
            ? const <Map<String, dynamic>>[]
            : (teacherAnswerKey['sample_worked_trials'] as List).cast<Map<String, dynamic>>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body['instructions'] as String),
            const SizedBox(height: 8),
            Text(
              'Records: ${(body['input_fields'] as List).join(', ')} — '
              'auto-computes: ${(body['auto_computed_fields'] as List).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (teacherAnswerKey != null) ...[
              const SizedBox(height: 12),
              _TeacherAnswerKeyCard(
                children: [
                  _SampleWorkedTrialsTable(trials: sampleTrials),
                  const SizedBox(height: 8),
                  _TeachingNote(teacherAnswerKey['teaching_note'] as String),
                ],
              ),
            ],
          ],
        );

      case 'explain':
        final definitions = (body['definitions'] as List).cast<Map<String, dynamic>>();
        final equations = (body['kinematic_equations'] as List).cast<Map<String, dynamic>>();
        final teacherAnswerKey = body['teacher_answer_key'] as Map<String, dynamic>?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final def in definitions)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${def['term']} (${def['type']}) — ${def['note']}'),
              ),
            const SizedBox(height: 8),
            for (final eq in equations)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  '${eq['formula']}  (solves for ${eq['solves_for']})',
                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                ),
                children: [
                  for (final step in (eq['derivation_steps'] as List).cast<String>())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $step'),
                    ),
                ],
              ),
            if (teacherAnswerKey != null) ...[
              const SizedBox(height: 4),
              _TeacherAnswerKeyCard(
                children: [
                  for (final line
                      in (teacherAnswerKey['graph_reading_summary'] as List).cast<String>())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $line'),
                    ),
                ],
              ),
            ],
          ],
        );

      case 'elaborate':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body['intro'] as String),
            const SizedBox(height: 8),
            (missionLevelsAsync ?? const AsyncValue.loading()).when(
              data: (levels) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final level in levels)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level ${level.levelNumber}: ${level.title} — solve for '
                            '${level.targetVariable}${level.unit != null ? ' (${level.unit})' : ''}',
                          ),
                          if (level.teacherSolution != null)
                            _TeacherAnswerKeyCard(
                              children: [_TeacherSolutionBlock(rawTeacherSolution: level.teacherSolution!)],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
            ),
          ],
        );

      case 'evaluate':
        return Text(body['instructions'] as String);

      default:
        return const SizedBox.shrink();
    }
  }
}

/// Teacher-only shaded card wrapping any block of Answer Key content —
/// same visual language as [_AnswerKeySection] below, reused per-stage so
/// engage/explore/explain teacher_answer_key content reads as clearly
/// teacher-facing, not part of the student-visible lesson copy.
class _TeacherAnswerKeyCard extends StatelessWidget {
  const _TeacherAnswerKeyCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.vpn_key_outlined, size: 16, color: colors.primaryAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text('Teacher answer key', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _TeachingNote extends StatelessWidget {
  const _TeachingNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Text(
      text,
      style: TextStyle(
        color: colors.textPrimary.withValues(alpha: 0.7),
        fontStyle: FontStyle.italic,
        fontSize: 12,
      ),
    );
  }
}

/// Renders explore stage's teacher_answer_key.sample_worked_trials as a
/// table. Trial 3 (zero net velocity, non-zero average speed) is the
/// pedagogically load-bearing row — its own teaching_note is shown
/// separately by the caller, not dropped here.
class _SampleWorkedTrialsTable extends StatelessWidget {
  const _SampleWorkedTrialsTable({required this.trials});

  final List<Map<String, dynamic>> trials;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold);
    final cellStyle = Theme.of(context).textTheme.bodySmall;

    Widget cell(String text, {TextStyle? style}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Text(text, style: style),
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        // Table's default column-sizing strategy (FlexColumnWidth) needs a
        // bounded incoming width to resolve flex fractions against — inside
        // a horizontally-scrolling SingleChildScrollView the incoming width
        // is unbounded, so every column collapsed to zero width and each
        // cell's Text wrapped one character per line. IntrinsicColumnWidth
        // sizes each column from its own content instead, which works
        // regardless of the parent's width constraint.
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder.all(color: colors.textPrimary.withValues(alpha: 0.15)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(color: colors.surfaceCard),
            children: [
              cell('Trial', style: headerStyle),
              cell('Movement', style: headerStyle),
              cell('d_total (m)', style: headerStyle),
              cell('Δx (m)', style: headerStyle),
              cell('t (s)', style: headerStyle),
              cell('s_avg (m/s)', style: headerStyle),
              cell('v_avg (m/s)', style: headerStyle),
            ],
          ),
          for (final trial in trials)
            TableRow(
              children: [
                cell('${trial['trial']}', style: cellStyle),
                cell('${trial['movement']}', style: cellStyle),
                cell('${trial['d_total_m']}', style: cellStyle),
                cell('${trial['delta_x_m']}', style: cellStyle),
                cell('${trial['time_s']}', style: cellStyle),
                cell('${trial['s_avg_mps']}', style: cellStyle),
                cell('${trial['v_avg_mps']}', style: cellStyle),
              ],
            ),
        ],
      ),
    );
  }
}

/// Renders a mission level's teacher_solution (given + numbered steps) —
/// decoded here from the re-encoded JSON string stored in
/// MissionLevelRow.teacherSolution (see content_pack.dart /
/// content_validator.dart Step 2.3).
class _TeacherSolutionBlock extends StatelessWidget {
  const _TeacherSolutionBlock({required this.rawTeacherSolution});

  final String rawTeacherSolution;

  @override
  Widget build(BuildContext context) {
    final solution = jsonDecode(rawTeacherSolution) as Map<String, dynamic>;
    final steps = (solution['steps'] as List).cast<String>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Given: ${solution['given']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        for (final step in steps)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(step, style: const TextStyle(fontFamily: 'monospace')),
          ),
      ],
    );
  }
}

/// Read-only complete Answer Key: correct choice + rationale for every
/// item, in the same q1..q10 order QrIngestService uses to decode a
/// scanned `ans` string. Teacher-facing only — never shown to students.
class _AnswerKeySection extends StatelessWidget {
  const _AnswerKeySection({required this.quizItemsAsync});

  final AsyncValue<List<QuizItemRow>> quizItemsAsync;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.vpn_key_outlined, size: 18, color: colors.primaryAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Answer Key (teacher only)', style: Theme.of(context).textTheme.titleSmall),
              ),
            ],
          ),
          const SizedBox(height: 8),
          quizItemsAsync.when(
            data: (items) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < items.length; i++) _AnswerKeyRow(number: i + 1, item: items[i]),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text('$error'),
          ),
        ],
      ),
    );
  }
}

class _AnswerKeyRow extends StatelessWidget {
  const _AnswerKeyRow({required this.number, required this.item});

  final int number;
  final QuizItemRow item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final choiceText = _correctChoiceText(item);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q$number: ${item.correctAnswer}${choiceText != null ? ' — $choiceText' : ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (item.explanation != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item.explanation!,
                style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.7), fontSize: 12),
              ),
            ),
          if (item.teacherFormula != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Formula: ${item.teacherFormula!}',
                style: TextStyle(
                  color: colors.primaryAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String? _correctChoiceText(QuizItemRow item) {
    if (item.choicesJson == null) return null;
    final choices = (jsonDecode(item.choicesJson!) as List).cast<Map<String, dynamic>>();
    for (final choice in choices) {
      if (choice['key'] == item.correctAnswer) return choice['text'] as String?;
    }
    return null;
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: colors.textPrimary.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}
