import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';

/// Generic section header
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.isLoading = false});

  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ShimmerLoader(width: 200, height: 24, borderRadius: 4),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Section header with action button
class SectionHeaderWithAction extends StatelessWidget {
  const SectionHeaderWithAction({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.isLoading = false,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ShimmerLoader(width: 200, height: 24, borderRadius: 4),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
