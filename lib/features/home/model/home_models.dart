import 'package:equatable/equatable.dart';

class HomeBanner extends Equatable {
  const HomeBanner({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
  });

  final String id;
  final String imageUrl;
  final String? title;
  final String? link;

  @override
  List<Object?> get props => [id, imageUrl];
}

class HomeCategory extends Equatable {
  const HomeCategory({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.imageUrl,
  });

  final String id;
  final String name;

  /// Material Icons codePoint for Icon(IconData(codePoint, fontFamily: 'MaterialIcons'))
  final int iconCodePoint;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name];
}

class HomeProduct extends Equatable {
  const HomeProduct({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.rating,
    this.isFlashDeal = false,
    this.discountPercent,
    this.pointsEarn = 0,
    this.isWishlisted = false,
  });

  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double? rating;
  final bool isFlashDeal;
  final int? discountPercent;
  final int pointsEarn;
  final bool isWishlisted;

  @override
  List<Object?> get props => [id, name, price];
}
