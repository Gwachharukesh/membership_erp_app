import '../model/home_models.dart';

abstract class HomeRepository {
  Future<HomeData> loadHomeData();
}

class HomeData {
  const HomeData({
    required this.banners,
    required this.categories,
    required this.topProducts,
    required this.flashDeals,
    required this.newArrivals,
    required this.recommended,
  });

  final List<HomeBanner> banners;
  final List<HomeCategory> categories;
  final List<HomeProduct> topProducts;
  final List<HomeProduct> flashDeals;
  final List<HomeProduct> newArrivals;
  final List<HomeProduct> recommended;
}
