import 'package:equatable/equatable.dart';

class CatalogProduct extends Equatable {
  const CatalogProduct({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.brand,
    this.description,
    this.rating,
    this.isFlashDeal = false,
    this.discountPercent,
    this.pointsEarn = 0,
    this.categoryId,
    this.unitOptions = const ['250g', '500g', '1kg'],
    this.inStock = true,
  });

  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String? brand;
  final String? description;
  final double? rating;
  final bool isFlashDeal;
  final int? discountPercent;
  final int pointsEarn;
  final String? categoryId;
  final List<String> unitOptions;
  final bool inStock;

  @override
  List<Object?> get props => [id, name, price];
}
