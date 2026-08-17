import 'dart:convert';

import 'content_validation_exception.dart';

/// Plain-Dart parse of a content pack JSON file (e.g. kinematics_v1.json),
/// shaped after blueprint §5's content_packs / lesson_stages / quiz_items /
/// mission_levels / badges tables. Deliberately has no Flutter or drift
/// imports so it (and [ContentValidator]) can run standalone in a CLI/CI
/// script as well as inside the app.
class ContentPackData {
  final String packId;
  final String topicName;
  final String version;
  final String? melcCodes;
  final List<LessonStageData> lessonStages;
  final List<QuizItemData> quizItems;
  final List<MissionLevelData> missionLevels;
  final List<BadgeData> badges;

  const ContentPackData({
    required this.packId,
    required this.topicName,
    required this.version,
    required this.melcCodes,
    required this.lessonStages,
    required this.quizItems,
    required this.missionLevels,
    required this.badges,
  });

  factory ContentPackData.fromJson(Map<String, dynamic> root) {
    final packJson = _requireMap(root, 'content_pack', 'content_pack');

    final lessonStages = _parseList(
      root,
      'lesson_stages',
      (json, index) => LessonStageData.fromJson(json, index),
    );

    final quizItems = _parseList(
      root,
      'quiz_items',
      (json, index) => QuizItemData.fromJson(json, index),
    );

    final missionLevels = _parseList(
      root,
      'mission_levels',
      (json, index) => MissionLevelData.fromJson(json, index),
    );

    final badges = _parseList(
      root,
      'badges',
      (json, index) => BadgeData.fromJson(json, index),
    );

    return ContentPackData(
      packId: _requireString(packJson, 'pack_id', 'content_pack'),
      topicName: _requireString(packJson, 'topic_name', 'content_pack'),
      version: _requireString(packJson, 'version', 'content_pack'),
      melcCodes: packJson['melc_codes'] as String?,
      lessonStages: lessonStages,
      quizItems: quizItems,
      missionLevels: missionLevels,
      badges: badges,
    );
  }
}

class LessonStageData {
  final String stageId;
  final String stageName;
  final String moduleKey;
  final int sequenceOrder;
  final String displayTitle;
  final String bodyJson; // re-encoded JSON, stored as TEXT

  const LessonStageData({
    required this.stageId,
    required this.stageName,
    required this.moduleKey,
    required this.sequenceOrder,
    required this.displayTitle,
    required this.bodyJson,
  });

  factory LessonStageData.fromJson(Map<String, dynamic> json, int index) {
    final field = 'lesson_stages[$index]';
    return LessonStageData(
      stageId: _requireString(json, 'stage_id', field),
      stageName: _requireString(json, 'stage_name', field),
      moduleKey: _requireString(json, 'module_key', field),
      sequenceOrder: _requireInt(json, 'sequence_order', field),
      displayTitle: _requireString(json, 'display_title', field),
      bodyJson: jsonEncode(_requireMap(json, 'body_json', field)),
    );
  }
}

class QuizChoice {
  final String key;
  final String text;

  const QuizChoice({required this.key, required this.text});
}

class QuizItemData {
  final String itemId;
  final String stageId;
  final String itemType;
  final String prompt;
  final List<QuizChoice> choices;
  final String choicesJson; // re-encoded JSON, stored as TEXT
  final String correctAnswer;
  final String? explanation;
  final String? tosCompetency;
  final String? difficulty;
  final String? teacherFormula;

  const QuizItemData({
    required this.itemId,
    required this.stageId,
    required this.itemType,
    required this.prompt,
    required this.choices,
    required this.choicesJson,
    required this.correctAnswer,
    required this.explanation,
    required this.tosCompetency,
    required this.difficulty,
    required this.teacherFormula,
  });

  factory QuizItemData.fromJson(Map<String, dynamic> json, int index) {
    final field = 'quiz_items[$index]';
    final rawChoices = json['choices_json'];
    final choices = <QuizChoice>[];
    if (rawChoices != null) {
      if (rawChoices is! List) {
        throw ContentValidationException(
          '$field.choices_json',
          (json['item_id'] as String?) ?? field,
          'choices_json must be a list.',
        );
      }
      for (final c in rawChoices) {
        final choiceMap = c as Map<String, dynamic>;
        choices.add(QuizChoice(
          key: _requireString(choiceMap, 'key', '$field.choices_json'),
          text: _requireString(choiceMap, 'text', '$field.choices_json'),
        ));
      }
    }

    return QuizItemData(
      itemId: _requireString(json, 'item_id', field),
      stageId: _requireString(json, 'stage_id', field),
      itemType: _requireString(json, 'item_type', field),
      prompt: _requireString(json, 'prompt', field),
      choices: choices,
      choicesJson: rawChoices == null ? '' : jsonEncode(rawChoices),
      correctAnswer: _requireString(json, 'correct_answer', field),
      explanation: json['explanation'] as String?,
      tosCompetency: json['tos_competency'] as String?,
      difficulty: json['difficulty'] as String?,
      teacherFormula: json['teacher_formula'] as String?,
    );
  }
}

class MissionLevelData {
  final String levelId;
  final int levelNumber;
  final String title;
  final String scenarioText;
  final String givenValues; // re-encoded JSON, stored as TEXT
  final String targetVariable;
  final double correctAnswer;
  final double tolerance;
  final String? formulaHint;
  final String? unit;
  final String? teacherSolution; // re-encoded JSON, stored as TEXT

  const MissionLevelData({
    required this.levelId,
    required this.levelNumber,
    required this.title,
    required this.scenarioText,
    required this.givenValues,
    required this.targetVariable,
    required this.correctAnswer,
    required this.tolerance,
    required this.formulaHint,
    required this.unit,
    required this.teacherSolution,
  });

  factory MissionLevelData.fromJson(Map<String, dynamic> json, int index) {
    final field = 'mission_levels[$index]';
    return MissionLevelData(
      levelId: _requireString(json, 'level_id', field),
      levelNumber: _requireInt(json, 'level_number', field),
      title: _requireString(json, 'title', field),
      scenarioText: _requireString(json, 'scenario_text', field),
      givenValues: jsonEncode(_requireMap(json, 'given_values', field)),
      targetVariable: _requireString(json, 'target_variable', field),
      correctAnswer: _requireDouble(json, 'correct_answer', field),
      tolerance: json['tolerance'] == null
          ? 0.1
          : (json['tolerance'] as num).toDouble(),
      formulaHint: json['formula_hint'] as String?,
      unit: json['unit'] as String?,
      teacherSolution: json['teacher_solution'] is Map<String, dynamic>
          ? jsonEncode(json['teacher_solution'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BadgeData {
  final String badgeId;
  final String badgeName;
  final String description;
  final String iconAsset;
  final String unlockRuleJson; // re-encoded JSON, stored as TEXT

  const BadgeData({
    required this.badgeId,
    required this.badgeName,
    required this.description,
    required this.iconAsset,
    required this.unlockRuleJson,
  });

  factory BadgeData.fromJson(Map<String, dynamic> json, int index) {
    final field = 'badges[$index]';
    return BadgeData(
      badgeId: _requireString(json, 'badge_id', field),
      badgeName: _requireString(json, 'badge_name', field),
      description: _requireString(json, 'description', field),
      iconAsset: _requireString(json, 'icon_asset', field),
      unlockRuleJson: jsonEncode(_requireMap(json, 'unlock_rule_json', field)),
    );
  }
}

List<T> _parseList<T>(
  Map<String, dynamic> root,
  String key,
  T Function(Map<String, dynamic> json, int index) parse,
) {
  final raw = root[key];
  if (raw is! List) {
    throw ContentValidationException(
      key,
      key,
      '"$key" is missing or is not a list.',
    );
  }
  final result = <T>[];
  for (var i = 0; i < raw.length; i++) {
    final entry = raw[i];
    if (entry is! Map<String, dynamic>) {
      throw ContentValidationException(
        '$key[$i]',
        '$key[$i]',
        'Entry is not a JSON object.',
      );
    }
    try {
      result.add(parse(entry, i));
    } on ContentValidationException {
      rethrow;
    } catch (e) {
      throw ContentValidationException(
        '$key[$i]',
        (entry['item_id'] ?? entry['level_id'] ?? entry['stage_id'] ?? entry['badge_id'] ?? '$key[$i]')
            .toString(),
        'Failed to parse: $e',
      );
    }
  }
  return result;
}

Map<String, dynamic> _requireMap(Map<String, dynamic> json, String key, String field) {
  final value = json[key];
  if (value is! Map<String, dynamic>) {
    throw ContentValidationException(field, field, '"$key" is missing or is not an object.');
  }
  return value;
}

String _requireString(Map<String, dynamic> json, String key, String field) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw ContentValidationException(field, field, '"$key" is missing or is not a non-empty string.');
  }
  return value;
}

int _requireInt(Map<String, dynamic> json, String key, String field) {
  final value = json[key];
  if (value is! int) {
    throw ContentValidationException(field, field, '"$key" is missing or is not an integer.');
  }
  return value;
}

double _requireDouble(Map<String, dynamic> json, String key, String field) {
  final value = json[key];
  if (value is! num) {
    throw ContentValidationException(field, field, '"$key" is missing or is not a number.');
  }
  return value.toDouble();
}
