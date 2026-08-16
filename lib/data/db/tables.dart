import 'package:drift/drift.dart';

// Schema per PhysiX_Technical_Blueprint.md §5. Column/table names are kept
// snake_case-equivalent to the blueprint's SQL via drift's default naming
// (camelCase Dart identifiers -> snake_case columns), so this file mirrors
// the blueprint 1:1 rather than reinterpreting it.

// ============ IDENTITY ============

@DataClassName('UserRow')
class Users extends Table {
  TextColumn get userId => text()();
  TextColumn get role =>
      text().customConstraint("NOT NULL CHECK (role IN ('student','teacher'))")();
  TextColumn get displayName => text()();
  TextColumn get pinHash => text()();
  TextColumn get avatarId => text().nullable()();
  TextColumn get gradeLevel => text().nullable()();
  TextColumn get strand => text().nullable()();
  TextColumn get sectionId =>
      text().nullable().references(ClassSections, #sectionId)();
  IntColumn get createdAt => integer()();
  IntColumn get lastLoginAt => integer().nullable()();
  // Schema v2 — Teacher Portal roster management: the school's own official
  // student identifier (LRN or class number), distinct from userId (this
  // app's internal row key) and from displayName (which can collide across
  // students). Nullable/additive: not in blueprint §5's original SQL.
  TextColumn get officialStudentId => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('ClassSectionRow')
class ClassSections extends Table {
  TextColumn get sectionId => text()();
  TextColumn get teacherId => text().nullable().references(Users, #userId)();
  TextColumn get sectionName => text()();
  TextColumn get schoolName => text().nullable()();
  IntColumn get createdAt => integer()();
  // Schema v2 — Teacher Portal multi-section management. schoolYear is
  // free text (e.g. "2025-2026"); sectionPin is the code a teacher hands
  // out to students so their QR scan / local profile self-tags into this
  // section (see student_profile_provider.dart and qr_ingest_service.dart)
  // — not a login credential, just a local roster-filing key. Nullable/
  // additive: not in blueprint §5's original SQL.
  TextColumn get schoolYear => text().nullable()();
  TextColumn get sectionPin => text().nullable()();

  @override
  Set<Column> get primaryKey => {sectionId};
}

// ============ CONTENT (bundled, versioned, mostly read-only) ============

@DataClassName('ContentPackRow')
class ContentPacks extends Table {
  TextColumn get packId => text()();
  TextColumn get topicName => text()();
  TextColumn get version => text()();
  TextColumn get melcCodes => text().nullable()();
  IntColumn get importedAt => integer()();

  @override
  Set<Column> get primaryKey => {packId};
}

@DataClassName('LessonStageRow')
class LessonStages extends Table {
  TextColumn get stageId => text()();
  TextColumn get packId => text().nullable().references(ContentPacks, #packId)();
  TextColumn get stageName => text().customConstraint(
      "NOT NULL CHECK (stage_name IN ('engage','explore','explain','elaborate','evaluate'))")();
  TextColumn get moduleKey => text()();
  IntColumn get sequenceOrder => integer()();
  TextColumn get displayTitle => text()();
  TextColumn get bodyJson => text()();

  @override
  Set<Column> get primaryKey => {stageId};
}

@DataClassName('QuizItemRow')
class QuizItems extends Table {
  TextColumn get itemId => text()();
  TextColumn get packId => text().nullable().references(ContentPacks, #packId)();
  TextColumn get stageId => text().nullable().references(LessonStages, #stageId)();
  TextColumn get itemType =>
      text().customConstraint("NOT NULL CHECK (item_type IN ('mcq','numeric'))")();
  TextColumn get prompt => text()();
  TextColumn get choicesJson => text().nullable()();
  TextColumn get correctAnswer => text()();
  RealColumn get tolerance => real().nullable()();
  TextColumn get explanation => text().nullable()();
  TextColumn get tosCompetency => text().nullable()();
  TextColumn get difficulty => text()
      .nullable()
      .customConstraint("CHECK (difficulty IN ('easy','average','difficult'))")();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DataClassName('MissionLevelRow')
class MissionLevels extends Table {
  TextColumn get levelId => text()();
  TextColumn get packId => text().nullable().references(ContentPacks, #packId)();
  IntColumn get levelNumber => integer()();
  TextColumn get title => text()();
  TextColumn get scenarioText => text()();
  TextColumn get givenValues => text()();
  TextColumn get targetVariable => text()();
  RealColumn get correctAnswer => real()();
  RealColumn get tolerance => real().withDefault(const Constant(0.1))();
  // Not in blueprint §5's SQL, but present on every mission_levels entry in
  // the content pack JSON and needed for the Mission Mode UI (blueprint
  // §3.3: "given values"/answer unit) — an additive, nullable extension.
  TextColumn get formulaHint => text().nullable()();
  TextColumn get unit => text().nullable()();

  @override
  Set<Column> get primaryKey => {levelId};
}

// ============ STUDENT ACTIVITY / EVIDENCE ============

@DataClassName('PredictionLogRow')
class PredictionLog extends Table {
  TextColumn get logId => text()();
  TextColumn get userId => text().nullable().references(Users, #userId)();
  TextColumn get stageId => text().nullable().references(LessonStages, #stageId)();
  TextColumn get predictedOption => text()();
  TextColumn get reasoningKey => text().nullable()();
  IntColumn get submittedAt => integer()();

  @override
  Set<Column> get primaryKey => {logId};
}

@DataClassName('MotionTrialRow')
class MotionTrials extends Table {
  TextColumn get trialId => text()();
  TextColumn get userId => text().nullable().references(Users, #userId)();
  TextColumn get groupId => text().nullable()();
  IntColumn get trialNumber => integer()();
  RealColumn get distanceM => real()();
  RealColumn get displacementM => real()();
  RealColumn get timeS => real()();
  RealColumn get computedSpeed => real().nullable()();
  RealColumn get computedVelocity => real().nullable()();
  IntColumn get recordedAt => integer()();

  @override
  Set<Column> get primaryKey => {trialId};
}

@DataClassName('MissionAttemptRow')
class MissionAttempts extends Table {
  TextColumn get attemptId => text()();
  TextColumn get userId => text().nullable().references(Users, #userId)();
  TextColumn get levelId => text().nullable().references(MissionLevels, #levelId)();
  RealColumn get submittedAnswer => real()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get attemptNumber => integer()();
  IntColumn get pointsAwarded => integer().withDefault(const Constant(0))();
  IntColumn get submittedAt => integer()();

  @override
  Set<Column> get primaryKey => {attemptId};
}

@DataClassName('QuizAttemptRow')
class QuizAttempts extends Table {
  TextColumn get attemptId => text()();
  TextColumn get userId => text().nullable().references(Users, #userId)();
  TextColumn get packId => text().nullable().references(ContentPacks, #packId)();
  TextColumn get attemptType => text()
      .nullable()
      .customConstraint(
          "CHECK (attempt_type IN ('pretest','posttest','formative'))")();
  IntColumn get startedAt => integer()();
  IntColumn get completedAt => integer().nullable()();
  RealColumn get totalScore => real().nullable()();
  RealColumn get maxScore => real().nullable()();

  @override
  Set<Column> get primaryKey => {attemptId};
}

@DataClassName('QuizItemResponseRow')
class QuizItemResponses extends Table {
  TextColumn get responseId => text()();
  TextColumn get attemptId =>
      text().nullable().references(QuizAttempts, #attemptId)();
  TextColumn get itemId => text().nullable().references(QuizItems, #itemId)();
  TextColumn get givenAnswer => text()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get timeSpentMs => integer().nullable()();
  IntColumn get answeredAt => integer()();

  @override
  Set<Column> get primaryKey => {responseId};
}

// ============ GAMIFICATION ============

@DataClassName('BadgeRow')
class Badges extends Table {
  TextColumn get badgeId => text()();
  TextColumn get badgeName => text()();
  TextColumn get description => text()();
  TextColumn get iconAsset => text()();
  TextColumn get unlockRuleJson => text()();

  @override
  Set<Column> get primaryKey => {badgeId};
}

@DataClassName('BadgeEarnedRow')
class BadgesEarned extends Table {
  TextColumn get userId => text().references(Users, #userId)();
  TextColumn get badgeId => text().references(Badges, #badgeId)();
  IntColumn get earnedAt => integer()();

  @override
  Set<Column> get primaryKey => {userId, badgeId};
}

@DataClassName('PointsLedgerRow')
class PointsLedger extends Table {
  TextColumn get entryId => text()();
  TextColumn get userId => text().nullable().references(Users, #userId)();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text().nullable()();
  IntColumn get points => integer()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {entryId};
}

// ============ SYNC / EXPORT (Tier 1, §1.3) ============

@DataClassName('ExportBundleRow')
class ExportBundles extends Table {
  TextColumn get bundleId => text()();
  TextColumn get userId => text().nullable().references(Users, #userId)();
  IntColumn get generatedAt => integer()();
  TextColumn get payloadJson => text()();
  TextColumn get importedByTeacherId => text().nullable()();
  IntColumn get importedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {bundleId};
}

// ============ APP/DEVICE SETTINGS ============

@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
