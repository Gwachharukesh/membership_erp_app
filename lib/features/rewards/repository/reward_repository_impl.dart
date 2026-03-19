import 'package:mart_erp/features/rewards/repository/reward_repository.dart';

import '../model/reward_models.dart';

/// Mock implementation - replace with Firestore in production.
/// Firestore structure: users/{userId}/rewards/transactions, points, tier.
class RewardRepositoryImpl implements RewardRepository {
  int _mockPoints = 2450;
  RewardTier _mockTier = RewardTier.silver;
  final List<PointsTransaction> _mockHistory = [];
  bool _initialized = false;

  Future<void> _ensureMockData() async {
    if (_initialized) return;
    _initialized = true;
    _mockHistory.addAll([
      PointsTransaction(
        id: 't1',
        description: 'Purchase - Groceries',
        points: 150,
        date: DateTime.now().subtract(const Duration(days: 1)),
        runningBalance: 2450,
        type: TransactionType.earn,
      ),
      PointsTransaction(
        id: 't2',
        description: 'Redeemed - Free Delivery',
        points: -200,
        date: DateTime.now().subtract(const Duration(days: 3)),
        runningBalance: 2300,
        type: TransactionType.redeem,
      ),
      PointsTransaction(
        id: 't3',
        description: 'Daily Check-in',
        points: 10,
        date: DateTime.now().subtract(const Duration(days: 4)),
        runningBalance: 2500,
        type: TransactionType.earn,
      ),
      PointsTransaction(
        id: 't4',
        description: 'Purchase - Special Product (2x)',
        points: 80,
        date: DateTime.now().subtract(const Duration(days: 5)),
        runningBalance: 2490,
        type: TransactionType.earn,
      ),
    ]);
  }

  @override
  Future<int> getPointsBalance(String userId) async {
    await _ensureMockData();
    return _mockPoints;
  }

  @override
  Future<RewardTier> getTier(String userId) async {
    await _ensureMockData();
    return _mockTier;
  }

  @override
  Future<List<PointsTransaction>> getPointsHistory(String userId) async {
    await _ensureMockData();
    final sorted = List<PointsTransaction>.from(_mockHistory)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  @override
  Future<List<DailyPointsData>> get30DayPointsChart(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return List.generate(30, (i) {
      final d = now.subtract(Duration(days: 29 - i));
      return DailyPointsData(
        date: d,
        pointsEarned: (i % 3 == 0 ? 50 : 0) + (i % 5 == 0 ? 100 : 0) + 10,
      );
    });
  }

  @override
  Future<List<RedeemableReward>> getRedeemableRewards() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const RedeemableReward(
        id: 'r1',
        name: 'Free Delivery Voucher',
        pointCost: 200,
        imageUrl: 'https://picsum.photos/200/150?random=delivery',
      ),
      const RedeemableReward(
        id: 'r2',
        name: '10% Off Next Order',
        pointCost: 500,
        imageUrl: 'https://picsum.photos/200/150?random=discount',
      ),
      const RedeemableReward(
        id: 'r3',
        name: 'Free 1kg Rice',
        pointCost: 800,
        imageUrl: 'https://picsum.photos/200/150?random=rice',
      ),
      const RedeemableReward(
        id: 'r4',
        name: 'NPR 100 Credit',
        pointCost: 1000,
        imageUrl: 'https://picsum.photos/200/150?random=credit',
      ),
    ];
  }

  @override
  Future<void> redeemReward(String userId, String rewardId, int pointCost) async {
    await _ensureMockData();
    if (_mockPoints < pointCost) throw Exception('Insufficient points');
    _mockPoints -= pointCost;
    _mockHistory.insert(
      0,
      PointsTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        description: 'Redeemed reward',
        points: -pointCost,
        date: DateTime.now(),
        runningBalance: _mockPoints,
        type: TransactionType.redeem,
      ),
    );
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      LeaderboardEntry(rank: 1, userId: 'u1', displayName: 'Ram Shrestha', points: 12500, tier: RewardTier.gold),
      LeaderboardEntry(rank: 2, userId: 'u2', displayName: 'Sita Maharjan', points: 9800, tier: RewardTier.gold),
      LeaderboardEntry(rank: 3, userId: 'u3', displayName: 'Krishna Poudel', points: 7200, tier: RewardTier.silver),
      LeaderboardEntry(rank: 4, userId: 'u4', displayName: 'Priya Adhikari', points: 5800, tier: RewardTier.silver),
      LeaderboardEntry(rank: 5, userId: 'u5', displayName: 'Anil KC', points: 4200, tier: RewardTier.silver),
    ];
  }

  @override
  int calculatePurchasePoints(double amountNpr, {bool isSpecialProduct = false}) {
    final base = (amountNpr / 100).floor() * 10;
    return (isSpecialProduct ? base * 2 : base).round();
  }

  @override
  Future<void> earnPoints(String userId, int points, String description) async {
    await _ensureMockData();
    _mockPoints += points;
    _mockHistory.insert(
      0,
      PointsTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        description: description,
        points: points,
        date: DateTime.now(),
        runningBalance: _mockPoints,
        type: TransactionType.earn,
      ),
    );
  }
}
