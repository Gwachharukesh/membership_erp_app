import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/reward_points_badge.dart';
import 'package:mart_erp/config/theme/app_colors.dart';
import 'package:mart_erp/features/catalog/model/catalog_product.dart';
import 'package:mart_erp/features/catalog/repository/catalog_repository_impl.dart';
import 'package:shimmer/shimmer.dart';

const _sectionGap = 8.0;

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _repo = CatalogRepositoryImpl();
  final _imageController = PageController();
  CatalogProduct? _product;
  bool _loading = true;
  String _selectedUnit = '';
  int _currentImage = 0;
  int _qty = 1;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final p = await _repo.getProductById(widget.productId);
    setState(() {
      _product = p;
      _loading = false;
      if (p != null && p.unitOptions.isNotEmpty) _selectedUnit = p.unitOptions.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingShimmer();
    if (_product == null) return const _NotFoundState();

    final p = _product!;
    final hasDiscount = p.originalPrice != null && p.originalPrice! > p.price;
    final discountPct = hasDiscount ? ((1 - p.price / p.originalPrice!) * 100).round() : 0;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final sectionBg = isDark ? colors.surface : Colors.white;
    final gapColor = isDark ? colors.surfaceContainerHighest : const Color(0xFFF1F1F1);

    return Scaffold(
      backgroundColor: gapColor,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: sectionBg,
            surfaceTintColor: Colors.transparent,
            foregroundColor: colors.onSurface,
            title: Text(
              p.brand ?? 'Product Details',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, size: 22)),
              IconButton(
                onPressed: () => setState(() => _isFav = !_isFav),
                icon: Icon(
                  _isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _isFav ? AppColors.errorColor : null,
                  size: 22,
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, size: 22)),
              const SizedBox(width: 4),
            ],
          ),

          // ── Image Gallery Card ──
          SliverToBoxAdapter(
            child: Container(
              color: sectionBg,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _imageController,
                          onPageChanged: (i) => setState(() => _currentImage = i),
                          itemCount: 1,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.all(24),
                            child: CachedNetworkImage(
                              imageUrl: p.imageUrl,
                              fit: BoxFit.contain,
                              placeholder: (_, __) => const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (_, __, ___) => Icon(
                                Icons.image_outlined,
                                size: 64,
                                color: colors.outline,
                              ),
                            ),
                          ),
                        ),
                        // Image counter badge
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.photo_library_outlined, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  '${_currentImage + 1}/1',
                                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (hasDiscount)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.successColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$discountPct% off',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          // ── Section gap ──
          SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),

          // ── Product Info Card ──
          SliverToBoxAdapter(
            child: Container(
              color: sectionBg,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  if (p.brand != null) ...[
                    Text(
                      p.brand!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Name
                  Text(
                    p.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: colors.onSurface.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Rating row
                  if (p.rating != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _RatingBadge(rating: p.rating!),
                        const SizedBox(width: 10),
                        Text(
                          '1,245 Ratings',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '$discountPct%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.successColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'NPR ',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colors.onSurface,
                        ),
                      ),
                      Text(
                        p.price.toStringAsFixed(0),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: 'M.R.P.: ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                        children: [
                          TextSpan(
                            text: 'NPR ${p.originalPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (p.pointsEarn > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.rewardSurface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.rewardLight),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars_rounded, size: 18, color: AppColors.reward),
                          const SizedBox(width: 6),
                          Text(
                            'Earn ${p.pointsEarn} reward points on this purchase',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.reward,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Section gap ──
          SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),

          // ── Offers Card ──
          SliverToBoxAdapter(
            child: Container(
              color: sectionBg,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_offer_rounded, size: 18, color: AppColors.successColor),
                      const SizedBox(width: 8),
                      Text(
                        'Available Offers',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _OfferTile(
                    icon: Icons.account_balance_outlined,
                    title: 'Bank Offer',
                    desc: '10% off on SBI Credit Card, up to NPR 500 on orders above NPR 1,000',
                  ),
                  _OfferTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Wallet Offer',
                    desc: 'Get NPR 50 cashback using Mart Wallet',
                  ),
                  _OfferTile(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Partner Offer',
                    desc: 'Buy 2, get 5% extra discount',
                    showDivider: false,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all offers',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Section gap ──
          SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),

          // ── Size / Unit Options ──
          if (p.unitOptions.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Container(
                color: sectionBg,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Size',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: p.unitOptions.map((u) {
                          final selected = _selectedUnit == u;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => setState(() => _selectedUnit = u),
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: selected ? colors.primary.withValues(alpha: 0.08) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: selected ? colors.primary : colors.outline.withValues(alpha: 0.25),
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    u,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: selected ? colors.primary : colors.onSurface,
                                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),
          ],

          // ── Delivery & Services ──
          SliverToBoxAdapter(
            child: Container(
              color: sectionBg,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery & Services',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  _ServiceRow(
                    icon: Icons.local_shipping_outlined,
                    title: 'Free Delivery',
                    subtitle: 'Estimated delivery by 3-5 business days',
                    iconBg: colors.primary.withValues(alpha: 0.1),
                    iconColor: colors.primary,
                  ),
                  const SizedBox(height: 14),
                  _ServiceRow(
                    icon: p.inStock ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
                    title: p.inStock ? 'In Stock' : 'Out of Stock',
                    subtitle: p.inStock ? 'Ships from Mart Warehouse' : 'Currently unavailable',
                    iconBg: p.inStock
                        ? AppColors.successColor.withValues(alpha: 0.1)
                        : AppColors.errorColor.withValues(alpha: 0.1),
                    iconColor: p.inStock ? AppColors.successColor : AppColors.errorColor,
                  ),
                  const SizedBox(height: 14),
                  _ServiceRow(
                    icon: Icons.cached_rounded,
                    title: '7 Day Return Policy',
                    subtitle: 'Free returns within 7 days of delivery',
                    iconBg: AppColors.reward.withValues(alpha: 0.1),
                    iconColor: AppColors.reward,
                  ),
                  const SizedBox(height: 14),
                  _ServiceRow(
                    icon: Icons.verified_user_outlined,
                    title: 'Authentic Product',
                    subtitle: '100% genuine product guaranteed',
                    iconBg: colors.primary.withValues(alpha: 0.1),
                    iconColor: colors.primary,
                  ),
                ],
              ),
            ),
          ),

          // ── Section gap ──
          SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),

          // ── Highlights ──
          SliverToBoxAdapter(
            child: Container(
              color: sectionBg,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Highlights',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _BulletPoint(text: p.inStock ? 'Available for immediate dispatch' : 'Currently out of stock'),
                  if (p.brand != null) _BulletPoint(text: 'From trusted brand: ${p.brand}'),
                  if (p.pointsEarn > 0)
                    _BulletPoint(text: 'Earn ${p.pointsEarn} reward points on purchase'),
                  if (hasDiscount)
                    _BulletPoint(text: 'Save $discountPct% compared to regular price'),
                  _BulletPoint(text: 'Cash on delivery available'),
                  _BulletPoint(text: 'Quality checked and verified'),
                ],
              ),
            ),
          ),

          // ── Section gap ──
          SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),

          // ── Description ──
          if (p.description != null) ...[
            SliverToBoxAdapter(
              child: Container(
                color: sectionBg,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Description',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.75),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: _sectionGap)),
          ],

          // ── Seller Info ──
          SliverToBoxAdapter(
            child: Container(
              color: sectionBg,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sold by',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mart Official Store',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.successColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '4.5',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          SliverToBoxAdapter(child: SizedBox(height: _sectionGap + 80)),
        ],
      ),

      // ── Bottom CTA Bar ──
      bottomNavigationBar: _BottomBar(
        product: p,
        qty: _qty,
        onQtyChanged: (q) => setState(() => _qty = q),
      ),
    );
  }
}

// ─── Bottom Bar (Flipkart dual CTA) ─────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.product,
    required this.qty,
    required this.onQtyChanged,
  });

  final CatalogProduct product;
  final int qty;
  final ValueChanged<int> onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              // Add to Cart
              Expanded(
                child: InkWell(
                  onTap: product.inStock ? () {} : null,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.outline.withValues(alpha: 0.15)),
                        right: BorderSide(color: colors.outline.withValues(alpha: 0.15)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 20,
                          color: product.inStock
                              ? colors.onSurface
                              : colors.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ADD TO CART',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: product.inStock
                                ? colors.onSurface
                                : colors.onSurface.withValues(alpha: 0.3),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Buy Now
              Expanded(
                child: Material(
                  color: product.inStock ? colors.primary : colors.primary.withValues(alpha: 0.3),
                  child: InkWell(
                    onTap: product.inStock ? () {} : null,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flash_on_rounded, size: 20, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'BUY NOW',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Rating Badge ────────────────────────────────────────────────────────────

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final bgColor = rating >= 4
        ? AppColors.successColor
        : rating >= 3
            ? AppColors.reward
            : AppColors.errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star_rounded, size: 13, color: Colors.white),
        ],
      ),
    );
  }
}

// ─── Offer Tile ──────────────────────────────────────────────────────────────

class _OfferTile extends StatelessWidget {
  const _OfferTile({
    required this.icon,
    required this.title,
    required this.desc,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String desc;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: AppColors.successColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '$title: ',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: desc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: colors.outline.withValues(alpha: 0.12)),
      ],
    );
  }
}

// ─── Service Row ─────────────────────────────────────────────────────────────

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.55),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bullet Point ────────────────────────────────────────────────────────────

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Not Found State ─────────────────────────────────────────────────────────

class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded, size: 40, color: colors.outline),
            ),
            const SizedBox(height: 20),
            Text('Product not found', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'The product may have been removed',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loading Shimmer ─────────────────────────────────────────────────────────

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final base = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final highlight = isDark ? Colors.grey[600]! : Colors.grey[50]!;
    final gapColor = isDark ? theme.colorScheme.surfaceContainerHighest : const Color(0xFFF1F1F1);
    final cardColor = isDark ? theme.colorScheme.surface : Colors.white;

    return Scaffold(
      backgroundColor: gapColor,
      appBar: AppBar(backgroundColor: cardColor, surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image placeholder
            Container(
              color: cardColor,
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: Container(
                  height: 340,
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: _sectionGap),

            // Info placeholder
            Container(
              color: cardColor,
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(cardColor, 80, 14),
                    const SizedBox(height: 10),
                    _box(cardColor, double.infinity, 20),
                    const SizedBox(height: 6),
                    _box(cardColor, 200, 20),
                    const SizedBox(height: 14),
                    _box(cardColor, 60, 16),
                    const SizedBox(height: 8),
                    _box(cardColor, 180, 30),
                    const SizedBox(height: 12),
                    _box(cardColor, 140, 14),
                  ],
                ),
              ),
            ),
            SizedBox(height: _sectionGap),

            // Offers placeholder
            Container(
              color: cardColor,
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(cardColor, 130, 16),
                    const SizedBox(height: 14),
                    _box(cardColor, double.infinity, 14),
                    const SizedBox(height: 10),
                    _box(cardColor, double.infinity, 14),
                    const SizedBox(height: 10),
                    _box(cardColor, 250, 14),
                  ],
                ),
              ),
            ),
            SizedBox(height: _sectionGap),

            // Size placeholder
            Container(
              color: cardColor,
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(cardColor, 40, 16),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _box(cardColor, 70, 42),
                        const SizedBox(width: 10),
                        _box(cardColor, 70, 42),
                        const SizedBox(width: 10),
                        _box(cardColor, 70, 42),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _box(Color color, double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
