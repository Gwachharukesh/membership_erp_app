import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/features/rewards/bloc/reward_bloc.dart';
import 'package:mart_erp/features/rewards/repository/reward_repository_impl.dart';
import 'package:mart_erp/features/rewards/bloc/reward_event.dart';
import 'package:mart_erp/features/rewards/bloc/reward_state.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const routeName = '/leaderboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: BlocProvider(
        create: (_) => RewardBloc(RewardRepositoryImpl())..add(const LoadLeaderboard()),
        child: BlocBuilder<RewardBloc, RewardState>(
          builder: (context, state) {
            if (state is LeaderboardLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  final e = state.entries[index];
                  return _LeaderboardTile(entry: e);
                },
              );
            }
            if (state is RewardError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _tierColor(entry.tier),
          child: Text(
            '${entry.rank}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(entry.displayName),
        subtitle: Text(entry.tier.displayName, style: TextStyle(color: _tierColor(entry.tier))),
        trailing: Text(
          '${entry.points} pts',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _tierColor(RewardTier tier) {
    switch (tier) {
      case RewardTier.bronze: return const Color(0xFFCD7F32);
      case RewardTier.silver: return const Color(0xFFC0C0C0);
      case RewardTier.gold: return const Color(0xFFFFD700);
      case RewardTier.platinum: return const Color(0xFFE5E4E2);
    }
  }
}
