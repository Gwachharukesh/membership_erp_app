import '../model/reward_models.dart';

/// Abstract repository for rewards. Implement with Firestore or API.
abstract class RewardRepository {
  /// Get current user's points balance
  Future<int> getPointsBalance(String userId);

  /// Get current user's tier
  Future<RewardTier> getTier(String userId);

  /// Get points history (reverse chronological)
  Future<List<PointsTransaction>> getPointsHistory(String userId);

  /// Get 30-day points earned chart data
  Future<List<DailyPointsData>> get30DayPointsChart(String userId);

  /// Get redeemable rewards catalog
  Future<List<RedeemableReward>> getRedeemableRewards();

  /// Redeem a reward (deduct points)
  Future<void> redeemReward(String userId, String rewardId, int pointCost);

  /// Get monthly leaderboard (top 10)
  Future<List<LeaderboardEntry>> getLeaderboard();

  /// Calculate points: NPR 100 = 10 base, 2x special, birthday +500, check-in +10
  int calculatePurchasePoints(double amountNpr, {bool isSpecialProduct = false});

  /// Record points earned (purchase, birthday, check-in)
  Future<void> earnPoints(String userId, int points, String description);
}
