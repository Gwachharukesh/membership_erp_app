import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/countdown_timer.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/home/widgets/home_product_section.dart';
import 'package:mart_erp/features/home/model/home_models.dart';

/// Flipkart-style Flash Deals section with countdown.
class HomeFlashDealsSection extends StatelessWidget {
  const HomeFlashDealsSection({
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
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final flashSaleEnd = DateTime.now().add(const Duration(hours: 8));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                size: 20,
                color: colors.discount,
              ),
              const SizedBox(width: 8),
              Text(
                'Deals of the Day',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              if (!isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.discountContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CountdownTimer(
                    endTime: flashSaleEnd,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.discount,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        HomeProductSection(
          products: products,
          isLoading: isLoading,
          onProductTap: onProductTap,
        ),
      ],
    );
  }
}
