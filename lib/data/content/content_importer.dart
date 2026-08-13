import 'package:drift/drift.dart';

import '../db/database.dart';
import 'content_validator.dart';

/// Step 2 (CLAUDE.md): reads a content pack JSON payload, validates it
/// (Step 2.3, via [ContentValidator]) and seeds the content tables on first
/// launch. Validation always runs to completion *before* the DB transaction
/// opens, so a validation failure writes nothing — never a partial seed.
class ContentImporter {
  final AppDatabase db;

  ContentImporter(this.db);

  /// Imports [rawJson] unless a pack with the same `pack_id` is already
  /// present (so this is safe to call on every app start, not just the
  /// first one).
  Future<void> importIfNeeded(String rawJson) async {
    final pack = ContentValidator.validate(rawJson);

    final existing = await (db.select(db.contentPacks)
          ..where((t) => t.packId.equals(pack.packId)))
        .getSingleOrNull();
    if (existing != null) {
      return;
    }

    await db.transaction(() async {
      await db.into(db.contentPacks).insert(ContentPacksCompanion.insert(
            packId: pack.packId,
            topicName: pack.topicName,
            version: pack.version,
            melcCodes: Value(pack.melcCodes),
            importedAt: DateTime.now().millisecondsSinceEpoch,
          ));

      for (final stage in pack.lessonStages) {
        await db.into(db.lessonStages).insert(LessonStagesCompanion.insert(
              stageId: stage.stageId,
              packId: Value(pack.packId),
              stageName: stage.stageName,
              moduleKey: stage.moduleKey,
              sequenceOrder: stage.sequenceOrder,
              displayTitle: stage.displayTitle,
              bodyJson: stage.bodyJson,
            ));
      }

      for (final item in pack.quizItems) {
        await db.into(db.quizItems).insert(QuizItemsCompanion.insert(
              itemId: item.itemId,
              packId: Value(pack.packId),
              stageId: Value(item.stageId),
              itemType: item.itemType,
              prompt: item.prompt,
              choicesJson: Value(item.choicesJson.isEmpty ? null : item.choicesJson),
              correctAnswer: item.correctAnswer,
              explanation: Value(item.explanation),
              tosCompetency: Value(item.tosCompetency),
              difficulty: Value(item.difficulty),
            ));
      }

      for (final level in pack.missionLevels) {
        await db.into(db.missionLevels).insert(MissionLevelsCompanion.insert(
              levelId: level.levelId,
              packId: Value(pack.packId),
              levelNumber: level.levelNumber,
              title: level.title,
              scenarioText: level.scenarioText,
              givenValues: level.givenValues,
              targetVariable: level.targetVariable,
              correctAnswer: level.correctAnswer,
              tolerance: Value(level.tolerance),
              formulaHint: Value(level.formulaHint),
              unit: Value(level.unit),
            ));
      }

      for (final badge in pack.badges) {
        await db.into(db.badges).insert(BadgesCompanion.insert(
              badgeId: badge.badgeId,
              badgeName: badge.badgeName,
              description: badge.description,
              iconAsset: badge.iconAsset,
              unlockRuleJson: badge.unlockRuleJson,
            ));
      }
    });
  }
}
