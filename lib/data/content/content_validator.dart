import 'dart:convert';

import 'content_pack.dart';
import 'content_validation_exception.dart';

/// Step 2.3 (CLAUDE.md / blueprint §6 Risk #12, §7 Step 2.3): validates a
/// parsed content pack before anything is written to the database. Pure
/// Dart — no Flutter or drift imports — so the same checks run inside the
/// app and in the standalone `tools/validate_content.dart` CI script.
class ContentValidator {
  /// The five kinematic variables the Step 3 SUVAT solver is scoped to.
  static const kinematicVariables = {'v0', 'v', 'a', 't', 'd'};

  /// Parses [rawJson] and runs all integrity checks. Returns the parsed
  /// pack on success; throws [ContentValidationException] on the first
  /// failure, naming the specific field and item responsible.
  static ContentPackData validate(String rawJson) {
    final Map<String, dynamic> root;
    try {
      root = jsonDecode(rawJson) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw ContentValidationException('root', 'root', 'Content pack is not valid JSON: ${e.message}');
    }

    final pack = ContentPackData.fromJson(root);

    if (pack.quizItems.length != 10) {
      throw ContentValidationException(
        'quiz_items',
        'quiz_items',
        'Expected exactly 10 quiz items, found ${pack.quizItems.length}.',
      );
    }

    final stageIds = pack.lessonStages.map((s) => s.stageId).toSet();

    for (final item in pack.quizItems) {
      if (item.itemType == 'mcq') {
        final choiceKeys = item.choices.map((c) => c.key).toSet();
        if (!choiceKeys.contains(item.correctAnswer)) {
          throw ContentValidationException(
            'quiz_items.correct_answer',
            item.itemId,
            'correct_answer "${item.correctAnswer}" is not one of this item\'s '
                'choices_json keys (${choiceKeys.join(', ')}).',
          );
        }
      }

      if (!stageIds.contains(item.stageId)) {
        throw ContentValidationException(
          'quiz_items.stage_id',
          item.itemId,
          'stage_id "${item.stageId}" does not resolve to any entry in lesson_stages.',
        );
      }
    }

    for (final level in pack.missionLevels) {
      if (!kinematicVariables.contains(level.targetVariable)) {
        throw ContentValidationException(
          'mission_levels.target_variable',
          level.levelId,
          'target_variable "${level.targetVariable}" is not one of '
              '{${kinematicVariables.join(', ')}}.',
        );
      }
    }

    return pack;
  }
}
