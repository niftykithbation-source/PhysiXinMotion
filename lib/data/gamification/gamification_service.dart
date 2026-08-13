import '../db/database.dart';
import 'badge_awarder.dart';
import 'points_ledger_writer.dart';

class GamificationOutcome {
  final int pointsAwarded;
  final List<BadgeRow> newlyUnlockedBadges;

  const GamificationOutcome({required this.pointsAwarded, required this.newlyUnlockedBadges});
}

/// Orchestrates the gamification engine: called by Student Portal screens
/// right after they write a mission_attempts or completed quiz_attempts
/// row, so points and badge unlocks happen automatically on completion
/// (blueprint §7 Step 4.2/4.3). No screen calls this yet — Mission Mode and
/// the Evaluation Terminal ship in Step 5.
class GamificationService {
  final AppDatabase db;
  late final PointsLedgerWriter _pointsWriter = PointsLedgerWriter(db);
  late final BadgeAwarder _badgeAwarder = BadgeAwarder(db);

  GamificationService(this.db);

  Future<GamificationOutcome> onMissionAttemptRecorded(MissionAttemptRow attempt) async {
    final points = await _pointsWriter.writeForMissionAttempt(attempt);

    final userId = attempt.userId;
    final packId = await _packIdForMissionLevel(attempt.levelId);
    if (userId == null || packId == null) {
      return GamificationOutcome(pointsAwarded: points, newlyUnlockedBadges: const []);
    }

    final newBadges = await _badgeAwarder.checkAndAwardBadges(userId: userId, packId: packId);
    return GamificationOutcome(pointsAwarded: points, newlyUnlockedBadges: newBadges);
  }

  Future<GamificationOutcome> onQuizAttemptCompleted(QuizAttemptRow attempt) async {
    final points = await _pointsWriter.writeForQuizAttempt(attempt);

    final userId = attempt.userId;
    final packId = attempt.packId;
    if (userId == null || packId == null) {
      return GamificationOutcome(pointsAwarded: points, newlyUnlockedBadges: const []);
    }

    final newBadges = await _badgeAwarder.checkAndAwardBadges(userId: userId, packId: packId);
    return GamificationOutcome(pointsAwarded: points, newlyUnlockedBadges: newBadges);
  }

  Future<String?> _packIdForMissionLevel(String? levelId) async {
    if (levelId == null) return null;
    final level = await (db.select(db.missionLevels)..where((t) => t.levelId.equals(levelId)))
        .getSingleOrNull();
    return level?.packId;
  }
}
