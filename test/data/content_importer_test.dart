import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/content/content_validation_exception.dart';
import 'package:physix_in_motion/data/db/database.dart';

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
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('ContentImporter', () {
    test('fresh install seeds content_packs, lesson_stages, quiz_items, '
        'mission_levels and badges', () async {
      await ContentImporter(db).importIfNeeded(jsonEncode(_validPack()));

      expect(await db.select(db.contentPacks).get(), hasLength(1));
      expect(await db.select(db.lessonStages).get(), hasLength(1));
      expect(await db.select(db.quizItems).get(), hasLength(10));
      expect(await db.select(db.missionLevels).get(), hasLength(2));
      expect(await db.select(db.badges).get(), hasLength(1));
    });

    test('re-importing the same pack_id is a no-op (safe on every launch)', () async {
      final rawJson = jsonEncode(_validPack());

      await ContentImporter(db).importIfNeeded(rawJson);
      await ContentImporter(db).importIfNeeded(rawJson);

      expect(await db.select(db.contentPacks).get(), hasLength(1));
      expect(await db.select(db.quizItems).get(), hasLength(10));
    });

    test('a corrupted pack aborts before writing anything (no silent partial seed)', () async {
      final json = _validPack();
      (json['quiz_items'] as List)[2]['correct_answer'] = 'not_a_real_choice_key';

      await expectLater(
        ContentImporter(db).importIfNeeded(jsonEncode(json)),
        throwsA(isA<ContentValidationException>()),
      );

      expect(await db.select(db.contentPacks).get(), isEmpty);
      expect(await db.select(db.lessonStages).get(), isEmpty);
      expect(await db.select(db.quizItems).get(), isEmpty);
      expect(await db.select(db.missionLevels).get(), isEmpty);
      expect(await db.select(db.badges).get(), isEmpty);
    });
  });
}
