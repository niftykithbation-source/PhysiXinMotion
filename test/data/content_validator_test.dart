import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_validation_exception.dart';
import 'package:physix_in_motion/data/content/content_validator.dart';

/// Builds a minimal, schema-valid content pack (10 quiz items, 1 stage, 2
/// mission levels, 1 badge) as a JSON-encodable map, so each test can
/// mutate a deep copy to introduce exactly one corruption.
Map<String, dynamic> _validPack() {
  return {
    'content_pack': {
      'pack_id': 'test_pack',
      'topic_name': 'Test Topic',
      'version': '1.0.0',
      'melc_codes': 'CODE-1',
    },
    'lesson_stages': [
      {
        'stage_id': 'test_evaluate',
        'stage_name': 'evaluate',
        'module_key': 'evaluation_terminal',
        'sequence_order': 1,
        'display_title': 'Evaluation Terminal',
        'body_json': {'instructions': 'Answer each item.'},
      },
    ],
    'quiz_items': List.generate(10, (i) {
      return {
        'item_id': 'q$i',
        'stage_id': 'test_evaluate',
        'item_type': 'mcq',
        'prompt': 'Prompt $i',
        'choices_json': [
          {'key': 'A', 'text': 'Choice A'},
          {'key': 'B', 'text': 'Choice B'},
        ],
        'correct_answer': 'A',
        'explanation': 'Because A.',
        'tos_competency': 'test competency',
        'difficulty': 'easy',
        'teacher_formula': 'formula for q$i',
      };
    }),
    'mission_levels': [
      {
        'level_id': 'level_1',
        'level_number': 1,
        'title': 'Level One',
        'scenario_text': 'Scenario.',
        'given_values': {'v0': 0, 'a': 2, 't': 5},
        'target_variable': 'v',
        'correct_answer': 10.0,
        'tolerance': 0.2,
        'teacher_solution': {
          'given': 'v0 = 0, a = 2, t = 5',
          'steps': ['v = v0 + a*t', 'v = 0 + 2(5)', 'v = 10.0'],
        },
      },
      {
        'level_id': 'level_2',
        'level_number': 2,
        'title': 'Level Two',
        'scenario_text': 'Scenario.',
        'given_values': {'v0': 15, 'v': 0, 't': 5},
        'target_variable': 'a',
        'correct_answer': -3.0,
        'tolerance': 0.2,
        'teacher_solution': {
          'given': 'v0 = 15, v = 0, t = 5',
          'steps': ['a = (v - v0) / t', 'a = (0 - 15) / 5', 'a = -3.0'],
        },
      },
    ],
    'badges': [
      {
        'badge_id': 'badge_1',
        'badge_name': 'Badge One',
        'description': 'Earned it.',
        'icon_asset': 'badges/badge_1.png',
        'unlock_rule_json': {'type': 'quiz_score_gte', 'value': 0.8},
      },
    ],
  };
}

void main() {
  group('ContentValidator', () {
    test('accepts a well-formed content pack', () {
      final pack = ContentValidator.validate(jsonEncode(_validPack()));

      expect(pack.packId, 'test_pack');
      expect(pack.quizItems, hasLength(10));
      expect(pack.missionLevels, hasLength(2));
      expect(pack.badges, hasLength(1));
    });

    test('rejects malformed JSON', () {
      expect(
        () => ContentValidator.validate('{ not valid json'),
        throwsA(isA<ContentValidationException>()),
      );
    });

    test('rejects a pack without exactly 10 quiz items', () {
      final json = _validPack();
      (json['quiz_items'] as List).removeLast();

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>().having(
            (e) => e.field,
            'field',
            'quiz_items',
          ),
        ),
      );
    });

    test('rejects a quiz item whose correct_answer is not one of its own choices', () {
      final json = _validPack();
      (json['quiz_items'] as List)[3]['correct_answer'] = 'Z';

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>()
              .having((e) => e.field, 'field', 'quiz_items.correct_answer')
              .having((e) => e.itemId, 'itemId', 'q3'),
        ),
      );
    });

    test('rejects a quiz item whose stage_id does not resolve', () {
      final json = _validPack();
      (json['quiz_items'] as List)[0]['stage_id'] = 'no_such_stage';

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>()
              .having((e) => e.field, 'field', 'quiz_items.stage_id')
              .having((e) => e.itemId, 'itemId', 'q0'),
        ),
      );
    });

    test('rejects a mission level whose target_variable is not one of {v0, v, a, t, d}', () {
      final json = _validPack();
      (json['mission_levels'] as List)[0]['target_variable'] = 'v_avg';

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>()
              .having((e) => e.field, 'field', 'mission_levels.target_variable')
              .having((e) => e.itemId, 'itemId', 'level_1'),
        ),
      );
    });

    test('rejects a quiz item with an empty teacher_formula', () {
      final json = _validPack();
      (json['quiz_items'] as List)[4]['teacher_formula'] = '';

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>()
              .having((e) => e.field, 'field', 'quiz_items.teacher_formula')
              .having((e) => e.itemId, 'itemId', 'q4'),
        ),
      );
    });

    test('rejects a mission level with a missing teacher_solution', () {
      final json = _validPack();
      (json['mission_levels'] as List)[1].remove('teacher_solution');

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>()
              .having((e) => e.field, 'field', 'mission_levels.teacher_solution')
              .having((e) => e.itemId, 'itemId', 'level_2'),
        ),
      );
    });

    test('rejects an engage/explore/explain lesson stage with a missing teacher_answer_key', () {
      final json = _validPack();
      (json['lesson_stages'] as List).add({
        'stage_id': 'test_engage',
        'stage_name': 'engage',
        'module_key': 'trip_tracker',
        'sequence_order': 0,
        'display_title': 'Trip Tracker',
        'body_json': {'hook_question': 'Which arrives first?'},
      });

      expect(
        () => ContentValidator.validate(jsonEncode(json)),
        throwsA(
          isA<ContentValidationException>()
              .having((e) => e.field, 'field', 'lesson_stages.teacher_answer_key')
              .having((e) => e.itemId, 'itemId', 'test_engage'),
        ),
      );
    });
  });
}
