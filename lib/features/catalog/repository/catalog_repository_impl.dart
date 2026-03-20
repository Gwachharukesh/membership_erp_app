import 'package:flutter/material.dart';

import '../model/catalog_product.dart';
import '../../home/model/home_models.dart';
import 'catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  static final _categoryIcons = [
    Icons.rice_bowl, Icons.lunch_dining, Icons.cake, Icons.coffee,
    Icons.restaurant, Icons.icecream, Icons.bakery_dining, Icons.local_bar,
    Icons.egg, Icons.set_meal, Icons.ramen_dining, Icons.breakfast_dining,
  ];

  static const _categoryNames = [
    'Rice', 'Meals', 'Cakes', 'Coffee', 'Snacks', 'Ice Cream',
    'Bakery', 'Beverages', 'Eggs', 'Combos', 'Noodles', 'Breakfast',
  ];

  static final _products = [
    const CatalogProduct(id: 'p1', name: 'Product A', price: 299, originalPrice: 399, imageUrl: 'https://picsum.photos/200/200?random=1', discountPercent: 25, pointsEarn: 10, categoryId: 'c0'),
    const CatalogProduct(id: 'p2', name: 'Product B', price: 449, originalPrice: 549, imageUrl: 'https://picsum.photos/200/200?random=2', discountPercent: 18, pointsEarn: 15, categoryId: 'c0'),
    const CatalogProduct(id: 'p3', name: 'Product C', price: 199, imageUrl: 'https://picsum.photos/200/200?random=3', pointsEarn: 5, categoryId: 'c1'),
    const CatalogProduct(id: 'p4', name: 'Product D', price: 599, originalPrice: 799, imageUrl: 'https://picsum.photos/200/200?random=4', discountPercent: 25, pointsEarn: 25, isFlashDeal: true, categoryId: 'c2'),
    const CatalogProduct(id: 'p5', name: 'Product E', price: 349, imageUrl: 'https://picsum.photos/200/200?random=5', pointsEarn: 12, categoryId: 'c2'),
  ];

  @override
  Future<List<HomeCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(12, (i) => HomeCategory(
      id: 'c$i',
      name: _categoryNames[i],
      iconCodePoint: _categoryIcons[i].codePoint,
    ));
  }

  @override
  Future<List<CatalogProduct>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_products);
  }

  @override
  Future<CatalogProduct?> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }
}
