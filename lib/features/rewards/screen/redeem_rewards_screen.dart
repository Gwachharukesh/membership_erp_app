import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mart_erp/common/widgets/reward_points_badge.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';
import 'package:mart_erp/features/rewards/bloc/reward_bloc.dart';
import 'package:mart_erp/features/rewards/bloc/reward_event.dart';
import 'package:mart_erp/features/rewards/bloc/reward_state.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';

class RedeemRewardsScreen extends StatelessWidget {
  const RedeemRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redeem Rewards')),
      body: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {
          if (state is RedeemSuccess) {
            _showSuccessAndPop(context, state.newPoints);
          }
        },
        builder: (context, state) {
          if (state is RewardLoaded) {
            return _RedeemCatalog(rewards: state.redeemableRewards, points: state.points);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showSuccessAndPop(BuildContext context, int newPoints) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.network(
              'https://lottie.host/5b35d664-7292-493e-9e62-4d2a23e60b08/6pi7HYCYVI.json',
              fit: BoxFit.contain,
              height: 120,
              repeat: false,
              errorBuilder: (_, __, ___) => Icon(Icons.check_circle, size: 80, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text('Redeemed successfully!', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('New balance: $newPoints pts', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _RedeemCatalog extends StatelessWidget {
  const _RedeemCatalog({
    required this.rewards,
    required this.points,
  });

  final List<RedeemableReward> rewards;
  final int points;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final r = rewards[index];
        return _RedeemCard(
          reward: r,
          canAfford: points >= r.pointCost,
          onRedeem: () => _confirmRedeem(context, r),
        );
      },
    );
  }

  void _confirmRedeem(BuildContext context, RedeemableReward r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Redeem ${r.name}?'),
        content: Text(
          'This will deduct ${r.pointCost} points from your balance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RewardBloc>().add(RedeemReward(
                userId: 'mock_user',
                rewardId: r.id,
                pointCost: r.pointCost,
                rewardName: r.name,
              ));
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }
}

class _RedeemCard extends StatelessWidget {
  const _RedeemCard({
    required this.reward,
    required this.canAfford,
    required this.onRedeem,
  });

  final RedeemableReward reward;
  final bool canAfford;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: reward.imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (_, __) => const ShimmerLoader(width: 100, height: 100),
            errorWidget: (_, __, ___) => Container(
              width: 100,
              height: 100,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.card_giftcard, size: 48),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  RewardPointsBadge(points: reward.pointCost, size: 14),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canAfford ? onRedeem : null,
                      child: Text(canAfford ? 'Redeem' : 'Insufficient points'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
