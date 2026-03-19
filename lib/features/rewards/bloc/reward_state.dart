import 'package:equatable/equatable.dart';

import '../model/reward_models.dart';

abstract class RewardState extends Equatable {
  const RewardState();

  @override
  List<Object?> get props => [];
}

class RewardInitial extends RewardState {
  const RewardInitial();
}

class RewardLoading extends RewardState {
  const RewardLoading();
}

class RewardLoaded extends RewardState {
  const RewardLoaded({
    required this.points,
    required this.tier,
    required this.history,
    required this.chartData,
    required this.redeemableRewards,
  });

  final int points;
  final RewardTier tier;
  final List<PointsTransaction> history;
  final List<DailyPointsData> chartData;
  final List<RedeemableReward> redeemableRewards;

  @override
  List<Object?> get props => [points, tier, history, redeemableRewards];
}

class RewardError extends RewardState {
  const RewardError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class LeaderboardLoaded extends RewardState {
  const LeaderboardLoaded(this.entries);

  final List<LeaderboardEntry> entries;

  @override
  List<Object?> get props => [entries];
}

class RedeemSuccess extends RewardState {
  const RedeemSuccess({required this.newPoints});

  final int newPoints;

  @override
  List<Object?> get props => [newPoints];
}
