import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/config/routes/routes.dart';
import 'package:mart_erp/features/catalog/screen/product_detail_screen.dart';
import 'package:mart_erp/features/catalog/screen/product_listing_screen.dart';
import 'package:mart_erp/features/home/bloc/home_bloc.dart';
import 'package:mart_erp/features/home/bloc/home_event.dart';
import 'package:mart_erp/features/home/bloc/home_state.dart';
import 'package:mart_erp/features/home/model/home_models.dart';
import 'package:mart_erp/features/home/widgets/home_banner_section.dart';
import 'package:mart_erp/features/home/widgets/home_category_section.dart';
import 'package:mart_erp/features/home/widgets/home_flash_deals_section.dart';
import 'package:mart_erp/features/home/widgets/home_product_section.dart';
import 'package:mart_erp/features/home/widgets/home_reward_points_card.dart';
import 'package:mart_erp/features/home/widgets/home_search_bar.dart';
import 'package:mart_erp/features/home/widgets/home_section_header.dart';

/// Flipkart-style home screen with search, rewards, categories, and product sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeLoadEvent());
  }

  void _startBannerAutoScroll(List<HomeBanner> banners) {
    _bannerTimer?.cancel();
    if (banners.length <= 1) return;
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_bannerController.hasClients) return;
      final page = (_bannerController.page?.round() ?? 0) + 1;
      final next = page >= banners.length ? 0 : page;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _onRefresh() async {
    context.read<HomeBloc>().add(const HomeLoadEvent());
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _navigateToProduct(BuildContext context, HomeProduct p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: p.id)),
    );
  }

  void _navigateToCategory(BuildContext context, HomeCategory cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductListingScreen(categoryId: cat.id, categoryName: cat.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadedState) _startBannerAutoScroll(state.banners);
        },
        builder: (context, state) {
          if (state is HomeErrorState) {
            return _ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeLoadEvent()),
            );
          }

          final isLoading = state is HomeLoading;
          final loaded = state is HomeLoadedState;
          final points = loaded ? (state.dashboardSummary?.balPoint ?? 0) : 0;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              slivers: [
                // SliverAppBar(
                //   floating: true,
                //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //   surfaceTintColor: Colors.transparent,
                //   flexibleSpace: const _HomeAppBar(),
                // ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: HomeSearchBar(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: HomeRewardPointsCard(points: points),
                      ),
                      const SizedBox(height: 20),
                      if (loaded && state.banners.isNotEmpty) ...[
                        HomeBannerSection(
                          banners: state.banners,
                          isLoading: isLoading,
                          controller: _bannerController,
                        ),
                        const SizedBox(height: 24),
                      ],
                      HomeSectionHeader(
                        title: 'Shop by Category',
                        actionLabel: 'See All',
                        onAction: () => Navigator.pushNamed(
                          context,
                          RouteHelper.categories,
                        ),
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 12),
                      HomeCategorySection(
                        categories: loaded ? state.categories : [],
                        isLoading: isLoading,
                        onCategoryTap: (cat) =>
                            _navigateToCategory(context, cat),
                      ),
                      const SizedBox(height: 24),
                      HomeSectionHeader(
                        title: 'Deals of the Day',
                        isLoading: isLoading,
                      ),
                      HomeFlashDealsSection(
                        products: loaded ? state.flashDeals : [],
                        isLoading: isLoading,
                        onProductTap: (p) => _navigateToProduct(context, p),
                      ),
                      const SizedBox(height: 24),
                      HomeSectionHeader(
                        title: 'Top Products',
                        isLoading: isLoading,
                      ),
                      HomeProductSection(
                        products: loaded ? state.topProducts : [],
                        isLoading: isLoading,
                        onProductTap: (p) => _navigateToProduct(context, p),
                      ),
                      const SizedBox(height: 24),
                      HomeSectionHeader(
                        title: 'New Arrivals',
                        isLoading: isLoading,
                      ),
                      HomeProductSection(
                        products: loaded ? state.newArrivals : [],
                        isLoading: isLoading,
                        onProductTap: (p) => _navigateToProduct(context, p),
                      ),
                      const SizedBox(height: 24),
                      HomeSectionHeader(
                        title: 'Recommended for You',
                        isLoading: isLoading,
                      ),
                      HomeProductSection(
                        products: loaded ? state.recommended : [],
                        isLoading: isLoading,
                        onProductTap: (p) => _navigateToProduct(context, p),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
