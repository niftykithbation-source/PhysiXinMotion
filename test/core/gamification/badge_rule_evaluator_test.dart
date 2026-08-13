import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/gamification/badge_rule_evaluator.dart';
import 'package:physix_in_motion/core/gamification/badge_unlock_rule.dart';
import 'package:physix_in_motion/core/gamification/student_stats.dart';

void main() {
  group('BadgeRuleEvaluator — QuizScoreGteRule', () {
    const rule = QuizScoreGteRule(stage: 'evaluate', value: 0.8);

    test('unlocked when the stage ratio meets the threshold exactly', () {
      final stats = StudentStats(
        missionLevelsCompleted: 0,
        bestQuizScoreRatioByStage: const {'evaluate': 0.8},
        moduleViewCounts: const {},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isTrue);
    });

    test('not unlocked when the stage ratio is below the threshold', () {
      final stats = StudentStats(
        missionLevelsCompleted: 0,
        bestQuizScoreRatioByStage: const {'evaluate': 0.79},
        moduleViewCounts: const {},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isFalse);
    });

    test('not unlocked when the stage has no recorded attempts', () {
      final stats = StudentStats(
        missionLevelsCompleted: 0,
        bestQuizScoreRatioByStage: const {},
        moduleViewCounts: const {},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isFalse);
    });
  });

  group('BadgeRuleEvaluator — MissionLevelsCompletedRule', () {
    const rule = MissionLevelsCompletedRule(value: 2);

    test('unlocked when enough levels are completed', () {
      final stats = StudentStats(
        missionLevelsCompleted: 2,
        bestQuizScoreRatioByStage: const {},
        moduleViewCounts: const {},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isTrue);
    });

    test('not unlocked when only 1 of 2 levels is completed', () {
      final stats = StudentStats(
        missionLevelsCompleted: 1,
        bestQuizScoreRatioByStage: const {},
        moduleViewCounts: const {},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isFalse);
    });
  });

  group('BadgeRuleEvaluator — ModuleInteractionRule', () {
    const rule = ModuleInteractionRule(moduleKey: 'graph_visualizer', viewsGte: 2);

    test('unlocked when the module was viewed enough times', () {
      final stats = StudentStats(
        missionLevelsCompleted: 0,
        bestQuizScoreRatioByStage: const {},
        moduleViewCounts: const {'graph_visualizer': 3},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isTrue);
    });

    test('not unlocked with no recorded views (current schema limitation)', () {
      final stats = StudentStats(
        missionLevelsCompleted: 5,
        bestQuizScoreRatioByStage: const {'evaluate': 1.0},
        moduleViewCounts: const {},
      );
      expect(BadgeRuleEvaluator.isUnlocked(rule, stats), isFalse);
    });
  });
}
