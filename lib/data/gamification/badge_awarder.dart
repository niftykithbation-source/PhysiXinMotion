import '../../core/gamification/badge_rule_evaluator.dart';
import '../../core/gamification/badge_unlock_rule.dart';
import '../db/database.dart';
import 'student_stats_repository.dart';

/// Blueprint §7 Step 4.1: checks every badge not yet earned by [userId]
/// against their current stats, and records any newly-unlocked ones.
/// Idempotent — badges already in badges_earned are never re-evaluated or
/// re-inserted.
class BadgeAwarder {
  final AppDatabase db;
  final StudentStatsRepository statsRepository;

  BadgeAwarder(this.db) : statsRepository = StudentStatsRepository(db);

  Future<List<BadgeRow>> checkAndAwardBadges({
    required String userId,
    required String packId,
  }) async {
    final stats = await statsRepository.computeStats(userId: userId, packId: packId);
    final allBadges = await db.select(db.badges).get();
    final earned = await (db.select(db.badgesEarned)..where((t) => t.userId.equals(userId))).get();
    final earnedIds = earned.map((e) => e.badgeId).toSet();

    final newlyAwarded = <BadgeRow>[];
    for (final badge in allBadges) {
      if (earnedIds.contains(badge.badgeId)) continue;

      final rule = BadgeUnlockRule.fromJson(badge.unlockRuleJson);
      if (!BadgeRuleEvaluator.isUnlocked(rule, stats)) continue;

      await db.into(db.badgesEarned).insert(BadgesEarnedCompanion.insert(
            userId: userId,
            badgeId: badge.badgeId,
            earnedAt: DateTime.now().millisecondsSinceEpoch,
          ));
      newlyAwarded.add(badge);
    }
    return newlyAwarded;
  }
}
