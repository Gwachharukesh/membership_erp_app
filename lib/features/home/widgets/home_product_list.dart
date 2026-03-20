import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';
import 'package:mart_erp/common/widgets/smart_product_card.dart';
import 'package:mart_erp/features/home/model/home_models.dart';

/// Horizontal scrollable product list section
class HorizontalProductList extends StatelessWidget {
  const HorizontalProductList({
    super.key,
    required this.products,
    required this.isLoading,
    this.onProductTap,
  });

  final List<HomeProduct> products;
  final bool isLoading;
  final void Function(HomeProduct)? onProductTap;

  @override
  Widget build(BuildContext context) {
    const height = 280.0;

    if (isLoading) {
      return SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: 4,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: 12),
            child: ShimmerProductCard(),
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No products available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SmartProductCard(
              name: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
              originalPrice: product.originalPrice,
              discountPercent: product.discountPercent,
              pointsEarn: product.pointsEarn,
              isWishlisted: product.isWishlisted,
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onWishlistToggle: () {
                // Handle wishlist toggle
              },
            ),
          );
        },
      ),
    );
  }
}
