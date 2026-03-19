import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/common/widgets/countdown_timer.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';
import 'package:mart_erp/common/widgets/smart_product_card.dart';
import 'package:mart_erp/features/home/bloc/home_bloc.dart';
import 'package:mart_erp/features/home/bloc/home_event.dart';
import 'package:mart_erp/features/home/bloc/home_state.dart';
import 'package:mart_erp/features/home/model/home_models.dart';

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

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadedState) _startBannerAutoScroll(state.banners);
        },
        builder: (context, state) {
          if (state is HomeErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<HomeBloc>().add(const HomeLoadEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final isLoading = state is HomeLoading;
          final loaded = state is HomeLoadedState;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: _HomeAppBarContent(),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BannerSection(
                      banners: loaded ? state.banners : [],
                      isLoading: isLoading,
                      bannerController: _bannerController,
                    ),
                    const SizedBox(height: 20),
                    _CategorySection(
                      categories: loaded ? state.categories : [],
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    _SectionHeader(
                      title: 'Top Products',
                      isLoading: isLoading,
                    ),
                    _HorizontalProductList(
                      products: loaded ? state.topProducts : [],
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    _FlashDealsSection(
                      products: loaded ? state.flashDeals : [],
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    _SectionHeader(title: 'New Arrivals', isLoading: isLoading),
                    _HorizontalProductList(
                      products: loaded ? state.newArrivals : [],
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    _SectionHeader(
                      title: 'Recommended For You',
                      isLoading: isLoading,
                    ),
                    _HorizontalProductList(
                      products: loaded ? state.recommended : [],
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeAppBarContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Mart ERP',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                _LocationSelector(),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerDots extends StatefulWidget {
  const _BannerDots({required this.controller, required this.count});

  final PageController controller;
  final int count;

  @override
  State<_BannerDots> createState() => _BannerDotsState();
}

class _BannerDotsState extends State<_BannerDots> {
  int _page = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    if (widget.controller.hasClients) {
      final page = (widget.controller.page ?? 0).round();
      if (page != _page) setState(() => _page = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.count,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _page == i ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _page == i
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              'Location',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class _BannerSection extends StatelessWidget {
  const _BannerSection({
    required this.banners,
    required this.isLoading,
    required this.bannerController,
  });

  final List<HomeBanner> banners;
  final bool isLoading;
  final PageController bannerController;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ShimmerBanner(height: 160),
      );
    }

    if (banners.isEmpty) return const SizedBox.shrink();

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.discountContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: colors.discount),
                    const SizedBox(width: 6),
                    CountdownTimer(
                      endTime: flashSaleEnd,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.discount,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: bannerController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: banner.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerBanner(height: 160),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.image, size: 48, color: theme.colorScheme.outline),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _BannerDots(
          controller: bannerController,
          count: banners.length,
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.categories,
    required this.isLoading,
  });

  final List<HomeCategory> categories;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 12,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: 12),
            child: ShimmerCategoryChip(),
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Icon(
                        IconData(cat.iconCodePoint, fontFamily: 'MaterialIcons'),
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 72,
                  child: Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.isLoading = false,
  });

  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ShimmerLoader(width: 120, height: 24, borderRadius: 4),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  const _HorizontalProductList({
    required this.products,
    required this.isLoading,
  });

  final List<HomeProduct> products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const height = 260.0;

    if (isLoading) {
      return SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: 4,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: 12),
            child: ShimmerProductCard(),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SmartProductCard(
              name: p.name,
              price: p.price,
              imageUrl: p.imageUrl,
              originalPrice: p.originalPrice,
              discountPercent: p.discountPercent,
              pointsEarn: p.pointsEarn,
              onAddToCart: () {},
              onWishlistToggle: () {},
            ),
          );
        },
      ),
    );
  }
}

class _FlashDealsSection extends StatelessWidget {
  const _FlashDealsSection({
    required this.products,
    required this.isLoading,
  });

  final List<HomeProduct> products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final flashSaleEnd = DateTime.now().add(const Duration(hours: 8));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Flash Deals',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.discount,
                ),
              ),
              const SizedBox(width: 12),
              if (!isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.discountContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CountdownTimer(
                    endTime: flashSaleEnd,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.discount,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _HorizontalProductList(products: products, isLoading: isLoading),
      ],
    );
  }
}
