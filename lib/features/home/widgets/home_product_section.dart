import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';
import 'package:mart_erp/common/widgets/smart_product_card.dart';
import 'package:mart_erp/features/home/model/home_models.dart';

/// Flipkart-style horizontal product list.
class HomeProductSection extends StatelessWidget {
  const HomeProductSection({
    super.key,
    required this.products,
    required this.isLoading,
    this.onProductTap,
  });

  final List<HomeProduct> products;
  final bool isLoading;
  final void Function(HomeProduct)? onProductTap;

  static const double _listHeight = 280;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _listHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemCount: 4,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: ShimmerProductCard(width: 150),
          ),
        ),
      );
    }

    return SizedBox(
      height: _listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: onProductTap != null ? () => onProductTap!(p) : null,
              child: SmartProductCard(
                name: p.name,
                price: p.price,
                imageUrl: p.imageUrl,
                originalPrice: p.originalPrice,
                discountPercent: p.discountPercent,
                pointsEarn: p.pointsEarn,
                width: 150,
                onAddToCart: () {},
                onWishlistToggle: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
