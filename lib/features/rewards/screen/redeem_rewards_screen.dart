import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/rewards/bloc/reward_bloc.dart';
import 'package:mart_erp/features/rewards/bloc/reward_event.dart';
import 'package:mart_erp/features/rewards/bloc/reward_state.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';

class RedeemRewardsScreen extends StatelessWidget {
  const RedeemRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? colors.surface : Colors.white;
    final gapColor = isDark ? colors.surfaceContainerHighest : const Color(0xFFF1F1F1);

    return Scaffold(
      backgroundColor: gapColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Redeem Rewards',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {
          if (state is RedeemSuccess) {
            _showSuccessDialog(context, state.newPoints);
          }
        },
        builder: (context, state) {
          if (state is RewardLoaded) {
            return _RedeemBody(
              rewards: state.redeemableRewards,
              points: state.points,
              cardBg: cardBg,
              gapColor: gapColor,
            );
          }
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, int newPoints) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Lottie.network(
                  'https://lottie.host/5b35d664-7292-493e-9e62-4d2a23e60b08/6pi7HYCYVI.json',
                  fit: BoxFit.contain,
                  repeat: false,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: AppColors.successColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Redeemed Successfully!',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Your reward has been applied to your account.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars_rounded, size: 20, color: colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'New Balance: $newPoints pts',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Redeem Body ─────────────────────────────────────────────────────────────

class _RedeemBody extends StatelessWidget {
  const _RedeemBody({
    required this.rewards,
    required this.points,
    required this.cardBg,
    required this.gapColor,
  });

  final List<RedeemableReward> rewards;
  final int points;
  final Color cardBg;
  final Color gapColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        // Points balance bar
        SliverToBoxAdapter(
          child: Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.stars_rounded, color: colors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Points',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        '$points points',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 8, child: ColoredBox(color: gapColor))),

        // Section header
        SliverToBoxAdapter(
          child: Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.card_giftcard_outlined, size: 20, color: AppColors.reward),
                const SizedBox(width: 8),
                Text(
                  'Available Rewards',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '${rewards.length} items',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Reward cards
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final r = rewards[index];
              final canAfford = points >= r.pointCost;
              return Container(
                color: cardBg,
                child: _RedeemCard(
                  reward: r,
                  canAfford: canAfford,
                  onRedeem: () => _confirmRedeem(context, r),
                ),
              );
            },
            childCount: rewards.length,
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  void _confirmRedeem(BuildContext context, RedeemableReward r) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.reward.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.card_giftcard_rounded, size: 32, color: AppColors.reward),
            ),
            const SizedBox(height: 16),
            Text(
              'Redeem ${r.name}?',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'This will deduct ${r.pointCost} points from your balance.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Balance after: ${points - r.pointCost} pts',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
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
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

// ─── Redeem Card ─────────────────────────────────────────────────────────────

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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outline.withValues(alpha: 0.12)),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: canAfford ? onRedeem : null,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: reward.imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 110,
                      height: 110,
                      color: colors.surfaceContainerHighest,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 110,
                      height: 110,
                      color: colors.surfaceContainerHighest,
                      child: Icon(Icons.card_giftcard_outlined, size: 40, color: colors.outline),
                    ),
                  ),
                ),
                // Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (reward.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            reward.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.reward.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.stars_rounded, size: 14, color: AppColors.reward),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${reward.pointCost} pts',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppColors.reward,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 32,
                              child: canAfford
                                  ? FilledButton(
                                      onPressed: onRedeem,
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      child: const Text('Redeem'),
                                    )
                                  : OutlinedButton(
                                      onPressed: null,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      child: Text(
                                        'Need more',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: colors.outline,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
