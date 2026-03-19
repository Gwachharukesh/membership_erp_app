import 'package:flutter/material.dart';

import '../model/home_models.dart';
import 'home_repository.dart';

/// Mock implementation - replace with API/Firestore in production.
class HomeRepositoryImpl implements HomeRepository {
  static final _categoryIcons = [
    Icons.rice_bowl, Icons.lunch_dining, Icons.cake, Icons.coffee,
    Icons.restaurant, Icons.icecream, Icons.bakery_dining, Icons.local_bar,
    Icons.egg, Icons.set_meal, Icons.ramen_dining, Icons.breakfast_dining,
  ];

  @override
  Future<HomeData> loadHomeData() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final banners = [
      const HomeBanner(id: '1', imageUrl: 'https://picsum.photos/800/400?random=1', title: 'Banner 1'),
      const HomeBanner(id: '2', imageUrl: 'https://picsum.photos/800/400?random=2', title: 'Banner 2'),
      const HomeBanner(id: '3', imageUrl: 'https://picsum.photos/800/400?random=3', title: 'Banner 3'),
    ];

    const categoryNames = [
      'Rice', 'Meals', 'Cakes', 'Coffee', 'Snacks', 'Ice Cream',
      'Bakery', 'Beverages', 'Eggs', 'Combos', 'Noodles', 'Breakfast',
    ];
    final categories = List.generate(12, (i) => HomeCategory(
      id: 'c$i',
      name: categoryNames[i],
      iconCodePoint: _categoryIcons[i].codePoint,
    ));

    final baseProducts = [
      const HomeProduct(id: 'p1', name: 'Product A', price: 299, originalPrice: 399, imageUrl: 'https://picsum.photos/200/200?random=1', discountPercent: 25, pointsEarn: 10),
      const HomeProduct(id: 'p2', name: 'Product B', price: 449, originalPrice: 549, imageUrl: 'https://picsum.photos/200/200?random=2', discountPercent: 18, pointsEarn: 15),
      const HomeProduct(id: 'p3', name: 'Product C', price: 199, imageUrl: 'https://picsum.photos/200/200?random=3', pointsEarn: 5),
      const HomeProduct(id: 'p4', name: 'Product D', price: 599, originalPrice: 799, imageUrl: 'https://picsum.photos/200/200?random=4', discountPercent: 25, pointsEarn: 25, isFlashDeal: true),
      const HomeProduct(id: 'p5', name: 'Product E', price: 349, imageUrl: 'https://picsum.photos/200/200?random=5', pointsEarn: 12),
    ];

    return HomeData(
      banners: banners,
      categories: categories,
      topProducts: baseProducts,
      flashDeals: baseProducts.where((p) => p.isFlashDeal).toList(),
      newArrivals: baseProducts.take(3).toList(),
      recommended: baseProducts,
    );
  }
}
