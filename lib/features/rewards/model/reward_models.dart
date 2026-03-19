import 'package:equatable/equatable.dart';

/// Membership tier: Bronze, Silver, Gold, Platinum
enum RewardTier {
  bronze,
  silver,
  gold,
  platinum;

  int get minPoints {
    switch (this) {
      case RewardTier.bronze:
        return 0;
      case RewardTier.silver:
        return 1000;
      case RewardTier.gold:
        return 5000;
      case RewardTier.platinum:
        return 15000;
    }
  }

  int get nextTierPoints {
    switch (this) {
      case RewardTier.bronze:
        return 1000;
      case RewardTier.silver:
        return 5000;
      case RewardTier.gold:
        return 15000;
      case RewardTier.platinum:
        return 50000;
    }
  }

  String get displayName => name[0].toUpperCase() + name.substring(1);
}

/// Point transaction: earn (+) or redeem (-)
class PointsTransaction extends Equatable {
  const PointsTransaction({
    required this.id,
    required this.description,
    required this.points,
    required this.date,
    required this.runningBalance,
    this.type = TransactionType.earn,
  });

  final String id;
  final String description;
  final int points; // positive for earn, negative for redeem
  final DateTime date;
  final int runningBalance;
  final TransactionType type;

  @override
  List<Object?> get props => [id, description, points, date, runningBalance];
}

enum TransactionType { earn, redeem }

/// Redeemable reward item
class RedeemableReward extends Equatable {
  const RedeemableReward({
    required this.id,
    required this.name,
    required this.pointCost,
    required this.imageUrl,
    this.description,
  });

  final String id;
  final String name;
  final int pointCost;
  final String imageUrl;
  final String? description;

  @override
  List<Object?> get props => [id, name, pointCost];
}

/// Leaderboard entry
class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.points,
    required this.tier,
    this.avatarUrl,
  });

  final int rank;
  final String userId;
  final String displayName;
  final int points;
  final RewardTier tier;
  final String? avatarUrl;

  @override
  List<Object?> get props => [rank, userId, points];
}

/// 30-day chart data point
class DailyPointsData extends Equatable {
  const DailyPointsData({
    required this.date,
    required this.pointsEarned,
  });

  final DateTime date;
  final int pointsEarned;

  @override
  List<Object?> get props => [date, pointsEarned];
}
