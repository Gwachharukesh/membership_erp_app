import 'package:flutter/material.dart';
import 'package:mart_erp/features/rewards/model/reward_models.dart';

class TierStatusScreen extends StatelessWidget {
  const TierStatusScreen({
    super.key,
    this.currentTier = RewardTier.silver,
    this.currentPoints = 2450,
  });

  static const routeName = '/tier_status';

  final RewardTier currentTier;
  final int currentPoints;

  @override
  Widget build(BuildContext context) {
    final tiers = RewardTier.values;

    return Scaffold(
      appBar: AppBar(title: const Text('Tier Status')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...tiers.map((tier) => _TierCard(
              tier: tier,
              isCurrent: tier == currentTier,
              currentPoints: currentPoints,
            )),
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.tier,
    required this.isCurrent,
    required this.currentPoints,
  });

  final RewardTier tier;
  final bool isCurrent;
  final int currentPoints;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = currentPoints >= tier.minPoints;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCurrent ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _tierColor(tier),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tier.displayName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  const Chip(label: Text('Current')),
                ],
                if (!isUnlocked) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text('${tier.minPoints} pts needed'),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(_benefits(tier), style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Color _tierColor(RewardTier t) {
    switch (t) {
      case RewardTier.bronze: return const Color(0xFFCD7F32);
      case RewardTier.silver: return const Color(0xFFC0C0C0);
      case RewardTier.gold: return const Color(0xFFFFD700);
      case RewardTier.platinum: return const Color(0xFFE5E4E2);
    }
  }

  String _benefits(RewardTier t) {
    switch (t) {
      case RewardTier.bronze: return '• 10 pts per NPR 100\n• Birthday bonus +500\n• Daily check-in +10 pts';
      case RewardTier.silver: return '• All Bronze benefits\n• 1.2x points multiplier\n• Free delivery on orders over NPR 2000';
      case RewardTier.gold: return '• All Silver benefits\n• 1.5x points multiplier\n• Exclusive Gold rewards\n• Priority support';
      case RewardTier.platinum: return '• All Gold benefits\n• 2x points multiplier\n• Early access to sales\n• VIP events';
    }
  }
}
