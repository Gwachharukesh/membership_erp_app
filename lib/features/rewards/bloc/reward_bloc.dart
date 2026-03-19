import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/reward_repository.dart';
import 'reward_event.dart';
import 'reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  RewardBloc(this._repository) : super(const RewardInitial()) {
    on<LoadRewards>(_onLoadRewards);
    on<EarnPoints>(_onEarnPoints);
    on<RedeemReward>(_onRedeemReward);
    on<LoadLeaderboard>(_onLoadLeaderboard);
  }

  final RewardRepository _repository;

  Future<void> _onLoadRewards(LoadRewards event, Emitter<RewardState> emit) async {
    emit(const RewardLoading());
    try {
      final points = await _repository.getPointsBalance(event.userId);
      final tier = await _repository.getTier(event.userId);
      final history = await _repository.getPointsHistory(event.userId);
      final chartData = await _repository.get30DayPointsChart(event.userId);
      final rewards = await _repository.getRedeemableRewards();
      emit(RewardLoaded(
        points: points,
        tier: tier,
        history: history,
        chartData: chartData,
        redeemableRewards: rewards,
      ));
    } catch (e, _) {
      emit(RewardError(e.toString()));
    }
  }

  Future<void> _onEarnPoints(EarnPoints event, Emitter<RewardState> emit) async {
    final current = state;
    if (current is! RewardLoaded) return;
    try {
      await _repository.earnPoints(event.userId, event.points, event.description);
      add(LoadRewards(userId: event.userId));
    } catch (e, _) {
      emit(RewardError(e.toString()));
    }
  }

  Future<void> _onRedeemReward(RedeemReward event, Emitter<RewardState> emit) async {
    try {
      await _repository.redeemReward(event.userId, event.rewardId, event.pointCost);
      final points = await _repository.getPointsBalance(event.userId);
      emit(RedeemSuccess(newPoints: points));
      add(LoadRewards(userId: event.userId));
    } catch (e, _) {
      emit(RewardError(e.toString()));
    }
  }

  Future<void> _onLoadLeaderboard(LoadLeaderboard event, Emitter<RewardState> emit) async {
    try {
      final entries = await _repository.getLeaderboard();
      emit(LeaderboardLoaded(entries));
    } catch (e, _) {
      emit(RewardError(e.toString()));
    }
  }
}
