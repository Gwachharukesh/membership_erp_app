import 'package:flutter/material.dart';
import 'package:mart_erp/features/dashboard-summary/service/dashboard_summary_service.dart';

import '../model/home_models.dart';
import 'home_repository.dart';

/// Mock implementation - replace with API/Firestore in production.
class HomeRepositoryImpl implements HomeRepository {
  static final _categoryIcons = [
    Icons.rice_bowl,
    Icons.lunch_dining,
    Icons.cake,
    Icons.coffee,
    Icons.restaurant,
    Icons.icecream,
    Icons.bakery_dining,
    Icons.local_bar,
    Icons.egg,
    Icons.set_meal,
    Icons.ramen_dining,
    Icons.breakfast_dining,
  ];

  // Constant mapping from category index to IconData for proper tree-shaking
  static IconData getIconForCategory(int index) {
    return _categoryIcons[index.clamp(0, _categoryIcons.length - 1)];
  }

  @override
  Future<HomeData> loadHomeData() async {
    // Load dashboard summary and home data in parallel
    final dashboardFuture = getDashboardSummary();

    await Future.delayed(const Duration(milliseconds: 1500));

    final banners = [
      const HomeBanner(
        id: '1',
        imageUrl: 'https://picsum.photos/800/400?random=1',
        title: 'Banner 1',
      ),
      const HomeBanner(
        id: '2',
        imageUrl: 'https://picsum.photos/800/400?random=2',
        title: 'Banner 2',
      ),
      const HomeBanner(
        id: '3',
        imageUrl: 'https://picsum.photos/800/400?random=3',
        title: 'Banner 3',
      ),
    ];

    const categoryNames = [
      'Rice',
      'Meals',
      'Cakes',
      'Coffee',
      'Snacks',
      'Ice Cream',
      'Bakery',
      'Beverages',
      'Eggs',
      'Combos',
      'Noodles',
      'Breakfast',
    ];
    final categories = List.generate(
      12,
      (i) => HomeCategory(
        id: 'c$i',
        name: categoryNames[i],
        iconCodePoint: i, // Store index instead of codePoint
      ),
    );

    final baseProducts = [
      const HomeProduct(
        id: 'p1',
        name: 'Wireless Headphones Pro',
        price: 2999,
        originalPrice: 3999,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
        discountPercent: 25,
        pointsEarn: 10,
      ),
      const HomeProduct(
        id: 'p2',
        name: 'Smart Watch Ultra',
        price: 4999,
        originalPrice: 6999,
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
        discountPercent: 28,
        pointsEarn: 15,
      ),
      const HomeProduct(
        id: 'p3',
        name: 'Premium Coffee Maker',
        price: 2199,
        imageUrl:
            'https://images.unsplash.com/photo-1517668808822-9ebb02ae2a0e?w=300&h=300&fit=crop',
        pointsEarn: 8,
      ),
      const HomeProduct(
        id: 'p4',
        name: '4K Webcam HD',
        price: 5999,
        originalPrice: 7999,
        imageUrl:
            'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=300&h=300&fit=crop',
        discountPercent: 25,
        pointsEarn: 20,
        isFlashDeal: true,
      ),
      const HomeProduct(
        id: 'p5',
        name: 'Portable Speaker Max',
        price: 3499,
        imageUrl:
            'https://images.unsplash.com/photo-1589003077984-894e133dabab?w=300&h=300&fit=crop',
        pointsEarn: 12,
      ),
    ];

    final dashboardSummary = await dashboardFuture;

    return HomeData(
      banners: banners,
      categories: categories,
      topProducts: baseProducts,
      flashDeals: baseProducts.where((p) => p.isFlashDeal).toList(),
      newArrivals: baseProducts.take(3).toList(),
      recommended: baseProducts,
      dashboardSummary: dashboardSummary,
    );
  }
}
