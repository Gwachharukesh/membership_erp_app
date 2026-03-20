import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/shimmer_loader.dart';
import 'package:mart_erp/features/home/model/home_models.dart';

/// Flipkart-style banner carousel.
class HomeBannerSection extends StatefulWidget {
  const HomeBannerSection({
    super.key,
    required this.banners,
    required this.isLoading,
    this.controller,
  });

  final List<HomeBanner> banners;
  final bool isLoading;
  final PageController? controller;

  @override
  State<HomeBannerSection> createState() => _HomeBannerSectionState();
}

class _HomeBannerSectionState extends State<HomeBannerSection> {
  late PageController _controller;
  bool _ownsController = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = PageController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ShimmerBanner(height: 150),
      );
    }

    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: banner.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerBanner(height: 150),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _BannerDots(
          count: widget.banners.length,
          current: _page,
        ),
      ],
    );
  }
}

class _BannerDots extends StatelessWidget {
  const _BannerDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: current == i ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: current == i
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
