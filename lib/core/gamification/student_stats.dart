/// A student's aggregated stats, computed from the DB (see
/// `StudentStatsRepository`), against which [BadgeRuleEvaluator] checks
/// each [BadgeUnlockRule].
class StudentStats {
  /// Count of distinct mission levels completed correctly.
  final int missionLevelsCompleted;

  /// Best score ratio (0-1) achieved across completed quiz attempts,
  /// keyed by 5E stage name (e.g. "evaluate").
  final Map<String, double> bestQuizScoreRatioByStage;

  /// Interaction count per module_key (e.g. "graph_visualizer"). No table
  /// in the current schema logs this yet — always empty until a later
  /// build step adds that tracking, which means any `module_interaction`
  /// rule will not unlock in this build.
  final Map<String, int> moduleViewCounts;

  const StudentStats({
    required this.missionLevelsCompleted,
    required this.bestQuizScoreRatioByStage,
    required this.moduleViewCounts,
  });
}
