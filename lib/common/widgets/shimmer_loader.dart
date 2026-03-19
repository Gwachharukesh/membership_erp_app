import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Generic skeleton placeholder for loading states.
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a product card.
class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key, this.width = 160});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      width: width,
      height: 220,
      borderRadius: 12,
    );
  }
}

/// Shimmer placeholder for a banner.
class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key, this.height = 160});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      width: double.infinity,
      height: height,
      borderRadius: 12,
    );
  }
}

/// Shimmer placeholder for a category chip.
class ShimmerCategoryChip extends StatelessWidget {
  const ShimmerCategoryChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoader(width: 72, height: 80, borderRadius: 16);
  }
}
