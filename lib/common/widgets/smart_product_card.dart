import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/theme/app_colors.dart';

/// Product card with image, name, prices, discount badge, points badge, add-to-cart.
class SmartProductCard extends StatelessWidget {
  const SmartProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.discountPercent,
    this.pointsEarn = 0,
    this.onAddToCart,
    this.onWishlistToggle,
    this.isWishlisted = false,
    this.width = 160,
  });

  final String name;
  final double price;
  final String imageUrl;
  final double? originalPrice;
  final int? discountPercent;
  final int pointsEarn;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistToggle;
  final bool isWishlisted;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : (width > 0 ? width.toDouble() : 160.0);
        final hasBoundedHeight =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0;

        final contentSection = Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (originalPrice != null && originalPrice! > price)
                    Text(
                      'NPR ${originalPrice!.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  if (originalPrice != null && originalPrice! > price)
                    const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'NPR ${price.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              // if (pointsEarn > 0) ...[
              //   const SizedBox(height: 4),
              //   RewardPointsBadge(points: pointsEarn, size: 14),
              // ],
              if (onAddToCart != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onAddToCart,
                    icon: Icon(
                      color: theme.colorScheme.primary,
                      Icons.add_shopping_cart,
                      size: 16,
                    ),
                    label: Text(
                      'Add',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary.withAlpha(25),
                      // padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );

        return SizedBox(
          width: effectiveWidth,
          height: hasBoundedHeight ? constraints.maxHeight : null,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: hasBoundedHeight
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Shimmer.fromColors(
                                  baseColor: isDark
                                      ? Colors.grey[800]!
                                      : Colors.grey[300]!,
                                  highlightColor: isDark
                                      ? Colors.grey[600]!
                                      : Colors.grey[100]!,
                                  child: Container(color: theme.cardColor),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                            if (discountPercent != null && discountPercent! > 0)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.discount,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-$discountPercent%',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (onWishlistToggle != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isWishlisted
                                        ? colors.error
                                        : theme.colorScheme.outline,
                                    size: 20,
                                  ),
                                  onPressed: onWishlistToggle,
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.cardColor.withValues(
                                      alpha: 0.9,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    minimumSize: Size.zero,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: contentSection,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Shimmer.fromColors(
                                baseColor: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!,
                                highlightColor: isDark
                                    ? Colors.grey[600]!
                                    : Colors.grey[100]!,
                                child: Container(color: theme.cardColor),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
                          if (discountPercent != null && discountPercent! > 0)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.discount,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-$discountPercent%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (onWishlistToggle != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isWishlisted
                                      ? colors.error
                                      : theme.colorScheme.outline,
                                  size: 20,
                                ),
                                onPressed: onWishlistToggle,
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.cardColor.withValues(
                                    alpha: 0.9,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  minimumSize: Size.zero,
                                ),
                              ),
                            ),
                        ],
                      ),
                      contentSection,
                    ],
                  ),
          ),
        );
      },
    );
  }
}
