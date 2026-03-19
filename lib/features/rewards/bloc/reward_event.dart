import 'package:equatable/equatable.dart';

abstract class RewardEvent extends Equatable {
  const RewardEvent();

  @override
  List<Object?> get props => [];
}

class LoadRewards extends RewardEvent {
  const LoadRewards({this.userId = 'mock_user'});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class EarnPoints extends RewardEvent {
  const EarnPoints({
    required this.userId,
    required this.points,
    required this.description,
  });

  final String userId;
  final int points;
  final String description;

  @override
  List<Object?> get props => [userId, points, description];
}

class RedeemReward extends RewardEvent {
  const RedeemReward({
    required this.userId,
    required this.rewardId,
    required this.pointCost,
    required this.rewardName,
  });

  final String userId;
  final String rewardId;
  final int pointCost;
  final String rewardName;

  @override
  List<Object?> get props => [userId, rewardId, pointCost];
}

class LoadLeaderboard extends RewardEvent {
  const LoadLeaderboard();
}
