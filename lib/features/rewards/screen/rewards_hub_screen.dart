import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/common/widgets/reward_points_badge.dart';
import 'package:mart_erp/config/routes/routes.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/rewards/bloc/reward_bloc.dart';
import 'package:mart_erp/features/rewards/bloc/reward_event.dart';
import 'package:mart_erp/features/rewards/bloc/reward_state.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';
import 'package:mart_erp/features/rewards/repository/reward_repository_impl.dart';
import 'package:mart_erp/features/rewards/screen/points_history_screen.dart';
import 'package:mart_erp/features/rewards/screen/redeem_rewards_screen.dart';
import 'package:mart_erp/features/rewards/screen/tier_status_screen.dart';
import 'package:shimmer/shimmer.dart';

const _gap = 8.0;

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
          'Rewards',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, RouteHelper.leaderboard),
            icon: const Icon(Icons.leaderboard_outlined, size: 22),
            tooltip: 'Leaderboard',
          ),
          IconButton(
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
            icon: const Icon(Icons.workspace_premium_outlined, size: 22),
            tooltip: 'Tier Status',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<RewardBloc, RewardState>(
        builder: (context, state) {
          if (state is RewardError) {
            return _ErrorState(message: state.message);
          }
          if (state is RewardLoading) {
            return _ShimmerBody(isDark: isDark, cardBg: cardBg, gapColor: gapColor);
          }
          if (state is RewardLoaded) {
            return _RewardsBody(
              points: state.points,
              tier: state.tier,
              redeemableRewards: state.redeemableRewards,
              cardBg: cardBg,
              gapColor: gapColor,
            );
          }
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      ),
    );
  }
}

// ─── Main Body ───────────────────────────────────────────────────────────────

class _RewardsBody extends StatelessWidget {
  const _RewardsBody({
    required this.points,
    required this.tier,
    required this.redeemableRewards,
    required this.cardBg,
    required this.gapColor,
  });

  final int points;
  final RewardTier tier;
  final List<RedeemableReward> redeemableRewards;
  final Color cardBg;
  final Color gapColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        // ── Points Hero Card ──
        SliverToBoxAdapter(
          child: Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: _PointsHero(points: points, tier: tier),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: _gap, child: ColoredBox(color: gapColor))),

        // ── Quick Actions ──
        SliverToBoxAdapter(
          child: Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                _QuickAction(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Earn\nMore',
                  color: colors.primary,
                  onTap: () => Navigator.pop(context),
                ),
                _QuickAction(
                  icon: Icons.card_giftcard_outlined,
                  label: 'Redeem\nRewards',
                  color: AppColors.reward,
                  onTap: () => _pushRedeem(context),
                ),
                _QuickAction(
                  icon: Icons.history_rounded,
                  label: 'Points\nHistory',
                  color: AppColors.successColor,
                  onTap: () => _pushHistory(context),
                ),
                _QuickAction(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Tier\nStatus',
                  color: const Color(0xFFE040FB),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TierStatusScreen(currentTier: tier, currentPoints: points),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: _gap, child: ColoredBox(color: gapColor))),

        // ── Tier Progress Card ──
        SliverToBoxAdapter(
          child: Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: _TierProgressCard(tier: tier, points: points),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: _gap, child: ColoredBox(color: gapColor))),

        // ── How to Earn ──
        SliverToBoxAdapter(
          child: Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: _HowToEarnSection(),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: _gap, child: ColoredBox(color: gapColor))),

        // ── Featured Rewards ──
        if (redeemableRewards.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 20, color: AppColors.reward),
                  const SizedBox(width: 8),
                  Text(
                    'Featured Rewards',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _pushRedeem(context),
                    child: Text(
                      'View All',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: redeemableRewards.length,
                itemBuilder: (context, i) => _FeaturedRewardCard(
                  reward: redeemableRewards[i],
                  onTap: () => _pushRedeem(context),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: _gap, child: ColoredBox(color: gapColor))),
        ],

        SliverToBoxAdapter(child: SizedBox(height: _gap + 16)),
      ],
    );
  }

  void _pushRedeem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<RewardBloc>(),
          child: const RedeemRewardsScreen(),
        ),
      ),
    );
  }

  void _pushHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<RewardBloc>(),
          child: const PointsHistoryScreen(),
        ),
      ),
    );
  }
}

// ─── Points Hero ─────────────────────────────────────────────────────────────

class _PointsHero extends StatelessWidget {
  const _PointsHero({required this.points, required this.tier});

  final int points;
  final RewardTier tier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: points.toDouble()),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colors.primary,
                    colors.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars_rounded, size: 28, color: Colors.white),
                  const SizedBox(height: 4),
                  Text(
                    value.toInt().toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'POINTS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: _tierColor(tier).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium_rounded, size: 16, color: _tierColor(tier)),
              const SizedBox(width: 6),
              Text(
                '${tier.displayName} Member',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _tierColor(tier),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Quick Action ────────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tier Progress ───────────────────────────────────────────────────────────

class _TierProgressCard extends StatelessWidget {
  const _TierProgressCard({required this.tier, required this.points});

  final RewardTier tier;
  final int points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final range = tier.nextTierPoints - tier.minPoints;
    final progress = range > 0 ? ((points - tier.minPoints) / range).clamp(0.0, 1.0) : 1.0;
    final remaining = (tier.nextTierPoints - points).clamp(0, tier.nextTierPoints);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up_rounded, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'Tier Progress',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TierBadge(label: tier.displayName, color: _tierColor(tier), isActive: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: colors.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(_tierColor(tier)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$remaining pts to ${_nextTierName(tier)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _TierBadge(label: _nextTierName(tier), color: _nextTierColor(tier), isActive: false),
          ],
        ),
      ],
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.label, required this.color, required this.isActive});

  final String label;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isActive ? Colors.white : color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── How to Earn ─────────────────────────────────────────────────────────────

class _HowToEarnSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded, size: 20, color: AppColors.reward),
            const SizedBox(width: 8),
            Text(
              'How to Earn Points',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _EarnTile(
          icon: Icons.shopping_cart_outlined,
          title: 'Shop & Earn',
          desc: 'Earn 10 points for every NPR 100 spent',
          color: colors.primary,
        ),
        _EarnTile(
          icon: Icons.cake_outlined,
          title: 'Birthday Bonus',
          desc: 'Get 500 bonus points on your birthday',
          color: AppColors.errorColor,
        ),
        _EarnTile(
          icon: Icons.calendar_today_outlined,
          title: 'Daily Check-in',
          desc: 'Open the app daily to earn 10 points',
          color: AppColors.successColor,
        ),
        _EarnTile(
          icon: Icons.share_outlined,
          title: 'Refer Friends',
          desc: 'Earn 200 points for each successful referral',
          color: AppColors.reward,
          showDivider: false,
        ),
      ],
    );
  }
}

class _EarnTile extends StatelessWidget {
  const _EarnTile({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.55),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: colors.outline.withValues(alpha: 0.1)),
      ],
    );
  }
}

// ─── Featured Reward Card ────────────────────────────────────────────────────

class _FeaturedRewardCard extends StatelessWidget {
  const _FeaturedRewardCard({required this.reward, required this.onTap});

  final RedeemableReward reward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline.withValues(alpha: 0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: reward.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (_, __) => Container(color: colors.surfaceContainerHighest),
                    errorWidget: (_, __, ___) => Container(
                      color: colors.surfaceContainerHighest,
                      child: Icon(Icons.card_giftcard_outlined, size: 40, color: colors.outline),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    RewardPointsBadge(points: reward.pointCost, size: 13),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Error State ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded, size: 40, color: colors.error),
            ),
            const SizedBox(height: 20),
            Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            SizedBox(
              width: 140,
              height: 44,
              child: FilledButton.icon(
                onPressed: () => context.read<RewardBloc>().add(const LoadRewards()),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer Loading ─────────────────────────────────────────────────────────

class _ShimmerBody extends StatelessWidget {
  const _ShimmerBody({required this.isDark, required this.cardBg, required this.gapColor});

  final bool isDark;
  final Color cardBg;
  final Color gapColor;

  @override
  Widget build(BuildContext context) {
    final base = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final highlight = isDark ? Colors.grey[600]! : Colors.grey[50]!;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: cardBg),
                ),
              ),
            ),
          ),
          SizedBox(height: _gap, child: ColoredBox(color: gapColor)),
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(20),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (_) => Column(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14)),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 40, height: 10, color: cardBg),
                  ],
                )),
              ),
            ),
          ),
          SizedBox(height: _gap, child: ColoredBox(color: gapColor)),
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Column(
                children: [
                  Container(width: double.infinity, height: 16, color: cardBg),
                  const SizedBox(height: 16),
                  Container(width: double.infinity, height: 8, color: cardBg),
                  const SizedBox(height: 12),
                  Container(width: 200, height: 12, color: cardBg),
                ],
              ),
            ),
          ),
          SizedBox(height: _gap, child: ColoredBox(color: gapColor)),
          Container(
            color: cardBg,
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(width: 120, height: 12, color: cardBg),
                        const SizedBox(height: 6),
                        Container(width: double.infinity, height: 10, color: cardBg),
                      ])),
                    ],
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

Color _tierColor(RewardTier t) {
  switch (t) {
    case RewardTier.bronze:
      return const Color(0xFFCD7F32);
    case RewardTier.silver:
      return const Color(0xFF9E9E9E);
    case RewardTier.gold:
      return const Color(0xFFFFB300);
    case RewardTier.platinum:
      return const Color(0xFF7B1FA2);
  }
}

Color _nextTierColor(RewardTier t) {
  switch (t) {
    case RewardTier.bronze:
      return const Color(0xFF9E9E9E);
    case RewardTier.silver:
      return const Color(0xFFFFB300);
    case RewardTier.gold:
      return const Color(0xFF7B1FA2);
    case RewardTier.platinum:
      return const Color(0xFF7B1FA2);
  }
}

String _nextTierName(RewardTier t) {
  switch (t) {
    case RewardTier.bronze:
      return 'Silver';
    case RewardTier.silver:
      return 'Gold';
    case RewardTier.gold:
      return 'Platinum';
    case RewardTier.platinum:
      return 'Max';
  }
}
