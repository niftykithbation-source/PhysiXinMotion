import 'badge_unlock_rule.dart';
import 'student_stats.dart';

/// Blueprint §7 Step 4.1: "rule evaluator reading badges.unlock_rule_json
/// against a student's aggregated stats". The sealed [BadgeUnlockRule]
/// makes this switch exhaustive at compile time — adding a new rule type
/// forces a case here.
class BadgeRuleEvaluator {
  const BadgeRuleEvaluator._();

  static bool isUnlocked(BadgeUnlockRule rule, StudentStats stats) {
    return switch (rule) {
      QuizScoreGteRule(:final stage, :final value) =>
        (stats.bestQuizScoreRatioByStage[stage] ?? 0) >= value,
      MissionLevelsCompletedRule(:final value) => stats.missionLevelsCompleted >= value,
      ModuleInteractionRule(:final moduleKey, :final viewsGte) =>
        (stats.moduleViewCounts[moduleKey] ?? 0) >= viewsGte,
    };
  }
}
