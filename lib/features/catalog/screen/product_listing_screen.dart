import 'package:flutter/material.dart';
import 'package:mart_erp/common/widgets/smart_product_card.dart';
import 'package:mart_erp/features/catalog/model/catalog_product.dart';
import 'package:mart_erp/features/catalog/repository/catalog_repository_impl.dart';
import 'package:mart_erp/features/catalog/screen/product_detail_screen.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _repo = CatalogRepositoryImpl();
  List<CatalogProduct>? _products;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.getProductsByCategory(widget.categoryId);
    setState(() {
      _products = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _products!.length,
              itemBuilder: (context, index) {
                final p = _products![index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(productId: p.id),
                    ),
                  ),
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
