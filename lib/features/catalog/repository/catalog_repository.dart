import '../model/catalog_product.dart';
import '../../home/model/home_models.dart';

abstract class CatalogRepository {
  Future<List<HomeCategory>> getCategories();
  Future<List<CatalogProduct>> getProductsByCategory(String categoryId);
  Future<CatalogProduct?> getProductById(String productId);
}
