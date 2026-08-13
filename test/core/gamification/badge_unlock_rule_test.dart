import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/gamification/badge_unlock_rule.dart';

void main() {
  late List<Map<String, dynamic>> badges;

  setUpAll(() {
    final raw = File('assets/content/kinematics_v1.json').readAsStringSync();
    final content = jsonDecode(raw) as Map<String, dynamic>;
    badges = (content['badges'] as List).cast<Map<String, dynamic>>();
  });

  Map<String, dynamic> badge(String badgeId) =>
      badges.firstWhere((b) => b['badge_id'] == badgeId);

  group('BadgeUnlockRule.fromJson — real kinematics_v1.json rules', () {
    test('vector_voyager parses as QuizScoreGteRule(stage: evaluate, value: 0.8)', () {
      final rawRule = jsonEncode(badge('vector_voyager')['unlock_rule_json']);
      final rule = BadgeUnlockRule.fromJson(rawRule);

      expect(rule, isA<QuizScoreGteRule>());
      final r = rule as QuizScoreGteRule;
      expect(r.stage, 'evaluate');
      expect(r.value, 0.8);
    });

    test('motion_master parses as MissionLevelsCompletedRule(value: 2)', () {
      final rawRule = jsonEncode(badge('motion_master')['unlock_rule_json']);
      final rule = BadgeUnlockRule.fromJson(rawRule);

      expect(rule, isA<MissionLevelsCompletedRule>());
      expect((rule as MissionLevelsCompletedRule).value, 2);
    });

    test('graph_reader parses as ModuleInteractionRule(module_key: graph_visualizer, '
        'views_gte: 2)', () {
      final rawRule = jsonEncode(badge('graph_reader')['unlock_rule_json']);
      final rule = BadgeUnlockRule.fromJson(rawRule);

      expect(rule, isA<ModuleInteractionRule>());
      final r = rule as ModuleInteractionRule;
      expect(r.moduleKey, 'graph_visualizer');
      expect(r.viewsGte, 2);
    });
  });

  test('throws on an unknown rule type', () {
    expect(
      () => BadgeUnlockRule.fromJson(jsonEncode({'type': 'streak_days_gte', 'value': 5})),
      throwsArgumentError,
    );
  });
}
