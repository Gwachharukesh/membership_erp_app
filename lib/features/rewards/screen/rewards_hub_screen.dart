import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/common/widgets/reward_points_badge.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';
import 'package:mart_erp/config/routes/routes.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/config/theme/app_spacing.dart';
import 'package:mart_erp/features/rewards/bloc/reward_bloc.dart';
import 'package:mart_erp/features/rewards/bloc/reward_event.dart';
import 'package:mart_erp/features/rewards/repository/reward_repository_impl.dart';
import 'package:mart_erp/features/rewards/bloc/reward_state.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';
import 'package:mart_erp/features/rewards/screen/points_history_screen.dart';
import 'package:mart_erp/features/rewards/screen/redeem_rewards_screen.dart';
import 'package:mart_erp/features/rewards/screen/tier_status_screen.dart';

class RewardsHubScreen extends StatelessWidget {
  const RewardsHubScreen({super.key});

  static const routeName = '/rewards_hub';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardBloc(RewardRepositoryImpl())..add(const LoadRewards()),
      child: const _RewardsHubView(),
    );
  }
}

class _RewardsHubView extends StatelessWidget {
  const _RewardsHubView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.pushNamed(context, RouteHelper.leaderboard),
          ),
          IconButton(
            icon: const Icon(Icons.workspace_premium),
            onPressed: () {
              final state = context.read<RewardBloc>().state;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TierStatusScreen(
                    currentTier: state is RewardLoaded ? state.tier : RewardTier.silver,
                    currentPoints: state is RewardLoaded ? state.points : 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RewardBloc, RewardState>(
        builder: (context, state) {
          if (state is RewardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<RewardBloc>().add(const LoadRewards()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is RewardLoading) {
            return const _ShimmerBody();
          }
          if (state is RewardLoaded) {
            return _RewardsHubBody(
              points: state.points,
              tier: state.tier,
              redeemableRewards: state.redeemableRewards,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ShimmerBody extends StatelessWidget {
  const _ShimmerBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screen,
      child: Column(
        children: [
          const ShimmerLoader(width: 160, height: 160, borderRadius: 80),
          const SizedBox(height: 24),
          ShimmerLoader(width: 120, height: 32, borderRadius: 8),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (_) => const ShimmerLoader(width: 90, height: 80, borderRadius: 12)),
          ),
          const SizedBox(height: 32),
          const ShimmerLoader(width: double.infinity, height: 120, borderRadius: 16),
          const SizedBox(height: 24),
          const ShimmerLoader(width: double.infinity, height: 200, borderRadius: 12),
        ],
      ),
    );
  }
}

class _RewardsHubBody extends StatelessWidget {
  const _RewardsHubBody({
    required this.points,
    required this.tier,
    required this.redeemableRewards,
  });

  final int points;
  final RewardTier tier;
  final List<RedeemableReward> redeemableRewards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AnimatedPointsBalance(points: points),
          const SizedBox(height: 24),
          _TierCard(tier: tier, points: points),
          const SizedBox(height: 24),
          _QuickActions(context: context),
          const SizedBox(height: 28),
          Text(
            'Featured Rewards',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: redeemableRewards.length,
            itemBuilder: (context, index) {
              final r = redeemableRewards[index];
              return _FeaturedRewardCard(
                reward: r,
                onTap: () => _navigateToRedeem(context),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToRedeem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BlocProvider.value(
        value: context.read<RewardBloc>(),
        child: const RedeemRewardsScreen(),
      )),
    );
  }
}

class _AnimatedPointsBalance extends StatelessWidget {
  const _AnimatedPointsBalance({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: points.toDouble()),
        duration: const Duration(milliseconds: 1200),
        builder: (context, value, _) {
          return Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colors.points, colors.pointsContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.points.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.points,
                    ),
                  ),
                  Text(
                    'Points',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.points.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier, required this.points});

  final RewardTier tier;
  final int points;

  @override
  Widget build(BuildContext context) {
    final progress = (points - tier.minPoints) / (tier.nextTierPoints - tier.minPoints).clamp(0.001, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tier.displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${points - tier.minPoints} / ${tier.nextTierPoints - tier.minPoints} to ${_nextTierName}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _nextTierName {
    switch (tier) {
      case RewardTier.bronze: return 'Silver';
      case RewardTier.silver: return 'Gold';
      case RewardTier.gold: return 'Platinum';
      case RewardTier.platinum: return 'Max';
    }
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.add_circle_outline,
            label: 'Earn More',
            onTap: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.card_giftcard,
            label: 'Redeem',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlocProvider.value(
                value: context.read<RewardBloc>(),
                child: const RedeemRewardsScreen(),
              )),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.history,
            label: 'History',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlocProvider.value(
                value: context.read<RewardBloc>(),
                child: const PointsHistoryScreen(),
              )),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedRewardCard extends StatelessWidget {
  const _FeaturedRewardCard({
    required this.reward,
    required this.onTap,
  });

  final RedeemableReward reward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: reward.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) => const ShimmerLoader(height: double.infinity, width: double.infinity),
                errorWidget: (_, __, ___) => const Icon(Icons.card_giftcard, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  RewardPointsBadge(points: reward.pointCost, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
