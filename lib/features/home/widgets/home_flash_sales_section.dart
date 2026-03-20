import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/countdown_timer.dart';
import 'package:mart_erp/features/home/model/home_models.dart';

import 'home_product_list.dart';

/// Flash sales banner and product section
class FlashSalesSection extends StatelessWidget {
  const FlashSalesSection({
    super.key,
    required this.isLoading,
    this.products = const [],
    this.onProductTap,
  });

  final bool isLoading;
  final List<HomeProduct> products;
  final void Function(HomeProduct)? onProductTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading || products.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final flashSaleEnd = DateTime.now().add(const Duration(hours: 4));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flash Sale Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flash Sales',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    CountdownTimer(
                      endTime: flashSaleEnd,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Products List
        HorizontalProductList(
          products: products,
          isLoading: isLoading,
          onProductTap: onProductTap,
        ),
      ],
    );
  }
}
