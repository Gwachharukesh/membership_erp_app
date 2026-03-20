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

/// Shimmer placeholder for a product card (Flipkart-style).
class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key, this.width = 160});

  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;

    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Placeholder
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: width - 16, // Square aspect ratio for product
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Product Name Line 1
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Product Name Line 2 (Shorter)
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              width: width * 0.7,
              height: 10,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Rating/Reviews placeholder
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              width: width * 0.5,
              height: 8,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Price placeholder
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              width: width * 0.6,
              height: 12,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Discount/Original price placeholder
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
            child: Container(
              width: width * 0.5,
              height: 10,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
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
