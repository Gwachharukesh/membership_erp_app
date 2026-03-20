import 'package:flutter/material.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/order/models/order_model.dart';

/// Flipkart-style order card.
class OrderWidget extends StatelessWidget {
  const OrderWidget({
    super.key,
    required this.order,
    this.onTrack,
    this.onReorder,
  });

  final OrderModel order;
  final VoidCallback? onTrack;
  final VoidCallback? onReorder;

  bool get _isCompleted => order.status.toLowerCase() == 'completed';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTrack,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 24,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.orderProducts,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(
                      status: order.status,
                      isCompleted: _isCompleted,
                    ),
                  ],
                ),
                // Track and Buy Again buttons - commented out for now
                // if (_isCompleted && (onTrack != null || onReorder != null)) ...[
                //   const SizedBox(height: 14),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       if (onTrack != null)
                //         OutlinedButton(
                //           onPressed: onTrack,
                //           style: OutlinedButton.styleFrom(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 20,
                //               vertical: 12,
                //             ),
                //             minimumSize: const Size(90, 44),
                //             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           ),
                //           child: Text(
                //             'Track',
                //             style: theme.textTheme.labelLarge?.copyWith(
                //               color: colorScheme.primary,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         ),
                //       if (onTrack != null && onReorder != null)
                //         const SizedBox(width: 12),
                //       if (onReorder != null)
                //         FilledButton(
                //           onPressed: onReorder,
                //           style: FilledButton.styleFrom(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 20,
                //               vertical: 12,
                //             ),
                //             minimumSize: const Size(100, 44),
                //             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           ),
                //           child: Text(
                //             'Buy Again',
                //             style: theme.textTheme.labelLarge?.copyWith(
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.isCompleted,
  });

  final String status;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCompleted ? AppColors.successColor : AppColors.errorColor;
    final bgColor = isCompleted
        ? AppColors.successLight.withValues(alpha: 0.8)
        : AppColors.errorLight.withValues(alpha: 0.8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
