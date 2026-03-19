import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Green pill with coin icon and point count. Uses theme AppColors.points.
class RewardPointsBadge extends StatelessWidget {
  const RewardPointsBadge({
    super.key,
    required this.points,
    this.size = 18,
    this.showIcon = true,
  });

  final int points;
  final double size;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.pointsContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.points.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(Icons.monetization_on, size: size, color: colors.points),
            const SizedBox(width: 4),
          ],
          Text(
            '$points pts',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.points,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
