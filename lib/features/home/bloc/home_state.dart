import 'package:equatable/equatable.dart';

import '../model/home_models.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoadedState extends HomeState {
  const HomeLoadedState({
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

  @override
  List<Object?> get props => [banners, categories, topProducts, flashDeals, newArrivals, recommended];
}

class HomeErrorState extends HomeState {
  const HomeErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
