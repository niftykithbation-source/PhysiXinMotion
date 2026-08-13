import 'dart:convert';

/// Blueprint §7 Step 4.1: a badge's `unlock_rule_json` column, parsed into
/// one of the rule shapes actually used by the seeded content pack (see
/// kinematics_v1.json's `badges` array). Pure Dart, no Flutter imports.
sealed class BadgeUnlockRule {
  const BadgeUnlockRule();

  factory BadgeUnlockRule.fromJson(String rawJson) {
    final json = jsonDecode(rawJson) as Map<String, dynamic>;
    final type = json['type'] as String?;
    switch (type) {
      case 'quiz_score_gte':
        return QuizScoreGteRule(
          stage: json['stage'] as String,
          value: (json['value'] as num).toDouble(),
        );
      case 'mission_levels_completed':
        return MissionLevelsCompletedRule(value: (json['value'] as num).toInt());
      case 'module_interaction':
        return ModuleInteractionRule(
          moduleKey: json['module_key'] as String,
          viewsGte: (json['views_gte'] as num).toInt(),
        );
      default:
        throw ArgumentError('Unknown badge unlock rule type: $type');
    }
  }
}

/// Unlocks once the student's best score on [stage] is >= [value] (a 0-1
/// ratio). e.g. Vector Voyager: stage "evaluate", value 0.8.
class QuizScoreGteRule extends BadgeUnlockRule {
  final String stage;
  final double value;

  const QuizScoreGteRule({required this.stage, required this.value});
}

/// Unlocks once the student has correctly completed at least [value]
/// distinct mission levels. e.g. Motion Master: value 2.
class MissionLevelsCompletedRule extends BadgeUnlockRule {
  final int value;

  const MissionLevelsCompletedRule({required this.value});
}

/// Unlocks once the student has interacted with [moduleKey] at least
/// [viewsGte] times. e.g. Graph Reader: module_key "graph_visualizer",
/// views_gte 2.
class ModuleInteractionRule extends BadgeUnlockRule {
  final String moduleKey;
  final int viewsGte;

  const ModuleInteractionRule({required this.moduleKey, required this.viewsGte});
}
